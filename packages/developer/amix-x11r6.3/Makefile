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
# developer/amix/x11r6.3 -- X11R6.3 for AMIX in the AMIX sysroot: the client
# libraries as shared libraries (libX*.so.7, the ones the AMIX systems use),
# their headers, .pc files, xauth and the link stubs AMIX's own ld needs, in
# /opt/m68k-amix-sysroot/usr/x11r6 (and usr/local/share/amix-stubs).
#
# Made by amix-userland's x11/x11r6.3 component ("gmake stage") at a pinned
# commit, from pristine X11R6.3 (xc-1/2/3.tar.gz from x.org) plus the AMIX
# port patch, with amix-z3660rtg's cross configuration (host.def) at a pinned
# commit.  The X11R6.3 archives and the RTG archive are only downloaded
# here (no COMPONENT_SRC): the component's install.sh checks and unpacks
# them itself.  Built against the packaged sysroot with the packaged
# toolchains: imake writes Makefiles for gcc-27's names, gcc-14 compiles and
# links every object.
#

BUILD_BITS =		NO_ARCH
BUILD_STYLE =		justmake

include ../../../make-rules/shared-macros.mk

COMPONENT_NAME =	amix-x11r6.3
COMPONENT_VERSION =	6.3
COMPONENT_REVISION =	1
COMPONENT_SUMMARY =	X11R6.3 client libraries, headers and xauth for the AMIX sysroot
COMPONENT_PROJECT_URL =	https://github.com/isoriano1968/amix-userland
COMPONENT_FMRI =	developer/amix/x11r6.3
COMPONENT_CLASSIFICATION = Development/X11
COMPONENT_LICENSE =	X Consortium (MIT/X11), MIT
COMPONENT_LICENSE_FILE = amix-x11r6.3.license

AMIX_USERLAND_COMMIT =	7240dfd0924a3a4cd29ff33a976c0009d317c498
COMPONENT_SRC =		amix-userland-$(AMIX_USERLAND_COMMIT)
COMPONENT_ARCHIVE =	$(COMPONENT_SRC).tar.gz
COMPONENT_ARCHIVE_HASH = sha256:a4cbb0decf9f1e49b99c6dae7867fd78c4bded52116a153a5d20a24d524497bc
COMPONENT_ARCHIVE_URL =	https://github.com/isoriano1968/amix-userland/archive/$(AMIX_USERLAND_COMMIT).tar.gz

# X11R6.3 as x.org has it (the component's SOURCES.sha256)
COMPONENT_ARCHIVE_1 =	xc-1.tar.gz
COMPONENT_ARCHIVE_HASH_1 = sha256:a1324ca19ea7a46abacb5a1a72e14e944140e73449dc524403829a694ba370b8
COMPONENT_ARCHIVE_URL_1 = https://www.x.org/archive/X11R6.3/tars/$(COMPONENT_ARCHIVE_1)
COMPONENT_ARCHIVE_2 =	xc-2.tar.gz
COMPONENT_ARCHIVE_HASH_2 = sha256:cb9e6725a6f10b345c3dea417821d79a0738c09da0a16fe6b14b2ade878dcb8d
COMPONENT_ARCHIVE_URL_2 = https://www.x.org/archive/X11R6.3/tars/$(COMPONENT_ARCHIVE_2)
COMPONENT_ARCHIVE_3 =	xc-3.tar.gz
COMPONENT_ARCHIVE_HASH_3 = sha256:cfc344e80624c08964369af6530e83e94682465c061cb37b9b8078e0b6676891
COMPONENT_ARCHIVE_URL_3 = https://www.x.org/archive/X11R6.3/tars/$(COMPONENT_ARCHIVE_3)

# jusii/amix-z3660rtg: x11/cross/host.def (the component's RTG_COMMIT)
RTG_COMMIT =		91667dec985e32cf652104c1f4028ced924e8d48
COMPONENT_ARCHIVE_4 =	amix-z3660rtg-$(RTG_COMMIT).tar.gz
COMPONENT_ARCHIVE_HASH_4 = sha256:3b41d6bd9a7864bbd52ac8b0b4440cf6734140234b7deaf52d2ebcc111acfdf6
COMPONENT_ARCHIVE_URL_4 = https://github.com/jusii/amix-z3660rtg/archive/$(RTG_COMMIT).tar.gz

# no tests of its own: gmake test says so and succeeds
TEST_TARGET =		$(NO_TESTS)

include $(WS_MAKE_RULES)/common.mk

# the amix-userland Makefiles and scripts use GNU tar, sed, find and cp
PATH =			$(PATH.gnu)

AMIX_SYSROOT =		/opt/m68k-amix-sysroot
X11R63 =		$(SOURCE_DIR)/components/x11/x11r6.3
X11R63_ARGS =		AMIX_SYSROOT=$(AMIX_SYSROOT) \
			AMIX_TOOLS=/opt/m68k-amix/bin \
			GCC27_TOOLS=/opt/amix-cross/bin \
			HOST_CC=/usr/bin/gcc HOST_CPP=/usr/bin/cpp \
			DISTFILES=$(USERLAND_ARCHIVES:%/=%)

# X11R6.3 builds against a clean sysroot (its component Makefile refuses one that
# already holds a /usr/x11r6).  A build machine with the AMIX cross packages installed
# has one in $(AMIX_SYSROOT): the build gets a private copy of it without the
# files of x11r6.3 and of what is built on it (libxp, motif, cde).  The package still installs into
# $(AMIX_SYSROOT); the copy is only the build's.
CLEAN_SYSROOT =		$(BUILD_DIR)/amix-sysroot
CLEAN_PKG =		/usr/bin/pkg
CLEAN_WITHOUT =		developer/amix/x11r6.3 developer/amix/libxp developer/amix/motif developer/amix/cde
define CLEAN_SYSROOT_ACTION
$(RM) -r $(CLEAN_SYSROOT)
$(MKDIR) $(CLEAN_SYSROOT)
cd $(AMIX_SYSROOT) && $(GTAR) -cf - . | (cd $(CLEAN_SYSROOT) && $(GTAR) -xf -)
set -o pipefail; for p in $(CLEAN_WITHOUT); do \
	$(CLEAN_PKG) list -H $$p > /dev/null 2>&1 || continue; \
	$(CLEAN_PKG) contents -H -o path -t file,link,hardlink $$p | \
		sed -n 's|^$(AMIX_SYSROOT:/%=%)/||p' | tr '\n' '\0' | \
		(cd $(CLEAN_SYSROOT) && xargs -0 rm -f) || exit 1; \
done
find $(CLEAN_SYSROOT) -depth -type d -empty -delete
endef

COMPONENT_COPY_ACTION =
COMPONENT_CONFIGURE_ACTION = true

# the component's own target does everything: unpack and patch X11R6.3,
# imake, the shared libraries, the stage (checked against its manifest)
define COMPONENT_BUILD_ACTION
$(CLEAN_SYSROOT_ACTION)
$(GMAKE) -C $(X11R63) $(X11R63_ARGS) AMIX_SYSROOT=$(CLEAN_SYSROOT) stage
endef

define COMPONENT_INSTALL_ACTION
$(RM) -r $(PROTO_DIR)$(AMIX_SYSROOT)
$(MKDIR) $(PROTO_DIR)$(AMIX_SYSROOT)
cd $(X11R63)/build/stage && $(GTAR) --numeric-owner -cf - usr | \
	(cd $(PROTO_DIR)$(AMIX_SYSROOT) && $(GTAR) --no-same-owner -xf -)
endef

REQUIRED_PACKAGES += developer/amix/amixc99
REQUIRED_PACKAGES += developer/amix/gcc-14
REQUIRED_PACKAGES += developer/amix/gcc-27
REQUIRED_PACKAGES += developer/amix/sysroot
REQUIRED_PACKAGES += developer/gcc-14
