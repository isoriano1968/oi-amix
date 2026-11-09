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
# Usage:  toolchains/sync-to-oi.sh user@host
set -e
HOST="${1:?usage: $0 user@host}"
HERE="$(cd "$(dirname "$0")" && pwd)"
AU="${AMIX_USERLAND:-$HOME/Sources/usr-amix/amix-userland}"
E="ssh ${OI_SSH_OPTS:--o BatchMode=yes}"

$E "$HOST" 'mkdir -p ~/opt ~/src/amix-userland/components/developer ~/src/oi-toolchains'
rsync -a -e "$E" "$HOME/opt/m68k-amix-sysroot/" "$HOST:opt/m68k-amix-sysroot/"
# Excluded paths are also kept safe from --delete on the VM side.
rsync -a --delete --exclude '/gcc-*/src' --exclude '/gcc-*/build' \
	--exclude '/gcc-*/distfiles' --exclude '/gcc-*/config.sh' \
	--exclude '/gcc-*/*.log' -e "$E" \
	"$AU/components/developer/gcc-27" "$AU/components/developer/gcc-14" \
	"$HOST:src/amix-userland/components/developer/"
rsync -a --delete -e "$E" "$HERE/" "$HOST:src/oi-toolchains/"
echo "sync-to-oi.sh: amix-userland $(git -C "$AU" rev-parse --short HEAD) -> $HOST"
