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
# developer/amix/gcc-14 -- the modern AMIX cross compiler, hosted on
# OpenIndiana: gcc 14.2.0 (C and C++) and binutils 2.43.1 for m68k-elf, the
# ABI AMIX userland uses, installed in /opt/m68k-amix as on the Linux workstation.
#
# An oi-userland component (it builds inside an oi-userland workspace; see
# tools/oi-sync.sh).  The recipe is the Solaris project's developer/amix/gcc-14
# (~/Sources/Solaris), which is amix-userland's
# components/developer/gcc-14/toolchain/build-cross.sh at a pinned commit,
# step by step: the same configure options, the same source fixups (its
# patch-*.py), the same specs, repaired headers and compat library
# (libamixc99, amix_init.o).  What differs is only the install: configured
# for /opt/m68k-amix, installed with DESTDIR into the proto area.  gcc and
# binutils are relocatable, so the steps that need an installed compiler
# (specs, headers, compat library) run it from the proto area; TC_PREFIX in
# the generated config.sh points there.
#
# gmp, mpfr and mpc are OpenIndiana's own (library/gmp, mpfr, mpc), where the
# Linux workstation build unpacks them into the gcc tree with download_prerequisites.  (On
# illumos the gettext 0.22 that download_prerequisites also adds does not
# compile: its localename.c declares getlocalename_l against <locale.h>.)
#
# The AMIX sysroot is not part of the package: --with-sysroot names
# /opt/m68k-amix-sysroot, which the user fills from a licensed AMIX
# installation.
#

BUILD_BITS =		64
BUILD_STYLE =		justmake

include ../../../make-rules/shared-macros.mk

COMPONENT_NAME =	amix-gcc-14
COMPONENT_VERSION =	14.2.0
COMPONENT_REVISION =	1
COMPONENT_SUMMARY =	AMIX cross compiler: gcc 14.2.0 (C, C++) and binutils 2.43.1
COMPONENT_PROJECT_URL =	https://github.com/isoriano1968/amix-userland
COMPONENT_FMRI =	developer/amix/gcc-14
COMPONENT_CLASSIFICATION = Development/C
COMPONENT_LICENSE =	GPLv3, GCC Runtime Library Exception v3.1, MIT
COMPONENT_LICENSE_FILE = amix-gcc-14.license

COMPONENT_SRC =		gcc-$(COMPONENT_VERSION)
COMPONENT_ARCHIVE =	$(COMPONENT_SRC).tar.xz
COMPONENT_ARCHIVE_HASH = sha256:a7b39bc69cbf9e25826c5a60ab26477001f7c08d85cec04bc0e29cabed6f3cc9
COMPONENT_ARCHIVE_URL =	https://ftp.gnu.org/gnu/gcc/$(COMPONENT_SRC)/$(COMPONENT_ARCHIVE)

BINUTILS_VERSION =	2.43.1
COMPONENT_SRC_1 =	binutils-$(BINUTILS_VERSION)
COMPONENT_ARCHIVE_1 =	$(COMPONENT_SRC_1).tar.xz
COMPONENT_ARCHIVE_HASH_1 = sha256:13f74202a3c4c51118b797a39ea4200d3f6cfbe224da6d1d95bb938480132dfd
COMPONENT_ARCHIVE_URL_1 = https://ftp.gnu.org/gnu/binutils/$(COMPONENT_ARCHIVE_1)

AMIX_USERLAND_COMMIT =	7b5c96b18852f1b020f3894641e76039be12522a
COMPONENT_SRC_2 =	amix-userland-$(AMIX_USERLAND_COMMIT)
COMPONENT_ARCHIVE_2 =	$(COMPONENT_SRC_2).tar.gz
COMPONENT_ARCHIVE_HASH_2 = sha256:952b2c4a535f57489fb20c3aa0c633af09b2f5c96fd11f31cd97141a09b096f3
COMPONENT_ARCHIVE_URL_2 = https://github.com/isoriano1968/amix-userland/archive/$(AMIX_USERLAND_COMMIT).tar.gz

include $(WS_MAKE_RULES)/common.mk

# The upstream build systems and amix-userland's scripts want GNU tools
# first (install-fixed-headers.sh uses find -printf).
PATH =			$(PATH.gnu)

AMIX14 =		$(SOURCE_DIR_2)/components/developer/gcc-14

TARGET =		m68k-elf
AMIX_PREFIX =		/opt/m68k-amix
AMIX_SYSROOT =		/opt/m68k-amix-sysroot
PROTO_PREFIX =		$(PROTO_DIR)$(AMIX_PREFIX)
GCC_LIBDIR =		lib/gcc/$(TARGET)/$(COMPONENT_VERSION)
AMIX_CPU =		-mcpu=68060

# amix-userland's source fixups (build-cross.sh runs them on the unpacked
# tree), and the config.sh every one of its scripts reads.
COMPONENT_PREP_ACTION = \
	$(PYTHON) $(AMIX14)/toolchain/patch-libstdcxx-configure.py \
		$(SOURCE_DIR)/libstdc++-v3/configure $(AMIX_SYSROOT) && \
	$(PYTHON) $(AMIX14)/toolchain/patch-gcc-svr4-return.py \
		$(SOURCE_DIR)/gcc/config/m68k/m68kemb.h && \
	$(PYTHON) $(AMIX14)/toolchain/patch-gcc-060-fpu.py \
		$(SOURCE_DIR)/gcc/config/m68k/m68k.md && \
	printf '%s\n' '\# written by the OpenIndiana amix-gcc-14 component Makefile' \
		'AMIX_SYSROOT="$(AMIX_SYSROOT)"' \
		'TC_PREFIX="$(PROTO_PREFIX)"' \
		'TC_TARGET="$(TARGET)"' \
		'AMIX_CPU="$(AMIX_CPU)"' > $(AMIX14)/config.sh

# Neither tree needs its manuals built (MAKEINFO=true), as on the Linux workstation.  The
# host compiler is OpenIndiana's gcc, 64-bit; oi-userland's CFLAGS are not
# passed, as build-cross.sh passes none.
HOST_CC =		$(GCC_ROOT)/bin/gcc
HOST_CXX =		$(GCC_ROOT)/bin/g++
MAKE_ARGS =		MAKEINFO=true
BUILD_PATH =		$(PROTO_PREFIX)/bin:$(PATH)

# The configure options are build-cross.sh's; see the comments there for why
# each one (--with-cpu=68060 is a correctness choice, not a speed one).
GCC_CONFIGURE_OPTIONS = \
	--target=$(TARGET) --prefix=$(AMIX_PREFIX) \
	--with-sysroot=$(AMIX_SYSROOT) \
	--enable-languages=c,c++ \
	--disable-nls --disable-shared --disable-threads \
	--disable-libssp --disable-libgomp --disable-libatomic \
	--disable-libquadmath --disable-libvtv --disable-libsanitizer \
	--disable-libstdcxx-filesystem-ts --disable-libstdcxx-pch \
	--disable-libstdcxx-backtrace \
	--disable-multilib --disable-gcov \
	--with-cpu=68060

# Two GNU trees in one build directory ($(BUILD_DIR_64)/binutils and /gcc),
# so the justmake steps are replaced and nothing is cloned.
COMPONENT_COPY_ACTION =

COMPONENT_CONFIGURE_ACTION = \
	$(MKDIR) $(@D)/binutils && cd $(@D)/binutils && \
	CC=$(HOST_CC) CXX=$(HOST_CXX) $(SOURCE_DIR_1)/configure \
		--target=$(TARGET) --prefix=$(AMIX_PREFIX) \
		--with-sysroot=$(AMIX_SYSROOT) \
		--disable-nls --disable-werror --disable-gdb --disable-sim \
		--disable-libdecnumber --disable-readline --disable-gprofng

# Built and installed in build-cross.sh's order; the target libraries need
# the installed compiler, so the build installs into the proto area as it
# goes.  The steps between install-gcc and the target libraries hand the
# build tree's xgcc what the installed driver gets: specs, include-fixed --
# and the compat objects, which the specs name (amix_init.o, -lamixc99).  On
# the Linux workstation the build tree's xgcc finds those in the real prefix; here that
# prefix does not exist, so they go beside xgcc, where -B$(@D)/gcc/gcc/
# finds them.
define COMPONENT_BUILD_ACTION
$(GMAKE) -C $(@D)/binutils -j$(COMPONENT_MAKE_JOBS) $(MAKE_ARGS)
$(GMAKE) -C $(@D)/binutils install DESTDIR=$(PROTO_DIR) $(MAKE_ARGS)
$(RM) -r $(@D)/gcc; $(MKDIR) $(@D)/gcc
cd $(@D)/gcc && PATH=$(BUILD_PATH) CC=$(HOST_CC) CXX=$(HOST_CXX) \
	$(SOURCE_DIR)/configure $(GCC_CONFIGURE_OPTIONS)
PATH=$(BUILD_PATH) $(GMAKE) -C $(@D)/gcc -j$(COMPONENT_MAKE_JOBS) $(MAKE_ARGS) all-gcc
PATH=$(BUILD_PATH) $(GMAKE) -C $(@D)/gcc $(MAKE_ARGS) install-gcc DESTDIR=$(PROTO_DIR)
PATH=$(BUILD_PATH) $(BASH) $(AMIX14)/toolchain/install-specs.sh
$(CP) $(PROTO_PREFIX)/$(GCC_LIBDIR)/specs $(@D)/gcc/gcc/specs
PATH=$(BUILD_PATH) $(GMAKE) -C $(@D)/gcc -j$(COMPONENT_MAKE_JOBS) $(MAKE_ARGS) all-gcc
PATH=$(BUILD_PATH) $(BASH) $(AMIX14)/toolchain/install-fixed-headers.sh
$(MKDIR) $(@D)/gcc/gcc/include-fixed
cp -R $(PROTO_PREFIX)/$(GCC_LIBDIR)/include-fixed/. $(@D)/gcc/gcc/include-fixed/
PATH=$(BUILD_PATH) $(BASH) $(AMIX14)/tools/build-compat.sh
$(CP) $(PROTO_PREFIX)/$(TARGET)/lib/amix_init.o $(PROTO_PREFIX)/$(TARGET)/lib/libamixc99.a $(@D)/gcc/gcc/
PATH=$(BUILD_PATH) $(GMAKE) -C $(@D)/gcc -j$(COMPONENT_MAKE_JOBS) $(MAKE_ARGS) all-target-libgcc
PATH=$(BUILD_PATH) $(GMAKE) -C $(@D)/gcc $(MAKE_ARGS) install-target-libgcc DESTDIR=$(PROTO_DIR)
PATH=$(BUILD_PATH) $(GMAKE) -C $(@D)/gcc -j$(COMPONENT_MAKE_JOBS) $(MAKE_ARGS) all-target-libstdc++-v3
PATH=$(BUILD_PATH) $(GMAKE) -C $(@D)/gcc $(MAKE_ARGS) install-target-libstdc++-v3 DESTDIR=$(PROTO_DIR)
endef

# install: everything is in the proto area already.  First the check
# rebuild-target-libs.sh makes, that no C library function got C++ linkage
# in libstdc++ (the C++ header wrappers were in effect).
#
# Then, as in the Solaris project's component: include-fixed is NOT
# packaged (see amix-gcc-14.p5m).  It holds repaired copies of the AMIX
# system headers, which may not be redistributed.  The package carries what
# makes it on each machine instead: bin/m68k-amix-fixheaders (files/, the
# Solaris project's script, unchanged) and, in share/amix-fixheaders, the
# amix-userland scripts and hand-written headers that script runs.  Root
# runs it once after installing the package.
define COMPONENT_INSTALL_ACTION
bad=$$($(PROTO_PREFIX)/bin/$(TARGET)-nm $(PROTO_PREFIX)/$(TARGET)/lib/libstdc++.a 2>/dev/null | \
	grep -c '_Z4freePv\|_Z6mallocm\|_Z5abortv\|_Z8strerrori' || true); \
	test "$$bad" = 0 || { echo "libstdc++.a has $$bad mangled C library symbols"; exit 1; }
$(MKDIR) $(PROTO_PREFIX)/share/amix-fixheaders/toolchain $(PROTO_PREFIX)/share/amix-fixheaders/compat/include
$(CP) $(AMIX14)/toolchain/install-fixed-headers.sh $(AMIX14)/toolchain/make-kandr-fixes.py \
	$(AMIX14)/toolchain/make-cxx-wrappers.sh $(PROTO_PREFIX)/share/amix-fixheaders/toolchain/
cp -R $(AMIX14)/compat/include/. $(PROTO_PREFIX)/share/amix-fixheaders/compat/include/
$(CP) $(SOURCE_DIR_2)/LICENSE $(PROTO_PREFIX)/share/amix-fixheaders/LICENSE
$(CP) $(COMPONENT_DIR)/files/m68k-amix-fixheaders $(PROTO_PREFIX)/bin/m68k-amix-fixheaders
chmod 755 $(PROTO_PREFIX)/bin/m68k-amix-fixheaders
endef

REQUIRED_PACKAGES += SUNWcs
REQUIRED_PACKAGES += compress/zstd
REQUIRED_PACKAGES += library/gmp
REQUIRED_PACKAGES += library/mpc
REQUIRED_PACKAGES += library/mpfr
REQUIRED_PACKAGES += library/zlib
REQUIRED_PACKAGES += runtime/python-39
REQUIRED_PACKAGES += shell/bash
REQUIRED_PACKAGES += shell/ksh93
REQUIRED_PACKAGES += system/library
REQUIRED_PACKAGES += system/library/g++-14-runtime
REQUIRED_PACKAGES += system/library/gcc-14-runtime
REQUIRED_PACKAGES += system/library/math
