# AMIX cross toolchains on OpenIndiana

State 2026-11-09.

**Installed** on the OI VM from the packages in ~/amix-repo (publisher amix),
2026-11-09 06:58: developer/amix/gcc-27 2.7.2.3-2026.0.0.1 in /opt/amix-cross,
developer/amix/gcc-14 14.2.0-2026.0.0.1 in /opt/m68k-amix (include-fixed
made by m68k-amix-fixheaders: 500 headers), emulators/fs-uae-launcher
3.1.70-2026.0.0.1. tools/amix-smoke-test.sh / passes. The development
installs in ~/opt described below have been removed.

## Host

OpenIndiana Hipster 2026.10 (VM, DHCP). Host packages
installed for the builds, from pkg.openindiana.org:

    developer/gcc-14 (14.3.0) developer/build/gnu-make developer/parser/bison-38
    developer/lexer/flex developer/macro/gnu-m4 developer/gnu-binutils
    developer/build/autoconf developer/build/automake

gcc builds 64-bit by default; `-m32` works (illumos ships both). GNU tools
are in /usr/gnu/bin, which is *last* in the default PATH.
config.guess/config.sub: /usr/share/automake-1.16/.

## gcc 2.7.2.3 + binutils 2.8.1 (m68k-cbm-sysv4)

Built from amix-userland's gcc-27 Makefile (commit 7b5c96b) in under 2
minutes, into ~/opt/amix-cross. Settings that differ from the Linux build:

- 32-bit host: `--build=--host=i386-pc-solaris2.11`, `HOST_CC="gcc -m32"`.
  gcc 2.7's config/i386/xm-i386.h hard-codes `HOST_BITS_PER_LONG 32`, so a
  64-bit cc1 contradicts itself about long. (The Linux workstation's build is 64-bit with
  the same header; its output matches, but the inconsistency is latent.)
- binutils 2.8.1 needs `--build/--host` given (config.guess says x86_64).
- `-no-pie` dropped (a Linux default).
- /usr/gnu/bin first in PATH for the build.

Checks: all regression gates that the sysroot allows pass (divmod, float,
fcmp, bitfield, uint64, objdir, dtneeded, libc-archive incl. Xt,
user-volatile; kernel-volatile needs usr/sys, not in the sysroot). Output is
byte-identical to the Linux workstation's: .s and .o of 10 Quake files at -O2 -m68040.
The Solaris build also matches the Linux workstation (46 objects, libgcc.a).

### Wrapper bugs found here (patch for upstream)

`components/developer/amix/gcc-27/patches/0001-wrapper-portable-mktemp.patch`:

1. illumos mktemp returns a template with a suffix (`amix-gcc.XXXXXX.s`)
   unchanged (GNU and Solaris 11.4 fill it in). With the stock PATH every
   compile used one literal file name; under make -j one compile failed in
   mktemp and assembled into the other's file.
2. A compile-and-link ends in `exec ld`, which skips the EXIT trap: the
   temporaries stay in $TMPDIR (Linux, Solaris and illumos alike).

Tested with OI's stock PATH: parallel objects identical to the unpatched
wrapper's, failing link still exits 1, -E works, nothing left in TMPDIR.

## gcc 14.2.0 + binutils 2.43.1 (m68k-elf)

Built 2026-11-08 from amix-userland's toolchain/build-cross.sh (commit
7b5c96b) into ~/opt/m68k-amix, 17m41s at 24 jobs, with /usr/gnu/bin first in
PATH (install-fixed-headers.sh uses find -printf).

- download_prerequisites links gmp, mpfr, mpc and **gettext 0.22** into the
  gcc tree. That gettext does not compile on illumos: its localename.c
  declares getlocalename_l against <locale.h> ("conflicting types"), even
  with --disable-nls. Fix: remove the four links; gcc then uses
  OpenIndiana's library/gmp, mpfr, mpc (as the Solaris component does).
- Installed: g++ 14.2.0, libstdc++/libsupc++, libgcc, specs, include-fixed,
  amix_init.o, libamixc99.a; no C library function with C++ linkage in
  libstdc++.a.
- Checks: hello, div64, i64, vaarg, stdioprobe, stderrprobe, abiprobe,
  cxxprobe, stl, staticinit at -mcpu=68060 -O2 are identical to the Linux workstation's
  except .debug_line/.debug_str (libgcc's build directory path);
  `objcopy --strip-debug` copies are byte-identical. check-68060-safe.py: 318
  long multiply/divide instructions, none in a 64-bit form.

## Tests on the A3000

Rule (2026-11-08): every toolchain's test programs run on the A3000 too,
through ~/Sources/usr-amix/amix-userland/tools/amix-box.

- gcc 2.7.2.3 (OI-built, -O -m68040): hello, div64, i64, stdioprobe,
  stderrprobe, abiprobe -- all rc=0 with the expected output. (i64's
  "div64: 3197704724 (want 123456789012)" is the probe printing the quotient
  as a 32-bit unsigned long; the 64-bit lines are right.)
- gcc 14 (OI-built, -mcpu=68060 -O2): hello, div64, i64, vaarg,
  stdioprobe, stderrprobe, abiprobe, cxxprobe (templates, virtual, new/delete,
  throw/catch), stl (vector, list, map, set, string, dynamic_cast,
  std::out_of_range) and staticinit -- all rc=0 with the expected output.

## Packaging

oi-userland components, built inside an oi-userland workspace on the VM
(~/src/oi-userland, synced with tools/oi-sync.sh) with OpenIndiana's own
make-rules, published to ~/oi-repo, publisher amix:

- packages/developer/amix-gcc-27 -> developer/amix/gcc-27
- packages/developer/amix-gcc-14 -> developer/amix/gcc-14

The recipes follow the Solaris project's components step for step. Three
archives each: the GNU tarballs and amix-userland at the pinned commit.
amix-userland's own patches and fixup scripts run from that archive
(COMPONENT_PREP_ACTION); patches/ holds only our own, per oi-userland's
per-tree patch naming (*.patch_2 = the amix-userland tree). Prefixes
/opt/amix-cross and /opt/m68k-amix; the sysroot is expected in
/opt/m68k-amix-sysroot and is never packaged.

oi-userland's prep checks the workspace build set (metapackages/
build-essential, runtime/ruby, developer/java/openjdk8, compress/lzip) and
tries `pfexec pkg install` for what is missing; the build user has no admin
profile, so that set was installed with sudo first (221 packages, approved
2026-11-08).

## FS-UAE JIT on OpenIndiana (2026-11-08)

oi-userland's encumbered/fs-uae (3.1.66) builds with --disable-jit. Built in
a scratch tree with tools/fs-uae-jit-test.sh: the component's patches plus
tools/fs-uae-jit-illumos.patch, configured --enable-jit
--with-libmpeg2=builtin (library/video/libmpeg2 is only in the
hipster-encumbered publisher).

- One source change was needed: src/jit/exception_handler.cpp uses
  REG_RAX... from <sys/regset.h>, which illumos' <sys/ucontext.h> does not
  include (Solaris 11.4's does). The patch adds the include under __sun.
- Run (ssh -X from the Linux workstation; Mesa softpipe over the forwarded display),
  A1200, cpu = 68040, uae_cpu_24bit_addressing = false, jit_compiler = 1,
  AROS ROM, 40 s, clean shutdown. The log: "JIT: Enabling JIT compiler",
  "Installing segfault handler", "Supposedly 42327 compileable opcodes!",
  "Actual translation cache size : 8192 KB at 42000000-42800000",
  natmem "Reserved 80000000-100000000", "Z3 REAL mapping. JIT direct
  compatible.", and "CPU=68040, FPU=68040, MMU=0, JIT=CPU/FPU=8192".
  The MMU warning is fs-uae turning the 68040 MMU off in favour of the JIT.
- Same addresses as the Solaris session's run (cache at 0x42000000, natmem
  at 0x80000000).

## Packaging traps (oi-userland)

- `gmake publish` writes to $(WS_REPO); pass WS_REPO=... as well as PKG_REPO.
  The publisher is the repository's default (the FMRI has none), so the
  AMIX toolchain has its own repository, ~/amix-repo (publisher amix).
- transforms/symlinks adds a dependency on every link target. A link that
  dangles on purpose (the sysroot link) needs pkg.tmp.allow-dangling=true
  and pkg.linted.userland.action002.0=true.
- oi-userland sets variant.arch itself; a manifest must not.
- REQUIRED_PACKAGES must list the package of every resolved dependency
  (resolve only searches those): SUNWcs for #!/usr/bin/env.
- tools/oi-sync.sh used to delete the unpacked sources on the VM at every
  re-sync (rsync --delete); fixed with --filter 'P /*/'.
- illumos cp -R and chmod -R follow symlinks: on AMIX trees (absolute links
  such as usr/include/X11 -> /usr/X/include) they reach into the host. Use
  the GNU tools.
- Every goal that reaches `install` (install, sample-manifest, test) unpacks
  and rebuilds the whole component again: the unpack stamps depend on the
  `download` target, which has no file, so make always takes it as new.
  `gmake publish` does not go through install. So: one `gmake install`,
  then `pkgsend generate` on the proto area by hand instead of `gmake
  sample-manifest`, then `gmake publish` (check with `gmake -n` first).
  An unplanned gcc 14 rebuild this way, overlapping with GNOME's colord
  build, filled the OI VM's 32 GB and it had to be reset (2026-11-08 23:33).
- One heavy job at a time on the OI VM itself, not only across the two VMs.
