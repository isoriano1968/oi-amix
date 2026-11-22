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
# developer/amix/amixc99 -- amix-userland's library/amixc99 in the AMIX
# sysroot: libamixc99.so.1 in /usr/lib (the C99/POSIX functions AMIX
# SVR4.0's libc lacks, snprintf and friends, amix_cpu), its link stub,
# amixc99.pc, amix_cpu.h, and stdint.h, stdbool.h and inttypes.h for gcc 2.7
# at the sysroot's /usr/local, as on AMIX.  Version 2: the shared library
# (version 1 was the archive libamixc99.a).
#
# The stage is made by the amix-userland component's own Makefile at the
# pinned commit (the same commit developer/amix/gcc-14 is built from), with
# the packaged gcc-14: its libamixc99.so.1 is the one gcc-14 links every
# program against, so gcc-27 programs and pkg-config users (x11.pc requires
# amixc99) link the same library.
#

BUILD_BITS =		NO_ARCH
BUILD_STYLE =		justmake

include ../../../make-rules/shared-macros.mk

COMPONENT_NAME =	amix-amixc99
COMPONENT_VERSION =	2
COMPONENT_SUMMARY =	libamixc99, amixc99.pc and C99 headers for the AMIX sysroot
COMPONENT_PROJECT_URL =	https://github.com/isoriano1968/amix-userland
COMPONENT_FMRI =	developer/amix/amixc99
COMPONENT_CLASSIFICATION = Development/C
COMPONENT_LICENSE =	MIT
COMPONENT_LICENSE_FILE = amix-amixc99.license

AMIX_USERLAND_COMMIT =	5bae14a830d0c7f866c84fd5cab8808eec6ac9d9
COMPONENT_SRC =		amix-userland-$(AMIX_USERLAND_COMMIT)
COMPONENT_ARCHIVE =	$(COMPONENT_SRC).tar.gz
COMPONENT_ARCHIVE_HASH = sha256:f25b862c59ee1665811dc1e7b068dff175985ce3bdf50c0764b43a2480b387d3
COMPONENT_ARCHIVE_URL =	https://github.com/isoriano1968/amix-userland/archive/$(AMIX_USERLAND_COMMIT).tar.gz

include $(WS_MAKE_RULES)/common.mk

# the amix-userland Makefiles use GNU tar, sed and cp options
PATH =			$(PATH.gnu)

AMIX_SYSROOT =		/opt/m68k-amix-sysroot
AMIX_TOOLS =		/opt/m68k-amix/bin
AMIXC99 =		$(SOURCE_DIR)/components/library/amixc99

COMPONENT_COPY_ACTION =
COMPONENT_CONFIGURE_ACTION = true
COMPONENT_BUILD_ACTION = true

define COMPONENT_INSTALL_ACTION
PATH=$(AMIX_TOOLS):$(PATH) $(GMAKE) -C $(AMIXC99) stage AMIX_TOOLS=$(AMIX_TOOLS) AMIX_SYSROOT=$(AMIX_SYSROOT) PREFIX=/usr/local
$(RM) -r $(PROTO_DIR)$(AMIX_SYSROOT)
$(MKDIR) $(PROTO_DIR)$(AMIX_SYSROOT)
cd $(AMIXC99)/build/stage && $(GTAR) --numeric-owner -cf - usr | \
	(cd $(PROTO_DIR)$(AMIX_SYSROOT) && $(GTAR) --no-same-owner -xf -)
cmp $(PROTO_DIR)$(AMIX_SYSROOT)/usr/lib/libamixc99.so.1 \
	`$(AMIX_TOOLS)/m68k-elf-gcc -print-file-name=libamixc99.so.1`
endef

COMPONENT_TEST_ACTION = true
COMPONENT_TEST_TARGETS =

REQUIRED_PACKAGES += developer/amix/gcc-14
REQUIRED_PACKAGES += developer/build/pkg-config
REQUIRED_PACKAGES += developer/amix/sysroot
