# oi-amix: Amiga UNIX (AMIX) on OpenIndiana

**AMIX** is Commodore's UNIX for the Amiga 3000 and 2500 (UNIX System V
Release 4, 1990–1992). This repository turns a computer running **OpenIndiana** into the place
where you set AMIX up and develop for it (for **Linux**, the same
installer and compilers come as Debian packages from
[linux-amix](https://github.com/isoriano1968/linux-amix)):

- the **AMIX Installer**, a desktop app that makes ready-to-boot AMIX
  disks for FS-UAE (the Amiga emulator) or for a real Amiga, and installs
  current software into a running AMIX over the network;
- the **cross compilers** and the AMIX **sysroot**, so you build AMIX
  programs on OpenIndiana;
- the X11, Motif and CDE libraries for AMIX programs with windows.

Everything comes as ordinary OpenIndiana (IPS) packages that you install
and remove with `pkg`.

## What you need

- A computer (x86-64) with **OpenIndiana Hipster 2026.10** or later and
  its desktop. On Linux, use linux-amix instead.
- **Your own AMIX 2.1 system**: the core disk image (`.hdf`) you made from
  your AMIX 2.1 install media, with Patch Disk 1-2a applied. This project
  ships no Commodore files.
- To run AMIX: **FS-UAE** (an A3000 configuration with an A2065 network
  card), or a real Amiga 3000/2500 with an A2065 Ethernet card on your
  network.

## Quick start

1. **Download** `oi-amix-packages-*.p5p` from the newest release on the
   [Releases page](https://github.com/isoriano1968/oi-amix/releases), and
   its `SHA256SUMS`. Check it:

   ```bash
   sha256sum -c --ignore-missing SHA256SUMS
   ```

   The release's other `.p5p`, `oi-amix-<version>.p5p`, holds only the
   installer: the installer's own update uses it.

2. **Install** the AMIX Installer (it brings the package repository AMIX
   is installed from, the boot loader and the kernel tools):

   ```bash
   pfexec pkg install -g oi-amix-packages-*.p5p desktop/amix-installer
   ```

3. **Start** *AMIX Installer* from the Applications menu (or run
   `amix-installer`).
4. **Choose** your AMIX core disk on the first page, then your machine
   (FS-UAE or a real Amiga), the disks and what to install. The summary
   shows every file it will write before anything happens.
5. **Create** the disks, start AMIX (the installer adds an FS-UAE
   configuration for you), log in as root and type the five short lines
   the installer shows (`tftp …`, `binary`, `get go`, `quit`, `sh go`).
   AMIX then fetches everything from your OpenIndiana computer by itself;
   the installer shows each step until **Done**.

Already have AMIX running? Choose *a running system* on the first page:
the installer then only installs into it over the network.

## Serving and building AMIX packages

- **Serve Packages** serves the AMIX package repository to your Amigas over
  the network, so `pkg refresh` and `pkg update` on AMIX get the newest
  packages. The tab shows the `pkg set-publisher` line to type on AMIX.
- **Build Packages** (new in 0.8) builds AMIX packages on your OpenIndiana
  computer from [amix-userland](https://github.com/isoriano1968/amix-userland),
  the master repository: it updates its checkout (`git pull`) when the
  installer starts, on Refresh and when an Amiga runs `pkg refresh`, lists
  the components that are new or newer than your repository, and builds them
  with `developer/amix/gcc-14` (and `gcc-27` where a component needs it)
  through the same checks as every published package. Serve Packages then
  serves them. Host programs (the installer itself, the compilers, pvmk)
  are never built there: they are OpenIndiana packages, updated with `pkg`.

## Developing for AMIX from VS Code

With the **vscode-amix** extension (VSCodium or VS Code) you write and
build AMIX programs on OpenIndiana and run them on AMIX with one key (F5):

1. In the AMIX Installer, on the *Development* page:
   - for new disks, switch on **VS Code agent** (with the CDE desktop
     chosen, the Motif libraries come along);
   - for an AMIX that is already running, its VS Code card has two quick
     buttons: **Just the Agent** sets AMIX's clock and installs the small
     VS Code agent, enough for console programs; **Agent and Motif** also
     installs the Motif and X11 libraries that Motif and CDE programs
     (such as the extension's CDE sample) need.
2. The installer shows the agent's key file at the end. In VS Code run
   **AMIX: Set Agent Key** and pick that file.
3. Open a sample, press **F5**: the program is built on OpenIndiana, sent to
   AMIX and runs there; its output is in VS Code's terminal.

## The packages

| Package | What it is |
|---|---|
| `desktop/amix-installer` | the AMIX Installer (GTK 4 / libadwaita) |
| `desktop/amix-installer/repository` | the AMIX packages the installer's network install serves to AMIX (an IPS repository, publisher `amix`, under `/usr/share/amix-installer/repo`); for AMIX, not for OpenIndiana itself |
| `developer/amix/pvmk` | pvmk, the Amiga 3000 boot loader the installer puts on every disk |
| `developer/amix/kernel-kit-tools` | the tools that link drivers into your own AMIX kernel, and make the 68040/060 kernel from it |
| `developer/amix/*-kit` | one driver kit per board: Picasso II (`rtgfb`), ZZ9000, VA2000, Z3660 RTG, SCSI and Ethernet, HydraNet, X-Surf 100, Buddha, A4091 |
| `developer/amix/gcc-27` | gcc 2.7.2.3 + binutils 2.8.1 for the AMIX kernel and drivers, in `/opt/amix-cross` |
| `developer/amix/gcc-14` | gcc 14.2.0 (C, C++) + binutils 2.43.1 for AMIX programs (68020 to 68060), in `/opt/m68k-amix` |
| `developer/amix/sysroot` | the AMIX 2.1c p2a `usr/` tree from [amigaux/amix-system](https://github.com/amigaux/amix-system), in `/opt/m68k-amix-sysroot` |
| `developer/amix/amixc99` | libamixc99 and C99 headers for the sysroot |
| `developer/amix/x11r6.3`, `libxp`, `motif`, `cde` | X11R6.3, libXp, Motif 2.3.8 and CDE 2.2.4 libraries for AMIX programs |
| `metapackages/amix-cross-dev` | the sysroot and both compilers |
| `metapackages/amix-cross-dev-desktop` | the above plus X11, Motif and CDE |

For cross development without the installer:

```bash
pfexec pkg install -g oi-amix-packages-*.p5p metapackages/amix-cross-dev-desktop
```

## How to go back

Nothing here replaces an OpenIndiana package: everything goes under
`/opt`, plus the installer under `/usr`.

```bash
pfexec pkg uninstall desktop/amix-installer desktop/amix-installer/repository
pfexec pkg uninstall metapackages/amix-cross-dev-desktop   # if you installed it
```

To try it without touching your system at all, install into a new boot
environment first (`pfexec beadm create amix`, `pfexec beadm activate
amix`, reboot) and activate the previous one to go back.

## Build from source

Every package is an **oi-userland component** in `packages/`: pinned
sources (by sha256, or a pinned commit of
[amix-userland](https://github.com/isoriano1968/amix-userland)),
`patches/`, a `.p5m` manifest and a license file. On an OpenIndiana
build machine:

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
`amix-pvmk`, `amix-kernel-kit-tools`, the `amix-*-kit` packages,
`amix-installer-repository`, `amix-installer`, then the two metapackages.

`amix-installer-repository` packs an archive of AMIX (m68k) packages that
amix-userland builds with the AMIX cross compilers. The archive of each
release is one of its assets on the
[Releases page](https://github.com/isoriano1968/oi-amix/releases), and the
recipe downloads it from there, checked by its sha256. The release's
`.p5p` already holds the built package.

`tools/oi-sync.sh` also lets pkglint accept dependencies on the `amix`
publisher in the checkout; `tools/amix-smoke-test.sh` checks an installed
toolchain, and `notes/` documents the toolchain ports.

## Security

- No setuid files, no services and no new users on OpenIndiana. The compilers
  and the installer run as an ordinary user.
- The network install runs only while its page is open: TFTP (UDP 1069)
  and HTTP (TCP 8069), plain and unencrypted, as AMIX 2.1 has no TLS. Use
  it on your own network or with FS-UAE.
- The VS Code agent on AMIX dials your OpenIndiana computer (TCP 7777) and signs in with a
  key only that install knows; it runs programs as an ordinary AMIX user.
- Sources are pinned by sha256 or by commit; every change is a patch with
  a header.

## AMIX files

The sysroot package installs Commodore's AMIX 2.1c `usr/` tree, unchanged,
from amigaux/amix-system, which publishes it under Amiga Corporation's
approval of 2026-09-23 (see `packages/developer/amix-sysroot/amix-sysroot.license`).
This repository itself contains no AMIX files, only the recipes. It is not
affiliated with, endorsed by or sponsored by Amiga Corporation; Amiga is a
registered trademark of Amiga Corporation, UNIX of The Open Group.

## Private files

Files whose name contains `.local` are private and never published;
`.gitignore` excludes them.

## License

Each component is under its upstream license (see its `.license` file);
the build recipes follow oi-userland (CDDL).

Iggi
