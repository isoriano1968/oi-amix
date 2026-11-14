# AMIX cross development on OpenIndiana: sysroot + toolchains as packages

Plan of 2026-11-14. Nothing built yet.

## Goal

`pkg install developer/amix/gcc-14` (or gcc-27, or both) on an OI machine
gives a working AMIX development system: the compiler pulls in the
Amiga-Corporation-approved AMIX sysroot as a required package. Nothing is
copied by hand, nothing lands in host directories, and every package and
dependency carries a version, so it is always clear what is installed.

## Inputs, all pinned

| Input | Pin (2026-11-14) | Licence |
|---|---|---|
| amigaux/amix-system (AMIX 2.1c p2a `usr/`) | debb2e14bce281995d22bd5607a8db1afd4db677, from amigaux/amix `system/amix-system.pin` | published under Amiga Corporation's approval of 2026-09-23; AT&T/USL portions |
| amigaux/amix `system/MANIFEST.sha256`, `SYMLINKS` | the amix commit the pin is read from | MIT |
| gcc 2.7.2.3 (kernel space) | jusii/gcc-cross-amix 33ebadcf6976ee65dbd1e25a586f59da55e5942d (amigaux pin) | GPL |
| gcc 14.2.0 (userland) | amigaux/gcc14-cross-amix dcfd12d79fb970f607a69d72b79e9f7470d1043f (amigaux pin) | GPL / MIT |
| dlm ABI kit | amigaux/amix `kernel/dlm/abi`, `make kit` | MIT + stock kernel headers under the project's permission |

Our OI toolchain packages today build from amix-userland 7b5c96b. Step 0
compares them with the amigaux pins; if they differ, the OI packages build
from the pins, so what is built on OI matches the distribution.

## Step 0 result (2026-11-14): ours and the pins differ

**gcc 2.7.2.3.** Our OI package builds amix-userland `components/developer/gcc-27`
(from isoriano1968/gcc-cross-amix). The pin jusii/gcc-cross-amix 33ebadc and
our gcc-cross-amix 83765c5 share 206bc95 (PR #3); since then the pin has 48
commits, ours 17. The pin adds: an assembler wrapper running fix_asm on every
compile (rules 2-11 in one perl pass), an ar wrapper, `-m68060` (040 code
without 64-bit multiply), scan060 (bounds-checked), tests as scripts in
`tests/`, distfiles checked against pinned sha256, patches per GNU version,
config.guess/sub pinned, libgcc float->int conversions, every delete
`${var:?}`-guarded, `AMIX_ROOT` without default (points at amix-system).
Ours has its 17 wrapper/link commits (libc archive, /usr/ccs/lib, -Wl,) that
are not in the pin; several look like the same fixes done twice.

**gcc 14.2.0.** Ours = asokero's tree + our fixes; the pin = asokero 58130fe +
36 commits on amigaux's branch.

| Point | Ours (amix-userland) | Pin (amigaux dcfd12d) | Effect |
|---|---|---|---|
| Pointer return %a0+%d0 | `patch-gcc-svr4-return.py` (linux.h's m68k_function_value) | `amix-abi.h` (same function) | same ABI |
| Struct return | 4- and 8-byte structs in %d0/%d1; larger ones in memory, address in %a0 (checked in our gcc-14 output 2026-11-14; our TOOLCHAIN.md table saying %a1 is stale); div/ldiv worked around in compat | always in memory, address in %a0 (`DEFAULT_PCC_STRUCT_RETURN`), the SVR4 rule | differs only for 4/8-byte structs; see impact below |
| Default CPU | `--with-cpu=68060`: 68060 only | `m68020-60`: also a 68030 + 68881/2 | **decided 2026-11-14: take theirs**, `-m68060` (and our 060 tuning) as an option; A2500/030 gets 030 kernels |
| fold-mem-offsets | disabled in specs (miscompiles m68k) | not disabled | pin may miscompile; report to amigaux |
| FSIN/FCOS on 040/060 | not inlined (`patch-gcc-060-fpu.py`, 78 us trap) | not patched | pin slower with -ffast-math; report |
| Shared libraries | specs: crtbeginS/amix_initS, libc.so.1, amix-mkshlib, so-init for constructors | `gcc -shared`, libamixrt.so.1, binutils PIC-reloc patch, deferred constructors, solib probes | two designs; our 64+ box libs (X, Motif, CDE, NetSurf) are built with ours |

**Struct-return impact on our system (measured 2026-11-14).** Scan of all
1603 sysroot headers (stock AMIX + ours) with the cross gcc's `-aux-info`
and `__builtin_classify_type`: 42 functions return a struct/union by value.
Only 4/8-byte ones are affected: stock div/ldiv (8), dbm `datum` functions
(8), `dl_t` ladd/lsub/... (8), inet_makeaddr (4), and of ours
`SSL_as_poll_descriptor` (8). Symbol scan of 13092 m68k ELF files (all
component builds, stages, sysroot libs): no gcc-14 code calls any of them
across a library boundary (div/ldiv come from our compat; ladd etc. are
linked from libc.a and called by libc's own code). X11, Motif and CDE
headers have none. The larger ones (SDL GUIDs 16, OSSL_PARAM 20, expat
version 12, ZSTD bounds 12, mallinfo 40) return the same way in both.
C++ classes that are not trivially copyable go in memory in both;
libstdc++ is static. So: today's convention causes no known bug, and the
switch to the SVR4 rule changes no exported interface that is used; it
still means rebuilding every gcc-14 library and program in one go (static
archives such as libamixc99.a and libstdc++.a mix within a link). Not
covered by the scan: function pointers/callbacks returning small structs.

Consequence: switching the OI packages to the pins is not a drop-in. It
needs (a) the struct-return ABI decided (pin's SVR4 rule) and every gcc-14
library rebuilt, (b) one shared-library design, (c) our fold-mem-offsets and
FSIN fixes offered to amigaux, (d) our 17 gcc-27 commits compared with the
pin's 48 and the missing ones offered. Until then the OI packages stay on
amix-userland, and the sysroot package (step 1) does not depend on the
choice.

## Packages

| FMRI | Contents | Requires |
|---|---|---|
| `developer/amix/sysroot@2.1.2.<rev>` | amix-system `usr/` (+ `etc/` pieces the toolchains need) under `/opt/m68k-amix-sysroot`, all `facet.devel`; absolute links made relative; `usr/include/stdint.h` from gcc-14 compat; marker `/opt/m68k-amix-sysroot/etc/amix-sysroot.release` (version, amix-system commit, amix commit) | nothing |
| `developer/amix/gcc-27@2.7.2.3.<rev>` | `/opt/amix-cross`, wrapper, specs, libgcc built against the pinned sysroot | `developer/amix/sysroot@2.1.2` (explicit, versioned) |
| `developer/amix/gcc-14@14.2.0.<rev>` | `/opt/m68k-amix`, specs, fixed headers generated at build time against the pinned sysroot (no post-install `m68k-amix-fixheaders` step any more), `m68k-amix-pkg-config` | `developer/amix/sysroot@2.1.2` |
| `developer/amix/dlmkit@<kit version>` | ABI kit k30 + k46 under `/opt/amix-dlmkit` | gcc-27, sysroot |
| `developer/amix/<lib>` (x11r6, motif, cde, ...) | our shared libs for linking: headers, `.so`, `.pc` in the sysroot prefix, `facet.devel` | sysroot, the libs they link against, versioned |
| `developer/amix/cross-dev` (group) | both toolchains + sysroot (+ dlmkit) | the above, versioned |

Version scheme of the sysroot: 2.1.2 = AMIX 2.1c at patch level 2a; the
amix-system commit is recorded in the package (`info.source-url`, the
marker file) and in the Makefile. A new amix-system pin = new revision.

Box side (amix-userland `.manifest`): `require` lines get versions too
(`require x11/x11r6.3 >= 6.3-n`), and libraries split into runtime and
`-dev` packages (separate plan; naming to agree with the amigaux packages).

## pkg-config in the initial cross system

Part of the initial system, not an add-on:

- The host's pkg-config (OI `developer/pkg-config`, pkgconf) is a versioned
  dependency of the toolchain packages.
- The toolchains ship the wrapper under the names build systems look for on
  their own: `m68k-elf-pkg-config` (gcc-14) and `m68k-cbm-sysv4-pkg-config`
  (gcc-27), so `configure --host=...`'s `PKG_CHECK_MODULES` finds it with no
  extra settings. It is amix-userland's `tools/amix-pkg-config`: only the
  sysroot's `.pc` directories (`PKG_CONFIG_LIBDIR`), `PKG_CONFIG_SYSROOT_DIR`
  set, `PKG_CONFIG_PATH` cleared, so no host library is ever picked up; it
  applies the same sysroot guard as below.
- The sysroot package adds `.pc` files for the stock libraries that have none
  (AMIX X11 in `usr/X`, libsocket/libnsl, libscreen), written by us and
  marked as such; every library package brings its own `.pc`.
- gcc-14 also ships the cross files for the other build systems: a meson
  cross file and the CMake toolchain file (from amix-userland
  `make-rules/meson.mk` and `amix-toolchain.cmake`), pointing at the same
  wrapper and sysroot.
- Test in step 4: `m68k-elf-pkg-config --cflags --libs xm dt` and an
  autoconf `--host=m68k-elf` probe on the Mac.

## Cross host or real AMIX: never write into the host

One rule in amix-userland `make-rules/shared.mk` and in every tool that
installs or links against the sysroot:

- **On AMIX** (`uname` reports the Amiga UNIX system; exact values read from
  the box when it is free): native build, `AMIX_SYSROOT` must be empty or
  unset, installs go to the real prefixes.
- **On any other host** (cross): `AMIX_SYSROOT` defaults to
  `/opt/m68k-amix-sysroot` (packaged) or `$HOME/opt/m68k-amix-sysroot` (Linux workstation),
  and must point at a directory holding `etc/amix-sysroot.release`. Empty,
  `/`, or a directory without the marker: refuse with an error. This closes
  today's hole: `sysroot-install` runs `cp -R stage/. $(AMIX_SYSROOT)/`, and
  an exported empty `AMIX_SYSROOT` makes that `cp -R stage/. /`, over the
  host's `/usr/include`, `/usr/lib`.
- `sysroot-install` is replaced by the packages; until then it gets the
  guard.

## VS Code AMIX extension (0.3.1 -> 0.4.0)

- Defaults follow the packages: `/opt/amix-cross/bin`, `/opt/m68k-amix/bin`,
  `/opt/m68k-amix-sysroot`; the `$HOME/opt/...` paths stay as fallback.
- At start: detect which toolchains are installed and read the sysroot
  marker; status bar shows toolchain + sysroot version.
- Command "AMIX: Check development setup": lists toolchains, sysroot
  version, dlmkit, missing pieces, with the `pkg install` line to fix them.
- The `cde-hello` sample builds with `m68k-amix-pkg-config --cflags --libs xm dt`.

## Order

0. Compare our toolchain builds with the amigaux pins (Linux workstation, no system change).
1. `packages/developer/amix-sysroot`: Makefile + p5m, checksum check against
   MANIFEST.sha256, link fix-up, marker. Build on the VM, publish.
2. gcc-27 and gcc-14: require the sysroot, build against it, fixed headers at
   build time. Regression gates incl. `kernel-volatile` (now possible, usr/sys).
3. Guard in amix-userland `shared.mk` + tools.
4. Install on the Mac in a new BE from oi-local, smoke test, cde-hello.
5. Library packages (x11r6, motif, cde), dlmkit, cross-dev group.
6. Extension 0.4.0.

## Status 2026-11-14 evening

- Published to the VM's ~/amix-repo (publisher amix): developer/amix/sysroot
  2.1.2-2026.0.0.0 (3890 files, 66 links; six stripped AMIX X clients left
  out, pkg(5)'s ELF reader fails on them), metapackages/amix-cross-dev 1.0
  (sysroot@2.1.2, gcc-27@2.7.2.3, gcc-14@14.2.0), developer/amix/gcc-27
  2.7.2.3-2026.0.0.2 (metadata-only republish of the 11-08 build: requires
  the sysroot, description updated; sources changed to match, revision 2).
  tools/oi-sync.sh now allows publisher amix in pkglintrc.
- Mac Pro (con9, live, no new BE): oi-local has sysroot + gcc-27;
  `pkg install developer/amix/gcc-27` pulled the sysroot in. hello.c with
  <X11/Xlib.h> builds (m68k ELF, NEEDED /usr/lib/libc.so.1, sysroot crt1.o
  and libc), a -D_KERNEL compile against usr/sys headers works.
- Next: gcc-14 rebuild with include-fixed generated at build time against
  the packaged sysroot (no more root-run m68k-amix-fixheaders) and the
  sysroot dependency; needs the VM free (clang-23 build runs alone), and the
  VM's hand-copied /opt/m68k-amix-sysroot replaced by the package (ask).
  Then gcc-14 + amix-cross-dev on the Mac, smoke test complete.
