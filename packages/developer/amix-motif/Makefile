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
# Copyright 2026 isoriano1968
#

#
# developer/amix/motif -- amix-userland's desktop/motif: libXm.so.4, libMrm.so.4, headers, .pc,
# mwm, from the pinned motif-2.3.8.tar.gz, built against developer/amix/x11r6.3.
# The component's own "gmake stage" does everything (download checks, unpack,
# patch, build, stage checked against its manifest); this package takes the
# stage into /opt/m68k-amix-sysroot.  The extra archives are only downloaded
# here (no COMPONENT_SRC) and put where the component expects them.
#
BUILD_BITS =		NO_ARCH
BUILD_STYLE =		justmake

include ../../../make-rules/shared-macros.mk

COMPONENT_NAME =	amix-motif
COMPONENT_VERSION =	2.3.8
COMPONENT_REVISION =	1
COMPONENT_SUMMARY =	Motif 2.3.8 (libXm, libMrm, mwm) for the AMIX sysroot
COMPONENT_PROJECT_URL =	https://github.com/isoriano1968/amix-userland
COMPONENT_FMRI =	developer/amix/motif
COMPONENT_CLASSIFICATION = Development/X11
COMPONENT_LICENSE =	LGPLv2.1
COMPONENT_LICENSE_FILE = amix-motif.license

AMIX_USERLAND_COMMIT =	b69a1be25c55218cfdfc57d1ea4e6039904adec2
COMPONENT_SRC =		amix-userland-$(AMIX_USERLAND_COMMIT)
COMPONENT_ARCHIVE =	$(COMPONENT_SRC).tar.gz
COMPONENT_ARCHIVE_HASH = sha256:39d96a572a2cfa1abb436e7b3f2e1647414cfc9f443df93c3d74fb0640add5bb
COMPONENT_ARCHIVE_URL =	https://github.com/isoriano1968/amix-userland/archive/$(AMIX_USERLAND_COMMIT).tar.gz

COMPONENT_ARCHIVE_1 =	motif-2.3.8.tar.gz
COMPONENT_ARCHIVE_HASH_1 = sha256:859b723666eeac7df018209d66045c9853b50b4218cecadb794e2359619ebce7
COMPONENT_ARCHIVE_URL_1 = https://sourceforge.net/projects/motif/files/Motif%202.3.8%20Source%20Code/motif-2.3.8.tar.gz/download

include $(WS_MAKE_RULES)/common.mk

# the amix-userland Makefiles and scripts use GNU tar, sed, find and cp
PATH =			$(PATH.gnu)

AMIX_SYSROOT =		/opt/m68k-amix-sysroot
COMP =			$(SOURCE_DIR)/components/desktop/motif
COMP_ARGS =		AMIX_SYSROOT=$(AMIX_SYSROOT) AMIX_TOOLS=/opt/m68k-amix/bin HOST_CC=/usr/bin/gcc

COMPONENT_COPY_ACTION =
COMPONENT_CONFIGURE_ACTION = true

define COMPONENT_BUILD_ACTION
$(MKDIR) $(SOURCE_DIR)/components/desktop/motif
$(CP) $(USERLAND_ARCHIVES)motif-2.3.8.tar.gz $(SOURCE_DIR)/components/desktop/motif/motif-2.3.8.tar.gz
$(GMAKE) -C $(COMP) $(COMP_ARGS) stage
endef

define COMPONENT_INSTALL_ACTION
$(RM) -r $(PROTO_DIR)$(AMIX_SYSROOT)
$(MKDIR) $(PROTO_DIR)$(AMIX_SYSROOT)
cd $(COMP)/build/stage && $(GTAR) --numeric-owner -cf - usr | \
	(cd $(PROTO_DIR)$(AMIX_SYSROOT) && $(GTAR) --no-same-owner -xf -)
endef

COMPONENT_TEST_ACTION = true
COMPONENT_TEST_TARGETS =

REQUIRED_PACKAGES += developer/amix/sysroot
REQUIRED_PACKAGES += developer/amix/amixc99
REQUIRED_PACKAGES += developer/amix/gcc-14
REQUIRED_PACKAGES += developer/amix/x11r6.3
REQUIRED_PACKAGES += developer/gcc-14
