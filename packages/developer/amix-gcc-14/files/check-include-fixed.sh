#!/bin/bash
#
# check-include-fixed.sh DIR -- refuse an include-fixed directory that holds
# anything of the build host.
#
# fixincludes follows symbolic links in the sysroot.  With a hand-copied
# sysroot whose links were absolute (usr/include/X11 -> /usr/X/include) it
# walked into the build machine's own /usr and copied the host's Xorg headers
# into include-fixed/root, with include-fixed/X11 pointing at them
# (OpenIndiana, 2026-11-09).  developer/amix/sysroot has only relative links,
# so this must never happen again; if it does, the build stops here instead
# of packaging host headers as AMIX ones.
#
# With the packaged sysroot, fixincludes still writes fixed copies of headers
# it reached through a directory link (usr/include/X11 -> ../X/include) under
# root/<sysroot>/..., and include-fixed/X11 points there.  Those are the
# sysroot's own headers and allowed; anything else under root/ is the host's.
#
# Also requires the headers the package depends on: stdint.h (ours, from
# amix-userland's compat/include) and fixincludes' own stdio.h.
#
set -e
d=${1:?usage: check-include-fixed.sh DIR [SYSROOT]}
sysroot=${2:-/opt/m68k-amix-sysroot}
[ -d "$d" ] || { echo "check-include-fixed.sh: no $d" >&2; exit 1; }
bad=0
if [ -e "$d/root" ]; then
	while read -r f; do
		case $f in
		"$d/root$sysroot"/*)
			[ -e "$sysroot${f#$d/root$sysroot}" ] || {
				echo "check-include-fixed.sh: $f has no original in $sysroot" >&2; bad=1; } ;;
		*) echo "check-include-fixed.sh: $f: fixincludes reached the host" >&2; bad=1 ;;
		esac
	done < <(/usr/gnu/bin/find "$d/root" ! -type d)
fi
while read -r l; do
	t=$(readlink "$l")
	case $t in
	/*) echo "check-include-fixed.sh: $l -> $t is absolute" >&2; bad=1 ;;
	esac
	case $(cd "$(dirname "$l")" && /usr/bin/realpath -m "$t") in
	"$(cd "$d" && pwd -P)"/*) ;;
	*) echo "check-include-fixed.sh: $l -> $t leaves include-fixed" >&2; bad=1 ;;
	esac
done < <(/usr/gnu/bin/find "$d" -type l)
for h in stdint.h stdio.h; do
	[ -f "$d/$h" ] || { echo "check-include-fixed.sh: no $h in $d" >&2; bad=1; }
done
[ $bad = 0 ] || exit 1
echo "check-include-fixed.sh: $d holds no host files"
