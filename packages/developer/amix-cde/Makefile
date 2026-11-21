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
# developer/amix/cde -- amix-userland's desktop/cde: CDE on shared libraries, /usr/dt, from the
# pinned CDE release, against developer/amix/motif, libxp and x11r6.3.
# The component's own "gmake stage" does everything (download checks, unpack,
# patch, build, stage checked against its manifest); this package takes the
# stage into /opt/m68k-amix-sysroot.  The extra archives are only downloaded
# here (no COMPONENT_SRC) and put where the component expects them.
#
BUILD_BITS =		NO_ARCH
BUILD_STYLE =		justmake

include ../../../make-rules/shared-macros.mk

COMPONENT_NAME =	amix-cde
COMPONENT_VERSION =	2.2.4
# rev 1: rebuilt with gcc-14 rev 4 (no build-host paths from libgcc)
COMPONENT_REVISION =	1
COMPONENT_SUMMARY =	CDE 2.2.4a (libraries, headers, desktop) for the AMIX sysroot
COMPONENT_PROJECT_URL =	https://github.com/isoriano1968/amix-userland
COMPONENT_FMRI =	developer/amix/cde
COMPONENT_CLASSIFICATION = Development/X11
COMPONENT_LICENSE =	LGPLv2.1
COMPONENT_LICENSE_FILE = amix-cde.license

AMIX_USERLAND_COMMIT =	b69a1be25c55218cfdfc57d1ea4e6039904adec2
COMPONENT_SRC =		amix-userland-$(AMIX_USERLAND_COMMIT)
COMPONENT_ARCHIVE =	$(COMPONENT_SRC).tar.gz
COMPONENT_ARCHIVE_HASH = sha256:39d96a572a2cfa1abb436e7b3f2e1647414cfc9f443df93c3d74fb0640add5bb
COMPONENT_ARCHIVE_URL =	https://github.com/isoriano1968/amix-userland/archive/$(AMIX_USERLAND_COMMIT).tar.gz

COMPONENT_ARCHIVE_1 =	cde-src-2.2.4a.tar.gz
COMPONENT_ARCHIVE_HASH_1 = sha256:63db1628daecedbe9768ef0ef8079ae02ecdd8dbd7aca63e47ef480a8e4b8b35
COMPONENT_ARCHIVE_URL_1 = https://sourceforge.net/projects/cdesktopenv/files/src/cde-src-2.2.4a.tar.gz/download
COMPONENT_ARCHIVE_2 =	motif-2.3.8.tar.gz
COMPONENT_ARCHIVE_HASH_2 = sha256:859b723666eeac7df018209d66045c9853b50b4218cecadb794e2359619ebce7
COMPONENT_ARCHIVE_URL_2 = https://sourceforge.net/projects/motif/files/Motif%202.3.8%20Source%20Code/motif-2.3.8.tar.gz/download
COMPONENT_ARCHIVE_3 =	xc-1.tar.gz
COMPONENT_ARCHIVE_HASH_3 = sha256:a1324ca19ea7a46abacb5a1a72e14e944140e73449dc524403829a694ba370b8
COMPONENT_ARCHIVE_URL_3 = https://www.x.org/archive/X11R6.3/tars/xc-1.tar.gz

include $(WS_MAKE_RULES)/common.mk

# the amix-userland Makefiles and scripts use GNU tar, sed, find and cp
PATH =			$(PATH.gnu)

AMIX_SYSROOT =		/opt/m68k-amix-sysroot
COMP =			$(SOURCE_DIR)/components/desktop/cde
COMP_ARGS =		AMIX_SYSROOT=$(AMIX_SYSROOT) AMIX_TOOLS=/opt/m68k-amix/bin HOST_CC=/usr/bin/gcc HOST_CXX=/usr/bin/g++ \
			CDE_CATALOGS=no

COMPONENT_COPY_ACTION =
COMPONENT_CONFIGURE_ACTION = true

define COMPONENT_BUILD_ACTION
$(MKDIR) $(SOURCE_DIR)/components/desktop/cde/distfiles
$(CP) $(USERLAND_ARCHIVES)cde-src-2.2.4a.tar.gz $(SOURCE_DIR)/components/desktop/cde/distfiles/cde-src-2.2.4a.tar.gz
$(MKDIR) $(SOURCE_DIR)/components/desktop/motif
$(CP) $(USERLAND_ARCHIVES)motif-2.3.8.tar.gz $(SOURCE_DIR)/components/desktop/motif/motif-2.3.8.tar.gz
$(MKDIR) $(SOURCE_DIR)/components/x11/x11r6.3/distfiles
$(CP) $(USERLAND_ARCHIVES)xc-1.tar.gz $(SOURCE_DIR)/components/x11/x11r6.3/distfiles/xc-1.tar.gz
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
REQUIRED_PACKAGES += developer/amix/libxp
REQUIRED_PACKAGES += developer/amix/motif
REQUIRED_PACKAGES += developer/gcc-14
