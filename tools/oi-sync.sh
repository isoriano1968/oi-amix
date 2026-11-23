#!/bin/bash
# oi-sync.sh -- copy this repo's oi-userland-style components (packages/)
# into the oi-userland checkout on an OpenIndiana build machine, so they build with
# OI's own make-rules.  Runs on your workstation, over ssh.
#
#   packages/<category>/<name>/  ->  ~/src/oi-userland/components/<category>/<name>/
#
# Only directories that hold a Makefile are copied.  Nothing on the build
# machine is deleted or replaced by another type without being shown first:
#
# - What exists only at a component's top there is kept (unpacked sources,
#   links to source trees, pkg5, stamps, logs), except *.p5m, *.license
#   (gmake takes every *.p5m it finds) and our own directories: patches,
#   npm-patches, files, test and includes, also as links.
# - Those, anything only there inside our own directories, and anything the
#   repository would replace with another type (a link by a directory) are
#   listed, and the run stops before it has written anything.  Run again
#   with --delete once the list holds only what was changed here on purpose.
#
# Besides the components, a real run writes the checkout's tools/pkglintrc.
#
# Usage:  tools/oi-sync.sh [-n | --delete] [component-path ...]   (default: all)
#           -n        show what would be copied or deleted; write nothing
#           --delete  also delete or replace what the check lists
#         OI_HOST=user@oi-build OI_USERLAND=src/oi-userland tools/oi-sync.sh
# Exit:   3 = stopped, deletions need --delete
set -e
dry= del=
while [ $# -gt 0 ]; do
	case $1 in
	-n) dry=1 ;;
	--delete) del=1 ;;
	-*) echo "oi-sync.sh: unknown option $1" >&2; exit 2 ;;
	*) break ;;
	esac
	shift
done
HOST="${OI_HOST:?set OI_HOST to the build machine, user@host}"
DEST="${OI_USERLAND:-src/oi-userland}"
TOP="$(cd "$(dirname "$0")/.." && pwd)"
E="ssh ${OI_SSH_OPTS:--o BatchMode=yes}"

cd "$TOP/packages"
if [ $# -gt 0 ]; then
	comps=("$@")
else
	mapfile -t comps < <(find . -name Makefile -not -path '*/patches/*' \
		-printf '%h\n' | sed 's|^\./||' | sort)
fi
[ ${#comps[@]} -gt 0 ] || { echo "oi-sync.sh: no components in packages/"; exit 0; }

$E "$HOST" "test -f $DEST/make-rules/shared-macros.mk" ||
	{ echo "oi-sync.sh: no oi-userland checkout at $HOST:$DEST" >&2; exit 1; }

# rsync for one component, with extra options in front.  The first matching
# filter wins: 'P /*' keeps what only the build machine has at the top
# ('P /*/' matched only real directories, so links and files were deleted).
sync_one() {	# component [rsync options]
	local c=$1; shift
	rsync -a "$@" \
		--filter 'R /*.p5m' --filter 'R /*.license' \
		--filter 'R /patches' --filter 'R /npm-patches' \
		--filter 'R /files' --filter 'R /test' --filter 'R /includes' \
		--filter 'P /*' \
		--exclude '/build' --exclude '/*.log' --exclude '/*.tar.*' \
		--exclude '/*.zip' --exclude '/*.tgz' --exclude '/*.mog.*' \
		-e "$E" "$c/" "$HOST:$DEST/components/$c/"
}

# Check every component before the first write.
doomed=
for i in "${!comps[@]}"; do
	c="${comps[$i]#packages/}"; c="${c%/}"; comps[$i]=$c
	[ -f "$c/Makefile" ] || { echo "oi-sync.sh: $c: no Makefile" >&2; exit 1; }
	state=$($E "$HOST" "if [ -d $DEST/components/$c ]; then echo present; else echo new; fi")
	if [ "$state" = new ]; then
		[ -z "$dry" ] || echo "new component: $c"
		continue
	fi
	[ "$state" = present ] || { echo "oi-sync.sh: cannot check $c on $HOST" >&2; exit 1; }
	# -8 and %n: names as they are, without " -> target" or escapes
	plan=$(sync_one "$c" --delete -n -8 --out-format='%i %n')
	created=
	while IFS= read -r line; do
		case $line in
		'*deleting '*)
			f=${line#\*deleting}; f=${f#"${f%%[! ]*}"}
			echo "would delete: $c/$f" >&2	# stderr: oi-pipeline.sh drops stdout
			doomed=1 ;;
		'' | .*) ;;	# nothing, or attributes only
		*)	[ -z "$dry" ] || echo "would copy:   $c: $line"
			case $line in
			??+++++++++' '*)
				f=${line#* }
				created+=${f%/}$'\n' ;;
			esac ;;
		esac
	done <<<"$plan"
	# rsync calls an entry of another type "new" and replaces it, --delete or not
	[ -n "$created" ] || continue
	replaced=$(printf %s "$created" | $E "$HOST" "cd $DEST/components/$c && while IFS= read -r p; do if [ -h \"\$p\" ]; then echo \"l \$p\"; elif [ -d \"\$p\" ]; then echo \"d \$p\"; elif [ -e \"\$p\" ]; then echo \"f \$p\"; fi; done")
	while IFS= read -r line; do
		[ -n "$line" ] || continue
		how="another type there"
		case $line in "d "*) how="a directory there: replaced with its contents" ;; esac
		echo "would replace: $c/${line#? } ($how)" >&2
		doomed=1
	done <<<"$replaced"
done
[ -z "$dry" ] || { echo "oi-sync.sh: dry run, nothing written"; exit 0; }
if [ -n "$doomed" ] && [ -z "$del" ]; then
	echo "oi-sync.sh: stopped, nothing written: see the list above." >&2
	echo "oi-sync.sh: rerun with --delete if all of it was changed here on purpose." >&2
	exit 3
fi

# pkglint (userland.manifest1001) refuses dependencies on packages from
# publishers other than OI's.  Our components depend on each other through
# the local publisher oi-gnome (e.g. polkit -> library/duktape), so allow it
# in the checkout's tools/pkglintrc (the make-rules hard-code that path).
# Idempotent; the only local change to the oi-userland tree.
$E "$HOST" "cd $DEST/tools && grep -q '^userland.manifest.allowed_pubs = .* oi-gnome' pkglintrc ||
	sed -i 's/^\(userland.manifest.allowed_pubs = .*\)\$/\1 oi-gnome/' pkglintrc"
# The same for the AMIX cross development packages (publisher amix):
# metapackages/amix-cross-dev and the toolchains depend on
# developer/amix/sysroot.
$E "$HOST" "cd $DEST/tools && grep -q '^userland.manifest.allowed_pubs = .* amix\\(\$\\| \\)' pkglintrc ||
	sed -i 's/^\(userland.manifest.allowed_pubs = .*\)\$/\1 amix/' pkglintrc"

for c in "${comps[@]}"; do
	$E "$HOST" "mkdir -p $DEST/components/$c"
	# No --delete at all unless asked for: a file that appeared there after
	# the check stays.
	sync_one "$c" ${del:+--delete}
	echo "oi-sync.sh: $c"
done
echo "oi-sync.sh: $(git -C "$TOP" rev-parse --short HEAD)$(git -C "$TOP" diff --quiet -- packages || echo +dirty) -> $HOST:$DEST"
