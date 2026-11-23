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
# developer/amix/z3660rtg-kit -- amix-gate's z3660rtg driver (/dev/z3660rtg,
# major 55: the Z3660 accelerator's RTG, its own driver beside the ZZ9000's)
# as the kit the AMIX Installer links into a generic 68040/68060 port kernel
# on the host: z3660rtg-040 (board above VSECT1 through dev_kvmap,
# devkvmap040.o with provides=dev_kvmap dev_kvunmap; conflicts=
# zz9k_regoff_z3660, so it is refused on the z3660 kernel variant, whose
# built-in driver has the Z3660 RTG).  There is no 68030 kit: the Z3660 is a
# 68060 card.
# The source is amix-z3660rtg 1.0 (MIT) pristine in io/z3660rtg/src, with
# io/z3660rtg/port/patches applied by make-kit-040.sh (which needs patch(1)).
# The user's kernel is never distributed; this package carries only our own
# objects and scripts: z3660rtg_040.o, z3660rtg_pad.o, devkvmap040.o,
# patch_z3660rtg_cdevsw.py, patch_io_init.py, check_relink_relocs.py,
# KIT.info and KIT.sha256.
#
# make-kit-040.sh compiles the kernel code with gcc 2.7.2.3 (developer/amix/
# gcc-27) against the AMIX 2.1c kernel headers of developer/amix/sysroot, and
# runs its checks with the m68k-elf binutils of developer/amix/gcc-14.
#
# amix-gate 82bd7df (io/z3660rtg came in 7a61a99).
#

BUILD_BITS =		NO_ARCH
BUILD_STYLE =		justmake

include ../../../make-rules/shared-macros.mk

COMPONENT_NAME =	amix-z3660rtg-kit
COMPONENT_VERSION =	0.1
COMPONENT_REVISION =	1
COMPONENT_SUMMARY =	z3660rtg kernel driver kit for the AMIX Installer (Z3660 RTG)
COMPONENT_PROJECT_URL =	https://github.com/isoriano1968/amix-gate
COMPONENT_FMRI =	developer/amix/z3660rtg-kit
COMPONENT_CLASSIFICATION = Development/System
COMPONENT_LICENSE =	MIT
COMPONENT_LICENSE_FILE = amix-z3660rtg-kit.license

AMIX_GATE_COMMIT =	82bd7df1f373f6fc4049b1f22fcdddfb0deb06c8
COMPONENT_SRC =		amix-gate-$(AMIX_GATE_COMMIT)
COMPONENT_ARCHIVE =	$(COMPONENT_SRC).tar.gz
COMPONENT_ARCHIVE_HASH = sha256:39c859fa8de4ff1a823dd84be33b92c62bb66a43d61a69aa12526a271ee16b4b
COMPONENT_ARCHIVE_URL =	https://github.com/isoriano1968/amix-gate/archive/$(AMIX_GATE_COMMIT).tar.gz

# no tests of its own: gmake test says so and succeeds
TEST_TARGET =		$(NO_TESTS)

include $(WS_MAKE_RULES)/common.mk

PATH =			/opt/amix-cross/bin:/opt/m68k-amix/bin:$(PATH.gnu)

AMIX_SYSROOT =		/opt/m68k-amix-sysroot
Z3660RTG_PORT =		$(SOURCE_DIR)/usr/src/uts/amiga/io/z3660rtg/port
KIT_DIR =		/usr/share/amix-installer/z3660rtg-040

COMPONENT_COPY_ACTION =
COMPONENT_CONFIGURE_ACTION = true
COMPONENT_BUILD_ACTION = true

define COMPONENT_INSTALL_ACTION
$(RM) -r $(PROTO_DIR)$(KIT_DIR)
AMIX_ROOT=$(AMIX_SYSROOT) $(SHELL) $(Z3660RTG_PORT)/make-kit-040.sh $(PROTO_DIR)$(KIT_DIR)
cd $(PROTO_DIR)$(KIT_DIR) && /usr/bin/sha256sum -c KIT.sha256
$(RM) -r $(Z3660RTG_PORT)/build
endef

REQUIRED_PACKAGES += developer/amix/gcc-14
REQUIRED_PACKAGES += developer/amix/gcc-27
REQUIRED_PACKAGES += developer/amix/sysroot
REQUIRED_PACKAGES += text/gnu-patch
