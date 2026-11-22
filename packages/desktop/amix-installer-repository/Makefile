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
# Copyright 2026 isoriano1968
#

#
# desktop/amix-installer/repository -- the AMIX packages the AMIX Installer
# serves to AMIX in its network install: an IPS repository (publisher amix)
# of amix-userland packages, built for AMIX (m68k), under
# /usr/share/amix-installer/repo.  The source is the newest version of each
# package, rebuilt from amix-userland on GitHub (x11/xserver-amix and
# packages without changes: their earlier builds);
# the archive holds built AMIX packages, so it is no git source: it is an
# asset of the oi-amix GitHub release it belongs to, downloaded from there
# and checked by its sha256.  Each package in it names its own license.
#
BUILD_BITS =		NO_ARCH
BUILD_STYLE =		justmake

include ../../../make-rules/shared-macros.mk

COMPONENT_NAME =	amix-installer-repository
COMPONENT_VERSION =	2026.11.22.1
COMPONENT_REVISION =	0
COMPONENT_SUMMARY =	AMIX packages for the AMIX Installer network install
COMPONENT_PROJECT_URL =	https://github.com/isoriano1968/amix-userland
COMPONENT_FMRI =	desktop/amix-installer/repository
COMPONENT_CLASSIFICATION = System/Administration and Configuration
COMPONENT_LICENSE =	MIT
COMPONENT_LICENSE_FILE = amix-installer-repository.license

COMPONENT_SRC =		repo
COMPONENT_ARCHIVE =	$(COMPONENT_NAME)-$(COMPONENT_VERSION).tar.gz
COMPONENT_ARCHIVE_HASH = sha256:d35dc9b89952f935f095d847e4a18c74a789ecad83390837fa5f6a3dd9fe61d8
COMPONENT_ARCHIVE_URL =	https://github.com/isoriano1968/oi-amix/releases/download/v0.9.2/$(COMPONENT_ARCHIVE)

include $(WS_MAKE_RULES)/common.mk

COMPONENT_COPY_ACTION =
COMPONENT_CONFIGURE_ACTION = true
COMPONENT_BUILD_ACTION = true
COMPONENT_INSTALL_ACTION = mkdir -p $(PROTO_DIR)/usr/share/amix-installer && \
	rm -rf $(PROTO_DIR)/usr/share/amix-installer/repo && \
	cp -R $(SOURCE_DIR) $(PROTO_DIR)/usr/share/amix-installer/repo && \
	rm -f $(PROTO_DIR)/usr/share/amix-installer/repo/.prep $(PROTO_DIR)/usr/share/amix-installer/repo/.unpacked
COMPONENT_TEST_ACTION = true
COMPONENT_TEST_TARGETS =
