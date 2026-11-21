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
# developer/amix/libxp -- amix-userland's x11/libxp: libXp.so.7 from X11R6.3's xc/lib/Xp (pinned
# xc-1.tar.gz), built with gcc-14 against developer/amix/x11r6.3.
# The component's own "gmake stage" does everything (download checks, unpack,
# patch, build, stage checked against its manifest); this package takes the
# stage into /opt/m68k-amix-sysroot.  The extra archives are only downloaded
# here (no COMPONENT_SRC) and put where the component expects them.
#
BUILD_BITS =		NO_ARCH
BUILD_STYLE =		justmake

include ../../../make-rules/shared-macros.mk

COMPONENT_NAME =	amix-libxp
COMPONENT_VERSION =	6.3
COMPONENT_SUMMARY =	libXp (X Print client library) for the AMIX sysroot
COMPONENT_PROJECT_URL =	https://github.com/isoriano1968/amix-userland
COMPONENT_FMRI =	developer/amix/libxp
COMPONENT_CLASSIFICATION = Development/X11
COMPONENT_LICENSE =	X Consortium (MIT/X11)
COMPONENT_LICENSE_FILE = amix-libxp.license

AMIX_USERLAND_COMMIT =	d0eb7857fec0a823414e9d575df7cf18e2f8baaf
COMPONENT_SRC =		amix-userland-$(AMIX_USERLAND_COMMIT)
COMPONENT_ARCHIVE =	$(COMPONENT_SRC).tar.gz
COMPONENT_ARCHIVE_HASH = sha256:c179c2b03f286a5af24c56f0e372ada1240e430ee65f42b18d2ef7b3baace958
COMPONENT_ARCHIVE_URL =	https://github.com/isoriano1968/amix-userland/archive/$(AMIX_USERLAND_COMMIT).tar.gz

COMPONENT_ARCHIVE_1 =	xc-1.tar.gz
COMPONENT_ARCHIVE_HASH_1 = sha256:a1324ca19ea7a46abacb5a1a72e14e944140e73449dc524403829a694ba370b8
COMPONENT_ARCHIVE_URL_1 = https://www.x.org/archive/X11R6.3/tars/xc-1.tar.gz

include $(WS_MAKE_RULES)/common.mk

# the amix-userland Makefiles and scripts use GNU tar, sed, find and cp
PATH =			$(PATH.gnu)

AMIX_SYSROOT =		/opt/m68k-amix-sysroot
COMP =			$(SOURCE_DIR)/components/x11/libxp
COMP_ARGS =		AMIX_SYSROOT=$(AMIX_SYSROOT) AMIX_TOOLS=/opt/m68k-amix/bin 

COMPONENT_COPY_ACTION =
COMPONENT_CONFIGURE_ACTION = true

define COMPONENT_BUILD_ACTION
$(MKDIR) $(SOURCE_DIR)/components/x11/x11r6.3/distfiles
$(CP) $(USERLAND_ARCHIVES)xc-1.tar.gz $(SOURCE_DIR)/components/x11/x11r6.3/distfiles/xc-1.tar.gz
$(GMAKE) -C $(COMP) $(COMP_ARGS) build stage
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
