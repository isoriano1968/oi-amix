#!/bin/bash
# amix-smoke-test.sh -- smoke-test the installed AMIX cross toolchains.
# Runs on the OpenIndiana VM.
#
#   amix-smoke-test.sh ROOT
#
# ROOT is the image the packages are installed in: / for a system install,
# or a user image made with `pkg image-create` (the toolchains are
# relocatable; the sysroot is always the system's /opt/m68k-amix-sysroot).
#
# For each compiler: build hello.c, check the ELF (32-bit MSB m68k
# executable), that it is dynamically linked with the AMIX interpreter
# (/usr/lib/libc.so.1), that DT_NEEDED names libc.so.1 the way the guest
# resolves it, and that the link really used the sysroot (ld's trace shows
# the sysroot's crt1.o and libc).
set -e
ROOT="${1:?usage: $0 ROOT}"
ROOT="${ROOT%/}"
SYSROOT="${SYSROOT:-/opt/m68k-amix-sysroot}"
GCC27="$ROOT/opt/amix-cross/bin/m68k-cbm-sysv4-gcc"
GCC14="$ROOT/opt/m68k-amix/bin/m68k-elf-gcc"
GXX14="$ROOT/opt/m68k-amix/bin/m68k-elf-g++"
OBJDUMP="$ROOT/opt/m68k-amix/bin/m68k-elf-objdump"
READELF="$ROOT/opt/m68k-amix/bin/m68k-elf-readelf"
export PATH="/usr/gnu/bin:/usr/bin:/usr/sbin"
# cd / first: illumos rm will not remove the current working directory.
T=$(mktemp -d); trap 'cd /; rm -rf "$T"' EXIT
cd "$T"
printf '#include <stdio.h>\nint main(void) { puts("hello from AMIX"); return 0; }\n' > hello.c
printf '#include <iostream>\nint main() { std::cout << "hello from AMIX C++" << std::endl; return 0; }\n' > hello.cpp
fail=0

check() {  # $1 = label, $2 = binary
	local f="$2" t
	t=$(file "$f")
	case "$t" in
	*"ELF 32-bit MSB executable"*68*"dynamically linked"*) echo "  ok   ELF: ${t#*: }" ;;
	*) echo "  FAIL ELF: $t"; fail=1 ;;
	esac
	local interp needed
	interp=$("$READELF" -l "$f" | sed -n 's/.*Requesting program interpreter: \(.*\)]/\1/p')
	needed=$("$READELF" -d "$f" | sed -n 's/.*Shared library: \[\([^]]*\)\].*/\1/p' | tr '\n' ' ')
	[ "$interp" = /usr/lib/libc.so.1 ] && echo "  ok   interpreter $interp" ||
		{ echo "  FAIL interpreter '$interp'"; fail=1; }
	case "$needed" in
	*libc.so.1*) echo "  ok   NEEDED: $needed" ;;
	*) echo "  FAIL NEEDED: '$needed'"; fail=1 ;;
	esac
	# (ROOT is empty for a system install: "*$ROOT*" would match anything.)
	case "$needed" in
	*/export/*|*/home/*) echo "  FAIL NEEDED names a build-host path"; fail=1 ;;
	esac
	if [ -n "$ROOT" ]; then
		case "$needed" in
		*"$ROOT"*) echo "  FAIL NEEDED names the image path $ROOT"; fail=1 ;;
		esac
	fi
}

sysroot_used() {  # $1 = label, $2 = ld trace file
	if grep -q "$SYSROOT/usr/ccs/lib/crt1.o" "$2" && grep -q "$SYSROOT/usr/lib/libc.so.1\|$SYSROOT/usr/ccs/lib/libc.so" "$2"; then
		echo "  ok   linked from $SYSROOT (crt1.o, libc)"
	else
		echo "  FAIL ld trace does not show $SYSROOT's crt1.o and libc:"; sed 's/^/       /' "$2" | head -8; fail=1
	fi
}

echo "== gcc 2.7.2.3 ($GCC27)"
# gcc 2.7.2.3 is not relocatable: it finds cc1 and cpp under the prefix it
# was configured with (/opt/amix-cross).  In a test image elsewhere, point it
# there, as the package build does.
# (Only for gcc 2.7's own commands: gcc 14 reads GCC_EXEC_PREFIX as well.)
X27=
case "$ROOT" in
"") ;;
*) X27="GCC_EXEC_PREFIX=$ROOT/opt/amix-cross/lib/gcc-lib/" ;;
esac
env $X27 "$GCC27.real" -v 2>&1 | tail -1 | sed "s/^/  /"
env $X27 AMIX_SYSROOT=$SYSROOT "$GCC27" -O -m68040 -Wl,-t -o hello27 hello.c > ld27.trace 2>&1 || { cat ld27.trace; fail=1; }
check gcc27 hello27
sysroot_used gcc27 ld27.trace

echo "== gcc 14.2.0 ($GCC14)"
"$GCC14" --version | head -1 | sed 's/^/  /'
"$GCC14" -print-sysroot | sed 's/^/  sysroot: /'
"$GCC14" -mcpu=68060 -O2 -Wl,-t -o hello14 hello.c > ld14.trace 2>&1 || { cat ld14.trace; fail=1; }
check gcc14 hello14
sysroot_used gcc14 ld14.trace

echo "== g++ 14.2.0 ($GXX14)"
"$GXX14" -mcpu=68060 -O2 -Wl,-t -o hello14xx hello.cpp > ld14xx.trace 2>&1 || { cat ld14xx.trace; fail=1; }
check gxx14 hello14xx
sysroot_used gxx14 ld14xx.trace
grep -q "libstdc++.a" ld14xx.trace && echo "  ok   libstdc++.a linked" || { echo "  FAIL no libstdc++.a in the link"; fail=1; }

[ $fail = 0 ] && echo "SMOKE TEST PASS" || echo "SMOKE TEST FAIL"
exit $fail
