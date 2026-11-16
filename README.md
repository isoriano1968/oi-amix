# oi-amix: Amiga UNIX (AMIX) cross development on OpenIndiana

IPS packages that turn an OpenIndiana Hipster machine into a cross
development host for Amiga UNIX (AMIX 2.1c, Commodore's SVR4 for the
Amiga 3000/2500): both AMIX cross compilers, the AMIX sysroot, the X11,
Motif and CDE libraries for AMIX applications, and the AMIX Installer.
Every piece is built from an **oi-userland component** (pinned sources by
sha256 or a pinned commit of
amix-userland, `patches/`, `.p5m`
manifest, license file). The repository holds no binaries and no AMIX
files.

## What is here

| Package | What it is |
|---|---|
| `developer/amix/gcc-27` | gcc 2.7.2.3 + binutils 2.8.1 for m68k-cbm-sysv4: the AMIX kernel and drivers, in `/opt/amix-cross` |
| `developer/amix/gcc-14` | gcc 14.2.0 (C, C++) + binutils 2.43.1 for AMIX userland (68060), in `/opt/m68k-amix` |
| `developer/amix/sysroot` | the AMIX 2.1c p2a `usr/` tree from [amigaux/amix-system](https://github.com/amigaux/amix-system), in `/opt/m68k-amix-sysroot` |
| `developer/amix/amixc99` | libamixc99 and C99 headers for the sysroot |
| `developer/amix/x11r6.3`, `libxp`, `motif`, `cde` | X11R6.3 client libraries, libXp, Motif 2.3.8 and CDE 2.2.4 for AMIX applications |
| `developer/amix/rtgfb-kit` | the rtgfb (Picasso II) kernel driver kit used by the AMIX Installer |
| `desktop/amix-installer` | GTK 4 / libadwaita app that makes an AMIX disk for an Amiga 3000/2500 or FS-UAE from your own AMIX core system |
| `metapackages/amix-cross-dev` | sysroot and both compilers |
| `metapackages/amix-cross-dev-desktop` | the above plus X11, Motif and CDE |

`toolchains/` has the older sync script, `tools/amix-smoke-test.sh`
checks an installed toolchain (hello builds, ELF interpreter, NEEDED,
sysroot), and `notes/` documents the toolchain ports and the plan.

## Build

On an OpenIndiana Hipster 2026.10 (or later) build machine:

```bash
pfexec pkg install build-essential
git clone https://github.com/OpenIndiana/oi-userland.git ~/src/oi-userland
pkgrepo create ~/amix-repo && pkgrepo add-publisher -s ~/amix-repo amix
tools/oi-sync.sh            # with OI_HOST=user@buildhost, from another machine
cd ~/src/oi-userland/components/developer/amix-sysroot
gmake WS_REPO=$HOME/amix-repo PUBLISHER=amix publish
```

Build in this order: `amix-sysroot`, `amix-gcc-27`, `amix-gcc-14`,
`amix-amixc99`, `amix-x11r6.3`, `amix-libxp`, `amix-motif`, `amix-cde`,
`amix-rtgfb-kit`, `amix-installer`, then the two metapackages.
`tools/oi-sync.sh` also lets pkglint accept dependencies on the `amix`
publisher in the checkout.

## Install, and how to go back

```bash
pfexec pkg set-publisher -g file://$HOME/amix-repo amix
pfexec pkg install metapackages/amix-cross-dev-desktop
```

Everything goes under `/opt` (plus the installer under `/usr`) and
nothing replaces an OpenIndiana package. **To go back:**
`pfexec pkg uninstall metapackages/amix-cross-dev-desktop` and the
packages it pulled in, or install into a new boot environment first
(`pfexec beadm create amix`, `pkg -R`) and activate the previous one.

## Security

- No setuid files, no services, no new users. The compilers and the
  installer run as an ordinary user.
- Sources are pinned by sha256 or by commit; every change is a patch with
  a header.

## AMIX files

The sysroot package installs Commodore's AMIX 2.1c `usr/` tree, unchanged,
from amigaux/amix-system, which publishes it under Amiga Corporation's
approval of 2026-09-23 (see `packages/developer/amix-sysroot/amix-sysroot.license`).
This repository itself contains no AMIX files, only the recipe. It is not
affiliated with, endorsed by or sponsored by Amiga Corporation; Amiga is a
registered trademark of Amiga Corporation, UNIX of The Open Group.

## Private files

Files whose name contains `.local` are private and never published;
`.gitignore` excludes them.

## License

Each component is under its upstream license (see its `.license` file);
the build recipes follow oi-userland (CDDL).

Iggi
