#!/bin/bash
# sync-to-oi.sh -- copy what the OpenIndiana toolchain builds need from the
# Linux workstation to the OpenIndiana VM.  Runs on the Linux workstation.
#
#   - amix-userland's gcc-27 and gcc-14 components (scripts and patches only;
#     their build trees and downloads are left behind)
#   - this directory (toolchains/), to ~/src/oi-toolchains
#   - the AMIX sysroot (~/opt/m68k-amix-sysroot).  It comes from a licensed
#     AMIX installation: it goes to the private VM, never into git.
#
# What exists only on the VM in the synced directories, and what would be
# replaced by another type there (a link by a directory), is listed, and the
# run stops before it has copied anything (exit 3); --delete allows it.
# (The check itself only creates the two ~/src directories if they are missing.)
#
# Usage:  toolchains/sync-to-oi.sh [--delete] user@host
set -e -o pipefail
del=
if [ "$1" = --delete ]; then del=1; shift; fi
HOST="${1:?usage: $0 [--delete] user@host}"
HERE="$(cd "$(dirname "$0")" && pwd)"
AU="${AMIX_USERLAND:-$HOME/Sources/usr-amix/amix-userland}"
E="ssh ${OI_SSH_OPTS:--o BatchMode=yes}"

$E "$HOST" 'mkdir -p ~/src/amix-userland/components/developer ~/src/oi-toolchains'
sync_gcc() {
	# Excluded paths are also kept safe from --delete on the VM side.
	rsync -a "$@" --exclude '/gcc-*/src' --exclude '/gcc-*/build' \
		--exclude '/gcc-*/distfiles' --exclude '/gcc-*/config.sh' \
		--exclude '/gcc-*/*.log' -e "$E" \
		"$AU/components/developer/gcc-27" "$AU/components/developer/gcc-14" \
		"$HOST:src/amix-userland/components/developer/"
}
sync_sysroot() {
	# never --delete: what only the VM has there stays
	rsync -a "$@" -e "$E" "$HOME/opt/m68k-amix-sysroot/" "$HOST:opt/m68k-amix-sysroot/"
}
sync_here() {
	rsync -a "$@" -e "$E" "$HERE/" "$HOST:src/oi-toolchains/"
}
check() {	# directory on the VM, the dry run's lines for it
	sed -n "s|^\*deleting  *|would delete: $1/|p" <<<"$2"
	# rsync calls an entry of another type "new" and replaces it, --delete or not
	sed -n 's/^..+++++++++ //p' <<<"$2" | sed 's|/$||' |
		$E "$HOST" "cd $1 && while IFS= read -r p; do if [ -h \"\$p\" ] || [ -e \"\$p\" ]; then echo \"would replace: $1/\$p (another type there; a directory goes with its contents)\"; fi; done"
}
plan_gcc=$(sync_gcc --delete -n -8 --out-format='%i %n')
plan_here=$(sync_here --delete -n -8 --out-format='%i %n')
# set -e does not reach inside $( ): one assignment for each check
doomed_gcc=$(check src/amix-userland/components/developer "$plan_gcc")
doomed_here=$(check src/oi-toolchains "$plan_here")
doomed_sysroot=
state=$($E "$HOST" 'if [ -d opt/m68k-amix-sysroot ]; then echo present; else echo new; fi')
case $state in
present)
	# --force: the dry run also shows a directory that a file would replace
	plan_sysroot=$(sync_sysroot --force -n -8 --out-format='%i %n')
	doomed_sysroot=$(check opt/m68k-amix-sysroot "$plan_sysroot") ;;
new) ;;
*)	echo "sync-to-oi.sh: cannot check the sysroot on $HOST" >&2; exit 1 ;;
esac
doomed=
for found in "$doomed_gcc" "$doomed_here" "$doomed_sysroot"; do
	[ -z "$found" ] || doomed+=$found$'\n'
done
if [ -n "$doomed" ]; then
	printf %s "$doomed" >&2
	if [ -z "$del" ]; then
		echo "sync-to-oi.sh: stopped, nothing copied; rerun with --delete if all of it can go." >&2
		exit 3
	fi
fi
$E "$HOST" 'mkdir -p ~/opt'
sync_sysroot ${del:+--force}
sync_gcc ${del:+--delete}
sync_here ${del:+--delete}
echo "sync-to-oi.sh: amix-userland $(git -C "$AU" rev-parse --short HEAD) -> $HOST"
