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
# developer/amix/sysroot -- the AMIX 2.1c (patch level 2a) system headers,
# libraries, startup objects, X11 and kernel relink kit, as the sysroot the
# AMIX cross toolchains (developer/amix/gcc-27, developer/amix/gcc-14) build
# against, in /opt/m68k-amix-sysroot.
#
# The files are amigaux/amix-system's usr/ tree, unchanged: Commodore's
# files as shipped and installed, published under Amiga Corporation's
# approval of 2026-09-23 (see amix-sysroot.license).  The commit is the one
# amigaux/amix pins (system/amix-system.pin); the second archive is that amix
# commit, whose system/check-amix-system checks every file against
# system/MANIFEST.sha256 and every link against system/SYMLINKS before
# anything is installed.  To move to a newer amix-system: change both
# commits and hashes, and the revision.
#
# What this package changes, and only in the proto area:
#   - absolute symbolic links (usr/include/X11 -> /usr/X/include and 65
#     more) become relative links inside the sysroot, so they can never
#     resolve into the build host's own /usr
#     (files/relink-sysroot.py);
#   - etc/amix-sysroot.release, the marker amix-userland's
#     tools/amix-sysroot-check requires before anything writes into a
#     sysroot; it records this package's version and both commits.
#
# Not in it: amix-system's etc/, kernels/ and floppies/ (a sysroot needs
# none of them), and nothing of ours (gcc-14's stdint.h and the .pc files
# for the stock libraries come with the toolchain packages).
#
# Every action is facet.devel: a machine with facet.devel=false has no use
# for an m68k sysroot.  The m68k ELF files and AMIX scripts are not analysed
# by pkgdepend (they never run on the host).
#

BUILD_BITS =		NO_ARCH
BUILD_STYLE =		justmake

include ../../../make-rules/shared-macros.mk

COMPONENT_NAME =	amix-sysroot
COMPONENT_VERSION =	2.1.2
COMPONENT_SUMMARY =	AMIX 2.1c sysroot for the AMIX cross compilers
COMPONENT_PROJECT_URL =	https://github.com/amigaux/amix-system
COMPONENT_FMRI =	developer/amix/sysroot
COMPONENT_CLASSIFICATION = Development/System
COMPONENT_LICENSE =	Amiga Corporation approval of 2026-09-23 (Amiga UNIX release)
COMPONENT_LICENSE_FILE = amix-sysroot.license

# amigaux/amix-system at the commit amigaux/amix pins
AMIX_SYSTEM_COMMIT =	debb2e14bce281995d22bd5607a8db1afd4db677
COMPONENT_SRC =		amix-system-$(AMIX_SYSTEM_COMMIT)
COMPONENT_ARCHIVE =	$(COMPONENT_SRC).tar.gz
COMPONENT_ARCHIVE_HASH = sha256:17a24bc82077beb88bc0a3682065a95b6814b61a0fe7d82ff5597cecefd23ba4
COMPONENT_ARCHIVE_URL =	https://github.com/amigaux/amix-system/archive/$(AMIX_SYSTEM_COMMIT).tar.gz

# amigaux/amix: system/amix-system.pin, MANIFEST.sha256, SYMLINKS and
# check-amix-system (MIT)
AMIX_COMMIT =		24bbf59fd1dc81fd793ca0f8891b84cbb5591e25
COMPONENT_SRC_1 =	amix-$(AMIX_COMMIT)
COMPONENT_ARCHIVE_1 =	$(COMPONENT_SRC_1).tar.gz
COMPONENT_ARCHIVE_HASH_1 = sha256:5a4887546cf32e5a14786ea7e18dad9ecc5eb5be323af4d8d1d37808883c5b33
COMPONENT_ARCHIVE_URL_1 = https://github.com/amigaux/amix/archive/$(AMIX_COMMIT).tar.gz

include $(WS_MAKE_RULES)/common.mk

# check-amix-system wants GNU find, sha256sum and readlink
PATH =			$(PATH.gnu)

AMIX_SYSROOT =		/opt/m68k-amix-sysroot
PROTO_SYSROOT =		$(PROTO_DIR)$(AMIX_SYSROOT)
AMIX_SYSTEM_DIR =	$(SOURCE_DIR_1)/system

# Before anything else: the pinned amix commit must pin this amix-system
# commit, and the unpacked tree must match its checksums and link list.
COMPONENT_PREP_ACTION = \
	set -e; \
	grep -q " $(AMIX_SYSTEM_COMMIT)\$$" $(AMIX_SYSTEM_DIR)/amix-system.pin || \
		{ echo "amix $(AMIX_COMMIT) does not pin amix-system $(AMIX_SYSTEM_COMMIT)"; exit 1; }; \
	$(SHELL) $(AMIX_SYSTEM_DIR)/check-amix-system $(SOURCE_DIR); \
	echo "amix-system $(AMIX_SYSTEM_COMMIT): matches MANIFEST.sha256 and SYMLINKS"

# nothing to configure or build: the files are installed as they are
COMPONENT_COPY_ACTION =
COMPONENT_CONFIGURE_ACTION = true
COMPONENT_BUILD_ACTION = true

define COMPONENT_INSTALL_ACTION
$(RM) -r $(PROTO_SYSROOT)
$(MKDIR) $(PROTO_SYSROOT)/etc
cd $(SOURCE_DIR) && $(GTAR) --numeric-owner -cf - usr | \
	(cd $(PROTO_SYSROOT) && $(GTAR) --no-same-owner -xf -)
$(PYTHON) -I $(COMPONENT_DIR)/files/relink-sysroot.py $(PROTO_SYSROOT)
( echo "amix-sysroot=1"; \
  echo "kind=package"; \
  echo "package=$(COMPONENT_FMRI)@$(IPS_COMPONENT_VERSION)"; \
  echo "amix-release=2.1c patch level 2a"; \
  echo "amix-system=$(AMIX_SYSTEM_COMMIT)"; \
  echo "amix=$(AMIX_COMMIT)" ) > $(PROTO_SYSROOT)/etc/amix-sysroot.release
endef

# no test suite: the toolchain packages' smoke tests link against it
COMPONENT_TEST_ACTION = true
COMPONENT_TEST_TARGETS =

REQUIRED_PACKAGES += runtime/python-39
