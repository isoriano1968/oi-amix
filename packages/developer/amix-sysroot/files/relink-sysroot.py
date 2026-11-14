#!/usr/bin/env python3
"""relink-sysroot.py SYSROOT -- make every absolute symbolic link in an AMIX
sysroot relative to the sysroot.

AMIX's installation made links such as usr/include/X11 -> /usr/X/include.
Inside a sysroot on a build host such a link resolves against the HOST's
root: a cross compile would read the host's own headers, and a copy through
the link would write into the host.  Each one becomes the same path relative
to the sysroot (usr/include/X11 -> ../X/include).  A target that is not in
the sysroot (e.g. /sbin/init, which a sysroot does not hold) still becomes
relative and dangles inside the sysroot, never outside it.

Relative links are checked too: none may climb out of the sysroot.
Exit 1 if any link would leave the sysroot after rewriting.
"""
import os
import sys

root = os.path.abspath(sys.argv[1])
changed = bad = 0
for dirpath, dirnames, filenames in os.walk(root):
    for name in dirnames + filenames:
        p = os.path.join(dirpath, name)
        if not os.path.islink(p):
            continue
        t = os.readlink(p)
        here = os.path.dirname(os.path.relpath(p, root))   # dir of the link, in the sysroot
        if os.path.isabs(t):
            new = os.path.relpath(t.lstrip("/") or ".", here or ".")
            os.unlink(p)
            os.symlink(new, p)
            changed += 1
            t = new
        # where it points, relative to the sysroot
        dest = os.path.normpath(os.path.join(here, t))
        if dest == ".." or dest.startswith("../"):
            print("relink-sysroot: %s -> %s leaves the sysroot" %
                  (os.path.relpath(p, root), t), file=sys.stderr)
            bad += 1
print("relink-sysroot: %d absolute links made relative" % changed)
sys.exit(1 if bad else 0)
