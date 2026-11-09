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
# developer/amix/gcc-27 -- the AMIX cross toolchain, hosted on OpenIndiana:
# gcc 2.7.2.3 and binutils 2.8.1 for m68k-cbm-sysv4 (AMIX 2.1, the kernel's
# own compiler), installed in /opt/amix-cross as on the Linux workstation.
#
# An oi-userland component (it builds inside an oi-userland workspace; see
# tools/oi-sync.sh).  The recipe is the same as the Solaris project's
# developer/amix/gcc-27 (~/Sources/Solaris): keep the two in step.
#
# Everything AMIX-specific comes from amix-userland's gcc-27 component at a
# pinned commit (the third archive): its patches to the two GNU trees, the
# driver wrapper that repairs gcc's SGS assembly (amix-gcc-wrapper.sh) and
# the libgcc2 function list.  This Makefile does what that component's
# Makefile does, with a DESTDIR-style install into the proto area.  To move
# to a newer amix-userland, change AMIX_USERLAND_COMMIT and the hash.
#
# Our own patch, patches/0001-wrapper-portable-mktemp.patch_2, is for
# amix-userland's wrapper and belongs upstream: illumos mktemp does not fill
# in the wrapper's amix-gcc.XXXXXX.s template, so parallel compiles shared
# one temporary file; and "exec ld" skipped the cleanup of every
# compile-and-link.  Drop it once the pinned commit has the fix.
#
# The host binaries are 32-bit: gcc 2.7 was written for 32-bit hosts, and
# its config/i386/xm-i386.h hard-codes HOST_BITS_PER_LONG 32.  The AMIX
# sysroot is not part of the package: the link
# /opt/amix-cross/m68k-cbm-sysv4/sysroot points at /opt/m68k-amix-sysroot,
# which the user fills from a licensed AMIX installation.
#

BUILD_BITS =		32
BUILD_STYLE =		justmake

include ../../../make-rules/shared-macros.mk

COMPONENT_NAME =	amix-gcc-27
COMPONENT_VERSION =	2.7.2.3
COMPONENT_REVISION =	1
COMPONENT_SUMMARY =	AMIX cross compiler: gcc 2.7.2.3 and binutils 2.8.1
COMPONENT_PROJECT_URL =	https://github.com/isoriano1968/amix-userland
COMPONENT_FMRI =	developer/amix/gcc-27
COMPONENT_CLASSIFICATION = Development/C
COMPONENT_LICENSE =	GPLv2, MIT
COMPONENT_LICENSE_FILE = amix-gcc-27.license

COMPONENT_SRC =		gcc-$(COMPONENT_VERSION)
COMPONENT_ARCHIVE =	$(COMPONENT_SRC).tar.gz
COMPONENT_ARCHIVE_HASH = sha256:16166e0f0f2064bb3114716650569065ef3855ae2331d7a29b85d4b9aa73773c
COMPONENT_ARCHIVE_URL =	https://ftp.gnu.org/gnu/gcc/$(COMPONENT_ARCHIVE)

BINUTILS_VERSION =	2.8.1
COMPONENT_SRC_1 =	binutils-$(BINUTILS_VERSION)
COMPONENT_ARCHIVE_1 =	$(COMPONENT_SRC_1).tar.gz
COMPONENT_ARCHIVE_HASH_1 = sha256:c7ad94c18f098f0580d0a7cd68638e98aa98571078536934fdc85f5e9047bf5a
COMPONENT_ARCHIVE_URL_1 = https://ftp.gnu.org/gnu/binutils/$(COMPONENT_ARCHIVE_1)

AMIX_USERLAND_COMMIT =	7b5c96b18852f1b020f3894641e76039be12522a
COMPONENT_SRC_2 =	amix-userland-$(AMIX_USERLAND_COMMIT)
COMPONENT_ARCHIVE_2 =	$(COMPONENT_SRC_2).tar.gz
COMPONENT_ARCHIVE_HASH_2 = sha256:952b2c4a535f57489fb20c3aa0c633af09b2f5c96fd11f31cd97141a09b096f3
COMPONENT_ARCHIVE_URL_2 = https://github.com/isoriano1968/amix-userland/archive/$(AMIX_USERLAND_COMMIT).tar.gz

include $(WS_MAKE_RULES)/common.mk

# The upstream build systems want GNU tools first.
PATH =			$(PATH.gnu)

AMIX_GCC27 =		$(SOURCE_DIR_2)/components/developer/gcc-27

# amix-userland's patches are rooted above the source trees
# (a/gcc-2.7.2.3/..., a/binutils-2.8.1/...), so they are applied from the
# component directory, straight from the pinned archive (patches/ holds only
# our own, which oi-userland applies per tree).  gcc's tarball is read-only;
# its generated parser and gperf output must stay newer than their sources,
# or make wants bison and gperf to remake them.
COMPONENT_PREP_ACTION = \
	set -e; for p in $(AMIX_GCC27)/patches/binutils-*.patch $(AMIX_GCC27)/patches/gcc-*.patch; do \
		echo "amix-userland patch: $$p"; \
		chmod -R u+w $(SOURCE_DIR) $(SOURCE_DIR_1); \
		(cd $(COMPONENT_DIR) && $(GPATCH) -s -p1 --no-backup-if-mismatch < $$p); \
	done; \
	touch $(SOURCE_DIR)/c-parse.c $(SOURCE_DIR)/c-gperf.h

TARGET =		m68k-cbm-sysv4
HOST_TRIPLET =		i386-pc-solaris2.11
AMIX_PREFIX =		/opt/amix-cross
AMIX_SYSROOT =		/opt/m68k-amix-sysroot
PROTO_PREFIX =		$(PROTO_DIR)$(AMIX_PREFIX)
GCC_LIBDIR =		lib/gcc-lib/$(TARGET)/$(COMPONENT_VERSION)

# The Linux workstation builds with -O2 -g -std=gnu89 -fcommon (and -no-pie, a Linux
# default); here the same, 32-bit.  oi-userland's own CFLAGS are not used:
# the 1995 sources and the byte-for-byte comparison with the Linux workstation want these.
HOST_CC =		$(GCC_ROOT)/bin/gcc -m32
HOST_CFLAGS =		-O2 -g -std=gnu89 -fcommon
HOST_MAKE_ARGS =	CC="$(HOST_CC)" CFLAGS="$(HOST_CFLAGS)" MAKEINFO=true

# The libgcc2 routines amix-userland's Makefile builds (LIBGCC2_FUNCS there).
LIBGCC2_FUNCS =		_muldi3 _divdi3 _moddi3 _udivdi3 _umoddi3 _negdi2 \
			_lshrdi3 _ashldi3 _ashrdi3 _udiv_w_sdiv _udivmoddi4 _cmpdi2 _ucmpdi2 \
			_floatdidf _floatdisf _floatdixf _fixunsdfdi _fixdfdi _fixunssfdi \
			__gcc_bcmp _clear_cache _shtab _trampoline

# Two GNU trees in one build directory ($(BUILD_DIR_32)/binutils and /gcc),
# so the justmake steps are replaced and nothing is cloned.
COMPONENT_COPY_ACTION =

# configure: binutils.  Both trees use the old Cygnus configure, which takes
# the prefix at configure time and lets "make install" override it -- that is
# the DESTDIR of this era.
COMPONENT_CONFIGURE_ACTION = \
	$(MKDIR) $(@D)/binutils && cd $(@D)/binutils && \
	CC="$(HOST_CC)" CFLAGS="$(HOST_CFLAGS)" $(SOURCE_DIR_1)/configure \
		--build=$(HOST_TRIPLET) --host=$(HOST_TRIPLET) --target=$(TARGET) \
		--prefix=$(AMIX_PREFIX) --disable-nls

BINUTILS_INSTALL_DIRS =	prefix=$(PROTO_PREFIX) exec_prefix=$(PROTO_PREFIX) \
			tooldir=$(PROTO_PREFIX)/$(TARGET)

# build: binutils, installed into the proto area at once (gcc's build needs
# the target ar and ranlib), then gcc: only the driver (xgcc), the C compiler
# proper (cc1) and the preprocessor (cccp), as amix-userland builds them.
# libgcc1 is not built from gcc's own rules (it needs the target's libc); an
# empty libgcc1.a lets the build go on, and libgcc2 is built at install time
# through the wrapper instead.
define COMPONENT_BUILD_ACTION
$(GMAKE) -C $(@D)/binutils -j$(COMPONENT_MAKE_JOBS) $(HOST_MAKE_ARGS)
$(MKDIR) $(PROTO_PREFIX)
$(GMAKE) -C $(@D)/binutils install $(HOST_MAKE_ARGS) $(BINUTILS_INSTALL_DIRS)
$(RM) -r $(@D)/gcc; $(MKDIR) $(@D)/gcc
cd $(@D)/gcc && PATH=$(PROTO_PREFIX)/bin:$(PATH) CC="$(HOST_CC)" CFLAGS="$(HOST_CFLAGS)" \
	$(SOURCE_DIR)/configure \
	--build=$(HOST_TRIPLET) --host=$(HOST_TRIPLET) --target=$(TARGET) \
	--prefix=$(AMIX_PREFIX) --with-gnu-as --with-gnu-ld
cd $(@D)/gcc && $(PROTO_PREFIX)/bin/$(TARGET)-ar rc libgcc1.a && \
	$(PROTO_PREFIX)/bin/$(TARGET)-ranlib libgcc1.a
PATH=$(PROTO_PREFIX)/bin:$(PATH) $(GMAKE) -C $(@D)/gcc -j$(COMPONENT_MAKE_JOBS) \
	LANGUAGES=c $(HOST_MAKE_ARGS) xgcc cc1 cccp
endef

# install: the compiler, the wrapper in front of it (the installed
# m68k-cbm-sysv4-gcc is the wrapper; the real driver is ...-gcc.real), the
# specs, the sysroot link, then libgcc.a -- compiled through the installed
# wrapper, as on the Linux workstation, so its assembly gets the same repairs.  The real
# driver looks for cc1 under the configured prefix; GCC_EXEC_PREFIX points
# it at the proto area instead.
define COMPONENT_INSTALL_ACTION
$(MKDIR) $(PROTO_PREFIX)/bin $(PROTO_PREFIX)/$(GCC_LIBDIR) $(PROTO_PREFIX)/$(TARGET)
$(CP) $(@D)/gcc/xgcc $(PROTO_PREFIX)/bin/$(TARGET)-gcc.real
$(CP) $(@D)/gcc/cc1 $(PROTO_PREFIX)/$(GCC_LIBDIR)/cc1
$(CP) $(@D)/gcc/cccp $(PROTO_PREFIX)/$(GCC_LIBDIR)/cpp
$(@D)/gcc/xgcc -B$(@D)/gcc/ -dumpspecs > $(PROTO_PREFIX)/$(GCC_LIBDIR)/specs
sed 's/@TARGET@/$(TARGET)/g' $(AMIX_GCC27)/amix-gcc-wrapper.sh > $(PROTO_PREFIX)/bin/$(TARGET)-gcc
chmod 755 $(PROTO_PREFIX)/bin/$(TARGET)-gcc $(PROTO_PREFIX)/bin/$(TARGET)-gcc.real \
	$(PROTO_PREFIX)/$(GCC_LIBDIR)/cc1 $(PROTO_PREFIX)/$(GCC_LIBDIR)/cpp
$(RM) $(PROTO_PREFIX)/$(TARGET)/sysroot
$(SYMLINK) ../../m68k-amix-sysroot $(PROTO_PREFIX)/$(TARGET)/sysroot
$(RM) -r $(@D)/libgcc; $(MKDIR) $(@D)/libgcc
set -e; for name in $(LIBGCC2_FUNCS); do \
	echo "libgcc2: $$name"; \
	GCC_EXEC_PREFIX=$(PROTO_PREFIX)/lib/gcc-lib/ \
	$(PROTO_PREFIX)/bin/$(TARGET)-gcc -O2 \
		-I$(@D)/gcc -I$(SOURCE_DIR) -I$(SOURCE_DIR)/config -I$(SOURCE_DIR)/ginclude \
		-DL$$name -c $(SOURCE_DIR)/libgcc2.c -o $(@D)/libgcc/$$name.o; \
done
cd $(@D)/libgcc && $(PROTO_PREFIX)/bin/$(TARGET)-ar rc libgcc.a $(LIBGCC2_FUNCS:%=%.o) && \
	$(PROTO_PREFIX)/bin/$(TARGET)-ranlib libgcc.a
$(CP) $(@D)/libgcc/libgcc.a $(PROTO_PREFIX)/$(GCC_LIBDIR)/libgcc.a
endef

REQUIRED_PACKAGES += SUNWcs
REQUIRED_PACKAGES += runtime/perl-542
REQUIRED_PACKAGES += shell/bash
REQUIRED_PACKAGES += system/library
