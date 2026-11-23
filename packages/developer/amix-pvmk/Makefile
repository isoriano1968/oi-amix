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
# developer/amix/pvmk -- pvmk (SORIX-ILOM-LDOM), the Amiga 3000 boot loader
# and paravirtualising microkernel that boots AMIX from its own PVMK
# partition, as the AMIX Installer needs it to write pvmk.hdf: the boot block
# and the image (m68k, for the Amiga) in /usr/share/pvmk with the boot menu
# template, and the host tools mkadf and mkhdf in /usr/lib/pvmk.
#
# pvmk at a pinned commit, built here: the m68k part with the AMIX cross
# compiler of developer/amix/gcc-14 (m68k-elf gcc 14.2), the host tools with
# OpenIndiana's gcc.  amix-userland's components/system/pvmk is the same
# build for Linux.
#
# patches/0001 is pvmk's own change for m68k-elf (prepared upstream, not yet
# committed there): -mno-align-int -mno-strict-align (m68k-elf aligns int to
# 32 bits and splits longword reads; the image would not fit), the OS macros
# undefined (the AMIX specs define "amix", a label in svc/shell.c), and wc -c
# and shell arithmetic in place of GNU stat and gawk.  Once upstream has it,
# the pin moves and the patch goes.
#
# Linked without libgcc (LIBGCC=): pvmk needs no helper, and gcc-14's libgcc
# is built for the 68060; the link fails if one is ever needed.  pvmk's own
# "check" runs in the build (68060-safe instructions, size budgets, the
# 320 KB hole, ADF verify).  The archive has no git, so the version string
# is the commit and SOURCE_DATE_EPOCH the commit's time: the same image on
# every build.
#

BUILD_BITS =		64
BUILD_STYLE =		justmake

include ../../../make-rules/shared-macros.mk

COMPONENT_NAME =	amix-pvmk
COMPONENT_VERSION =	2026.11.8
COMPONENT_REVISION =	1
COMPONENT_SUMMARY =	pvmk, the Amiga 3000 boot loader for AMIX, for the AMIX Installer
COMPONENT_PROJECT_URL =	https://github.com/isoriano1968/pvmk
COMPONENT_FMRI =	developer/amix/pvmk
COMPONENT_CLASSIFICATION = System/Administration and Configuration
COMPONENT_LICENSE =	MIT
COMPONENT_LICENSE_FILE = amix-pvmk.license

PVMK_COMMIT =		79c08e13c4cc733b7b8f2029adc106abd59769f1
PVMK_EPOCH =		1794132672
COMPONENT_SRC =		pvmk-$(PVMK_COMMIT)
COMPONENT_ARCHIVE =	$(COMPONENT_SRC).tar.gz
COMPONENT_ARCHIVE_HASH = sha256:dadf400e5311e234fcf8c03eab76e5c8cac893d6a196b953e5fa4aa8fd871328
COMPONENT_ARCHIVE_URL =	https://github.com/isoriano1968/pvmk/archive/$(PVMK_COMMIT).tar.gz

# no tests of its own: gmake test says so and succeeds
TEST_TARGET =		$(NO_TESTS)

include $(WS_MAKE_RULES)/common.mk

PATH =			$(PATH.gnu)

AMIX_CROSS =		/opt/m68k-amix/bin/m68k-elf-
PVMK_VERSION =		$(shell echo $(PVMK_COMMIT) | cut -c1-7)
SHARE_DIR =		$(PROTO_DIR)/usr/share/pvmk
LIB_DIR =		$(PROTO_DIR)/usr/lib/pvmk

# pvmk's Makefile runs in the source tree (relative source paths); its
# output goes to the build directory (B=), given relative to the source
# tree: illumos ld names the output, as given, in a FILE symbol of the host
# tools (no build path).
PVMK_B = ../build/$(notdir $(@D))/pvmk
PVMK_MAKE = $(ENV) SOURCE_DATE_EPOCH=$(PVMK_EPOCH) \
	$(GMAKE) -C $(SOURCE_DIR) B=$(PVMK_B) \
	CROSS=$(AMIX_CROSS) LIBGCC= HOSTCC="$(CC) $(CC_BITS) $(gcc_PATH_MAP)" \
	PYTHON=$(PYTHON) VERSION=$(PVMK_VERSION)

COMPONENT_COPY_ACTION =
COMPONENT_CONFIGURE_ACTION = true

define COMPONENT_BUILD_ACTION
$(PVMK_MAKE) all
$(PVMK_MAKE) check $(PVMK_B)/host/mkhdf
endef

define COMPONENT_INSTALL_ACTION
$(RM) -r $(SHARE_DIR) $(LIB_DIR)
$(MKDIR) $(SHARE_DIR)/conf $(LIB_DIR)
$(CP) $(@D)/pvmk/bootblock.bin $(@D)/pvmk/pvmk.bin $(SHARE_DIR)/
echo $(PVMK_VERSION) > $(SHARE_DIR)/VERSION
$(CP) $(SOURCE_DIR)/conf/pvmk.conf $(SOURCE_DIR)/conf/README.disk $(SHARE_DIR)/conf/
$(CP) $(@D)/pvmk/host/mkadf $(@D)/pvmk/host/mkhdf $(LIB_DIR)/
endef

PYTHON_VERSION =	3.9

REQUIRED_PACKAGES += developer/amix/gcc-14
REQUIRED_PACKAGES += runtime/python-39
REQUIRED_PACKAGES += system/library
