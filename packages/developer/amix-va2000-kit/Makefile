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
# developer/amix/va2000-kit -- /dev/va2000, major 68: the MNT VA2000 RTG card, with
# asokero's va2000-amix driver (MIT, pinned) + patches/ from amix-gate. Two kits:
# va2000 (stock 68030 kernel, Zorro II) and va2000-040 (68040/68060 port kernels).
# Built from amix-gate with gcc 2.7.2.3 against the AMIX headers of
# developer/amix/sysroot; no AMIX kernel is included.
#
# make-kit-030.sh compiles the kernel code with gcc 2.7.2.3 (developer/amix/
# gcc-27) against the AMIX 2.1c kernel headers of developer/amix/sysroot, and
# runs its checks with the m68k-elf binutils of developer/amix/gcc-14.
#

BUILD_BITS =		NO_ARCH
BUILD_STYLE =		justmake

include ../../../make-rules/shared-macros.mk

COMPONENT_NAME =	amix-va2000-kit
COMPONENT_VERSION =	0.3
COMPONENT_SUMMARY =	va2000 kernel driver kits for the AMIX Installer (MNT VA2000)
COMPONENT_PROJECT_URL =	https://github.com/isoriano1968/amix-gate
COMPONENT_FMRI =	developer/amix/va2000-kit
COMPONENT_CLASSIFICATION = Development/System
COMPONENT_LICENSE =	MIT
COMPONENT_LICENSE_FILE = amix-va2000-kit.license

AMIX_GATE_COMMIT =	eca59c195bcf7ee6d2255568d7529f06d0d9acd7
COMPONENT_SRC =		amix-gate-$(AMIX_GATE_COMMIT)
COMPONENT_ARCHIVE =	$(COMPONENT_SRC).tar.gz
COMPONENT_ARCHIVE_HASH = sha256:49d201b366ebc1a06a5fae9f643a88655d714065f561210ca46493d34b0e59b3
COMPONENT_ARCHIVE_URL =	https://github.com/isoriano1968/amix-gate/archive/$(AMIX_GATE_COMMIT).tar.gz

VA2000_COMMIT =		7f82edcc3db9ddb0f28173ee41abe6c439e98327
COMPONENT_SRC_1 =	va2000-amix-$(VA2000_COMMIT)
COMPONENT_ARCHIVE_1 =	$(COMPONENT_SRC_1).tar.gz
COMPONENT_ARCHIVE_HASH_1 = sha256:d97683a3f611aa16d9ca29d8c2d359c9f96a028ec0185550d4412c2b1dd9895c
COMPONENT_ARCHIVE_URL_1 = https://github.com/asokero/va2000-amix/archive/$(VA2000_COMMIT).tar.gz

# no tests of its own: gmake test says so and succeeds
TEST_TARGET =		$(NO_TESTS)

include $(WS_MAKE_RULES)/common.mk

PATH =			/opt/amix-cross/bin:/opt/m68k-amix/bin:$(PATH.gnu)

AMIX_SYSROOT =		/opt/m68k-amix-sysroot
KIT_PORT =		$(SOURCE_DIR)/usr/src/uts/amiga/io/va2000/port
KIT_DIR =		/usr/share/amix-installer/va2000

COMPONENT_COPY_ACTION =
COMPONENT_CONFIGURE_ACTION = true
COMPONENT_BUILD_ACTION = true

define COMPONENT_INSTALL_ACTION
$(RM) -r $(PROTO_DIR)$(KIT_DIR) $(PROTO_DIR)$(KIT_DIR)-040
VA2000_SRC_DIR=$(SOURCE_DIR_1) AMIX_ROOT=$(AMIX_SYSROOT) $(SHELL) $(KIT_PORT)/make-kit-030.sh $(PROTO_DIR)$(KIT_DIR)
VA2000_SRC_DIR=$(SOURCE_DIR_1) AMIX_ROOT=$(AMIX_SYSROOT) $(SHELL) $(KIT_PORT)/make-kit-040.sh $(PROTO_DIR)$(KIT_DIR)-040
cd $(PROTO_DIR)$(KIT_DIR) && /usr/bin/sha256sum -c KIT.sha256
cd $(PROTO_DIR)$(KIT_DIR)-040 && /usr/bin/sha256sum -c KIT.sha256
$(RM) -r $(KIT_PORT)/build
endef

REQUIRED_PACKAGES += developer/amix/gcc-14
REQUIRED_PACKAGES += developer/amix/gcc-27
REQUIRED_PACKAGES += developer/amix/sysroot
