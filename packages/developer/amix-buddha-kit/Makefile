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
# developer/amix/buddha-kit -- the Buddha and Catweasel Z-II IDE controllers
# (AutoConfig 0x1212:0x00 and 0x1212:0x2A) as SCSI controllers of the stock
# sd.c: their drives are ordinary dd disks (block major 18, char major 40,
# /dev/dsk/cNdUsS).  amigaux amix-gayle-ide (MIT, Emre Bastuz) as carried in
# amix-gate, pristine, with stand-ins for the module-core calls; polled I/O.
# Kits for both kernel lines: buddha (stock 68030) and buddha-040 (68040/060
# port).  Not combinable with z3660scsi-kit in one kernel yet.
# Built from amix-gate with gcc 2.7.2.3 against the AMIX headers of
# developer/amix/sysroot; no AMIX kernel is included.
#

BUILD_BITS =		NO_ARCH
BUILD_STYLE =		justmake

include ../../../make-rules/shared-macros.mk

COMPONENT_NAME =	amix-buddha-kit
COMPONENT_VERSION =	0.1
COMPONENT_SUMMARY =	buddha kernel driver kit for the AMIX Installer (Buddha and Catweasel Z-II IDE)
COMPONENT_PROJECT_URL =	https://github.com/isoriano1968/amix-gate
COMPONENT_FMRI =	developer/amix/buddha-kit
COMPONENT_CLASSIFICATION = Development/System
COMPONENT_LICENSE =	MIT
COMPONENT_LICENSE_FILE = amix-buddha-kit.license

AMIX_GATE_COMMIT =	594e9dec7670272aafaa15a263c097d48f628b41
COMPONENT_SRC =		amix-gate-$(AMIX_GATE_COMMIT)
COMPONENT_ARCHIVE =	$(COMPONENT_SRC).tar.gz
COMPONENT_ARCHIVE_HASH = sha256:b691283d711da0ab793ebe58a8a97466e5b27a70ae5b2b9608784302329ebf2b
COMPONENT_ARCHIVE_URL =	https://github.com/isoriano1968/amix-gate/archive/$(AMIX_GATE_COMMIT).tar.gz

# no tests of its own: gmake test says so and succeeds
TEST_TARGET =		$(NO_TESTS)

include $(WS_MAKE_RULES)/common.mk

PATH =			/opt/amix-cross/bin:/opt/m68k-amix/bin:$(PATH.gnu)

AMIX_SYSROOT =		/opt/m68k-amix-sysroot
KIT_PORT =		$(SOURCE_DIR)/usr/src/uts/amiga/io/buddha/port
KIT_DIR =		/usr/share/amix-installer/buddha

COMPONENT_COPY_ACTION =
COMPONENT_CONFIGURE_ACTION = true
COMPONENT_BUILD_ACTION = true

define COMPONENT_INSTALL_ACTION
$(RM) -r $(PROTO_DIR)$(KIT_DIR) $(PROTO_DIR)$(KIT_DIR)-040
AMIX_ROOT=$(AMIX_SYSROOT) $(SHELL) $(KIT_PORT)/make-kit-030.sh $(PROTO_DIR)$(KIT_DIR)
cd $(PROTO_DIR)$(KIT_DIR) && /usr/bin/sha256sum -c KIT.sha256
AMIX_ROOT=$(AMIX_SYSROOT) $(SHELL) $(KIT_PORT)/make-kit-040.sh $(PROTO_DIR)$(KIT_DIR)-040
cd $(PROTO_DIR)$(KIT_DIR)-040 && /usr/bin/sha256sum -c KIT.sha256
$(RM) -r $(KIT_PORT)/build
endef

REQUIRED_PACKAGES += developer/amix/gcc-14
REQUIRED_PACKAGES += developer/amix/gcc-27
REQUIRED_PACKAGES += developer/amix/sysroot
