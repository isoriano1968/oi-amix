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
# developer/amix/zz9000eth-kit -- /dev/zz0, major 52: the MNT ZZ9000 Ethernet
# (STREAMS/DLPI), derived from the Z3660 Ethernet driver. Two kits: zz9000eth
# (stock 68030 kernel) and zz9000eth-040 (68040/68060 port kernels).
# Built from amix-gate with gcc 2.7.2.3 against the AMIX headers of
# developer/amix/sysroot; no AMIX kernel is included.
#
# make-kit-030.sh and make-kit-040.sh compile the kernel code with gcc 2.7.2.3 (developer/amix/
# gcc-27) against the AMIX 2.1c kernel headers of developer/amix/sysroot, and
# runs its checks with the m68k-elf binutils of developer/amix/gcc-14.
#

BUILD_BITS =		NO_ARCH
BUILD_STYLE =		justmake

include ../../../make-rules/shared-macros.mk

COMPONENT_NAME =	amix-zz9000eth-kit
COMPONENT_VERSION =	0.1
COMPONENT_REVISION =	1
COMPONENT_SUMMARY =	zz9000eth kernel driver kit for the AMIX Installer
COMPONENT_PROJECT_URL =	https://github.com/isoriano1968/amix-gate
COMPONENT_FMRI =	developer/amix/zz9000eth-kit
COMPONENT_CLASSIFICATION = Development/System
COMPONENT_LICENSE =	MIT
COMPONENT_LICENSE_FILE = amix-zz9000eth-kit.license

AMIX_GATE_COMMIT =	400b2263b4b0272850b2403e098ebc7a585411e8
COMPONENT_SRC =		amix-gate-$(AMIX_GATE_COMMIT)
COMPONENT_ARCHIVE =	$(COMPONENT_SRC).tar.gz
COMPONENT_ARCHIVE_HASH = sha256:cd3c754742fd6168ce0d70326764c5d7a2de8030c20d2193ab92de6c9b8bd588
COMPONENT_ARCHIVE_URL =	https://github.com/isoriano1968/amix-gate/archive/$(AMIX_GATE_COMMIT).tar.gz

# no tests of its own: gmake test says so and succeeds
TEST_TARGET =		$(NO_TESTS)

include $(WS_MAKE_RULES)/common.mk

PATH =			/opt/amix-cross/bin:/opt/m68k-amix/bin:$(PATH.gnu)

AMIX_SYSROOT =		/opt/m68k-amix-sysroot
KIT_PORT =		$(SOURCE_DIR)/usr/src/uts/amiga/io/zz9000eth/port
KIT_DIR =		/usr/share/amix-installer/zz9000eth

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
