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
# desktop/amix-installer -- the AMIX Installer, a GTK 4 / libadwaita app for
# the host: makes an Amiga UNIX disk from your own AMIX core system, or
# installs packages into a running AMIX (real or in FS-UAE).  amix-userland's
# components/desktop/amix-installer at a pinned commit; its own "make
# install" puts it under /usr with the .desktop entry and the hicolor icons
# (the AMIX logo with the wrench, made by tools/mkicons.py with pycairo).
#
BUILD_BITS =		NO_ARCH
BUILD_STYLE =		justmake

include ../../../make-rules/shared-macros.mk

COMPONENT_NAME =	amix-installer
COMPONENT_VERSION =	0.9.3
COMPONENT_REVISION =	0
COMPONENT_SUMMARY =	AMIX Installer: Amiga UNIX disks and packages from the desktop
COMPONENT_PROJECT_URL =	https://github.com/isoriano1968/amix-userland
COMPONENT_FMRI =	desktop/amix-installer
COMPONENT_CLASSIFICATION = System/Administration and Configuration
COMPONENT_LICENSE =	MIT
COMPONENT_LICENSE_FILE = amix-installer.license

AMIX_USERLAND_COMMIT =	34aaaf66bfb1095452640d519fde83d936eba643
COMPONENT_SRC =		amix-userland-$(AMIX_USERLAND_COMMIT)
COMPONENT_ARCHIVE =	$(COMPONENT_SRC).tar.gz
COMPONENT_ARCHIVE_HASH = sha256:b5ccf45ed39db149afab2a2d085dd128ae8720f402ede6414c5ba28da14978f6
COMPONENT_ARCHIVE_URL =	https://github.com/isoriano1968/amix-userland/archive/$(AMIX_USERLAND_COMMIT).tar.gz

include $(WS_MAKE_RULES)/common.mk

PATH =			$(PATH.gnu)
COMP =			$(SOURCE_DIR)/components/desktop/amix-installer

COMPONENT_COPY_ACTION =
COMPONENT_CONFIGURE_ACTION = true
COMPONENT_BUILD_ACTION = $(GMAKE) -C $(COMP) PYTHON=$(PYTHON) build
COMPONENT_INSTALL_ACTION = $(GMAKE) -C $(COMP) PYTHON=$(PYTHON) install DESTDIR=$(PROTO_DIR) HOST_PREFIX=/usr
# gmake test: the component's own unit tests ("make test" in its source).
# oi-userland runs COMPONENT_TEST_CMD with these, in COMPONENT_TEST_DIR,
# under env -i: HOME and TMPDIR so the tests' own temporary files go there.
COMPONENT_TEST_DIR =	$(COMP)
COMPONENT_TEST_ARGS =	PYTHON=$(PYTHON)
COMPONENT_TEST_TARGETS = test
COMPONENT_TEST_ENV +=	HOME="$(COMPONENT_TEST_BUILD_DIR)" TMPDIR="$(COMPONENT_TEST_BUILD_DIR)"

PYTHON_VERSION =	3.9
REQUIRED_PACKAGES += library/python/pycairo-39
REQUIRED_PACKAGES += runtime/python-39
