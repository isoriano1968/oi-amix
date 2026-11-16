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
# developer/amix/rtgfb-kit -- amix-gate's rtgfb driver (/dev/rtgfb, major 54:
# Picasso II for the Xamix X server's cirrus card) as the kit the AMIX
# Installer links into the user's own stock 68030 /stand/unix on the host.
# The user's kernel is never distributed; this package carries only our own
# objects and scripts: rtgfb_030.o, rtgfb_pad.o, patch_rtgfb_cdevsw.py,
# check_relink_relocs.py and KIT.sha256.
#
# make-kit-030.sh compiles the kernel code with gcc 2.7.2.3 (developer/amix/
# gcc-27) against the AMIX 2.1c kernel headers of developer/amix/sysroot, and
# runs its checks with the m68k-elf binutils of developer/amix/gcc-14.
#

BUILD_BITS =		NO_ARCH
BUILD_STYLE =		justmake

include ../../../make-rules/shared-macros.mk

COMPONENT_NAME =	amix-rtgfb-kit
COMPONENT_VERSION =	0.1
COMPONENT_SUMMARY =	rtgfb kernel driver kit for the AMIX Installer (Picasso II)
COMPONENT_PROJECT_URL =	https://github.com/isoriano1968/amix-gate
COMPONENT_FMRI =	developer/amix/rtgfb-kit
COMPONENT_CLASSIFICATION = Development/System
COMPONENT_LICENSE =	MIT
COMPONENT_LICENSE_FILE = amix-rtgfb-kit.license

AMIX_GATE_COMMIT =	59ef02b053ab06514c51c7943b64d6b712ab0796
COMPONENT_SRC =		amix-gate-$(AMIX_GATE_COMMIT)
COMPONENT_ARCHIVE =	$(COMPONENT_SRC).tar.gz
COMPONENT_ARCHIVE_HASH = sha256:11a29f97cf8acc5f7e3d3fbb7750430101f6dbb39720779ebb37eceae98cf4eb
COMPONENT_ARCHIVE_URL =	https://github.com/isoriano1968/amix-gate/archive/$(AMIX_GATE_COMMIT).tar.gz

include $(WS_MAKE_RULES)/common.mk

PATH =			/opt/amix-cross/bin:/opt/m68k-amix/bin:$(PATH.gnu)

AMIX_SYSROOT =		/opt/m68k-amix-sysroot
RTGFB_PORT =		$(SOURCE_DIR)/usr/src/uts/amiga/io/rtgfb/port
KIT_DIR =		/usr/share/amix-installer/rtgfb

COMPONENT_COPY_ACTION =
COMPONENT_CONFIGURE_ACTION = true
COMPONENT_BUILD_ACTION = true

define COMPONENT_INSTALL_ACTION
$(RM) -r $(PROTO_DIR)$(KIT_DIR)
AMIX_ROOT=$(AMIX_SYSROOT) $(SHELL) $(RTGFB_PORT)/make-kit-030.sh $(PROTO_DIR)$(KIT_DIR)
cd $(PROTO_DIR)$(KIT_DIR) && /usr/bin/sha256sum -c KIT.sha256
$(RM) -r $(RTGFB_PORT)/build
endef

COMPONENT_TEST_ACTION = true
COMPONENT_TEST_TARGETS =

REQUIRED_PACKAGES += developer/amix/gcc-14
REQUIRED_PACKAGES += developer/amix/gcc-27
REQUIRED_PACKAGES += developer/amix/sysroot
