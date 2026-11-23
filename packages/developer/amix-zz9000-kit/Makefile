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
# developer/amix/zz9000-kit -- /dev/zz9000, major 49: the MNT ZZ9000 on Zorro II.
# Two kits from amix-gate 82bd7df:
#  - zz9000/ (make-kit-030.sh): the stock AMIX 2.1c/2.1p2a 68030 kernel;
#  - zz9000-040/ (make-kit-040.sh): a generic 68040/68060 port kernel
#    (tools/amix-kernel-040), framebuffer noncacheable-not-serialised; the
#    z3660 kernel variant has the driver built in and kit-relink.sh refuses
#    the kit there.  The Z3660's RTG is developer/amix/z3660rtg-kit.
# 0.2: colour modes per board row, RTGIOC_GETCAPS (io/rtgcaps.h).
# Built with gcc 2.7.2.3 against the AMIX headers of developer/amix/sysroot;
# no AMIX kernel is included.
#
# make-kit-030.sh and make-kit-040.sh compile the kernel code with gcc 2.7.2.3 (developer/amix/
# gcc-27) against the AMIX 2.1c kernel headers of developer/amix/sysroot, and
# runs its checks with the m68k-elf binutils of developer/amix/gcc-14.
#

BUILD_BITS =		NO_ARCH
BUILD_STYLE =		justmake

include ../../../make-rules/shared-macros.mk

COMPONENT_NAME =	amix-zz9000-kit
COMPONENT_VERSION =	0.2
COMPONENT_REVISION =	0
COMPONENT_SUMMARY =	zz9000 kernel driver kits for the AMIX Installer (MNT ZZ9000, stock 68030 and 68040/68060 port kernels)
COMPONENT_PROJECT_URL =	https://github.com/isoriano1968/amix-gate
COMPONENT_FMRI =	developer/amix/zz9000-kit
COMPONENT_CLASSIFICATION = Development/System
COMPONENT_LICENSE =	MIT
COMPONENT_LICENSE_FILE = amix-zz9000-kit.license

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
KIT_PORT =		$(SOURCE_DIR)/usr/src/uts/amiga/io/zz9000/port
KIT_DIR =		/usr/share/amix-installer/zz9000

COMPONENT_COPY_ACTION =
COMPONENT_CONFIGURE_ACTION = true
COMPONENT_BUILD_ACTION = true

define COMPONENT_INSTALL_ACTION
$(RM) -r $(PROTO_DIR)$(KIT_DIR) $(PROTO_DIR)$(KIT_DIR)-040
AMIX_ROOT=$(AMIX_SYSROOT) $(SHELL) $(KIT_PORT)/make-kit-030.sh $(PROTO_DIR)$(KIT_DIR)
AMIX_ROOT=$(AMIX_SYSROOT) $(SHELL) $(KIT_PORT)/make-kit-040.sh $(PROTO_DIR)$(KIT_DIR)-040
cd $(PROTO_DIR)$(KIT_DIR) && /usr/bin/sha256sum -c KIT.sha256
cd $(PROTO_DIR)$(KIT_DIR)-040 && /usr/bin/sha256sum -c KIT.sha256
$(RM) -r $(KIT_PORT)/build
endef

REQUIRED_PACKAGES += developer/amix/gcc-14
REQUIRED_PACKAGES += developer/amix/gcc-27
REQUIRED_PACKAGES += developer/amix/sysroot
