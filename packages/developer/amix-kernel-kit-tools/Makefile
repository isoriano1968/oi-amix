#
# This file and its contents are supplied under the terms of the
# Common Development and Distribution License ("CDDL"), version 1.0.
# You may only use this file in accordance with the terms of version
# 1.0 of the CDDL.
#
# A full copy of the text of the CDDL should have accompanied this
# source.  A copy of the CDDL is also available via the Internet at
# http://www.illumos.org/license/CDDL.
#

#
# developer/amix/kernel-kit-tools -- what the AMIX Installer needs around the
# driver kits, all MIT, from amix-gate (no AMIX, Commodore or NetBSD file):
#  - kit-tools/: the shared pieces every kit relink uses (make-kit-tools.sh:
#    patch_io_init.py, patch_int2.py, check_relink_relocs.py, the
#    amixdrv_init/amixdrv_int2 stub templates, KIT.sha256), plus
#    stamp-rootcard.py (root and swap on another SCSI card/unit) and
#    kernel-nswap.py (a kernel's swapfile.nswap; the 2.1c code check), which
#    KIT.sha256 does not list (it stays make-kit-tools.sh's own);
#  - kernel-040/: the kernel-040 kit (make-kernel-040-kit.sh): amix-kernel-040,
#    which makes our 68040/68060 kernel (generic or z3660) from the user's own
#    stock AMIX 2.1c kernel, with the port's relink chain and the z3660
#    variant's MIT driver sources under io/.  The FPSP/060SP code is extracted
#    at build time from the pinned NetBSD 10.1 syssrc.tgz, never shipped.
# Nothing is compiled here: no AMIX kernel is included.
#
# amix-gate fb9b140: kit-relink.sh links a single copy of a byte-identical
# provides= object; amix-kernel-040 --root-card/--root-unit/--root-stock, and
# the same kernel with m68k-elf or m68k-linux-gnu binutils (port/tools/
# m68k-gas.sh, elf-global.py); NetBSD syssrc from archive.netbsd.org.
#
# amix-gate 82bd7df (revision 2): amix-kernel-040 runs from this read-only
# installed kit (plain tar plus find for __pycache__, chmod -R u+w on the work
# copy, GNU tar for the NetBSD extraction); kit-relink.sh KIT.info conflicts=;
# the z3660 variant's zz9000 sources with per-board colour modes and
# RTGIOC_GETCAPS (io/rtgcaps.h).  kit-tools/ is unchanged.
#
# Run time (amix-kernel-040, kit-relink.sh): the m68k-elf gcc + binutils of
# developer/amix/gcc-14, gcc 2.7.2.3 of developer/amix/gcc-27, python3, GNU m4,
# GNU patch and GNU tar: declared as depend actions in the manifest.
#

BUILD_BITS =		NO_ARCH
BUILD_STYLE =		justmake

include ../../../make-rules/shared-macros.mk

COMPONENT_NAME =	amix-kernel-kit-tools
COMPONENT_VERSION =	0.3
# rev 3: amix-gate 23c72c9, no login in the kit script comments
COMPONENT_REVISION =	3
COMPONENT_SUMMARY =	kernel kit tools and the 68040/68060 kernel kit for the AMIX Installer
COMPONENT_PROJECT_URL =	https://github.com/isoriano1968/amix-gate
COMPONENT_FMRI =	developer/amix/kernel-kit-tools
COMPONENT_CLASSIFICATION = Development/System
COMPONENT_LICENSE =	MIT
COMPONENT_LICENSE_FILE = amix-kernel-kit-tools.license

AMIX_GATE_COMMIT =	23c72c98a8ab8502d785eeec02904ac5cd6a31ca
COMPONENT_SRC =		amix-gate-$(AMIX_GATE_COMMIT)
COMPONENT_ARCHIVE =	$(COMPONENT_SRC).tar.gz
COMPONENT_ARCHIVE_HASH = sha256:405466b18c705326de4d7100dbd59e5882485e711932409454ac3f23c1ce003a
COMPONENT_ARCHIVE_URL =	https://github.com/isoriano1968/amix-gate/archive/$(AMIX_GATE_COMMIT).tar.gz

include $(WS_MAKE_RULES)/common.mk

PATH =			/opt/amix-cross/bin:/opt/m68k-amix/bin:$(PATH.gnu)

AMIX_SYSROOT =		/opt/m68k-amix-sysroot
KIT_PORT =		$(SOURCE_DIR)/usr/src/uts/amiga/port
KIT_DIR =		/usr/share/amix-installer/kit-tools

COMPONENT_COPY_ACTION =
COMPONENT_CONFIGURE_ACTION = true
COMPONENT_BUILD_ACTION = true

K040_DIR =		/usr/share/amix-installer/kernel-040

define COMPONENT_INSTALL_ACTION
$(RM) -r $(PROTO_DIR)$(KIT_DIR) $(PROTO_DIR)$(K040_DIR)
AMIX_ROOT=$(AMIX_SYSROOT) $(SHELL) $(KIT_PORT)/make-kit-tools.sh $(PROTO_DIR)$(KIT_DIR)
cd $(PROTO_DIR)$(KIT_DIR) && /usr/bin/sha256sum -c KIT.sha256
$(CP) $(KIT_PORT)/tools/stamp-rootcard.py $(KIT_PORT)/tools/kernel-nswap.py $(PROTO_DIR)$(KIT_DIR)/
$(SHELL) $(KIT_PORT)/make-kernel-040-kit.sh $(PROTO_DIR)$(K040_DIR)
cd $(PROTO_DIR)$(K040_DIR) && /usr/bin/sha256sum -c KIT.sha256
$(RM) -r $(KIT_PORT)/build
endef

COMPONENT_TEST_ACTION = true
COMPONENT_TEST_TARGETS =

REQUIRED_PACKAGES += developer/amix/gcc-14
REQUIRED_PACKAGES += developer/amix/gcc-27
REQUIRED_PACKAGES += developer/amix/sysroot
REQUIRED_PACKAGES += archiver/gnu-tar
REQUIRED_PACKAGES += developer/macro/gnu-m4
REQUIRED_PACKAGES += runtime/python-313
REQUIRED_PACKAGES += text/gnu-patch
