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
# metapackages/amix-cross-dev -- everything to start developing for Amiga
# UNIX (AMIX) on OpenIndiana: the AMIX sysroot and both cross toolchains,
# at the versions named in amix-cross-dev.p5m.  One `pkg install
# amix-cross-dev` gives a working cross development system; either
# toolchain alone can still be installed on its own and pulls in the
# sysroot itself.
#
BUILD_STYLE =		pkg

include ../../../make-rules/shared-macros.mk

COMPONENT_NAME =	amix-cross-dev
COMPONENT_VERSION =	1.0
COMPONENT_SUMMARY =	AMIX cross development: sysroot and both cross compilers
COMPONENT_CLASSIFICATION = Meta Packages/Group Packages
COMPONENT_FMRI =	metapackages/amix-cross-dev
COMPONENT_PROJECT_URL =	https://github.com/amigaux/amix-system

include $(WS_MAKE_RULES)/common.mk
