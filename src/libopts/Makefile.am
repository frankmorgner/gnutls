## LIBOPTS Makefile
MAINTAINERCLEANFILES    = Makefile.in

noinst_LTLIBRARIES      = libopts.la

libopts_la_SOURCES      = libopts.c
libopts_la_CPPFLAGS     = -I$(top_srcdir)
libopts_la_LIBADD       = $(LTLIBINTL)

EXTRA_DIST              = \
    ag-char-map.h           alias.c                 ao-strs.c  \
    ao-strs.h               autoopts/options.h      autoopts/project.h  \
    autoopts/usage-txt.h    autoopts.c              autoopts.h  \
    boolean.c               check.c                 compat/strchr.c  \
    compat/snprintf.c       compat/compat.h         compat/windows-config.h  \
    compat/pathfind.c       compat/strdup.c         configfile.c  \
    cook.c                  COPYING.gplv3           COPYING.lgplv3  \
    COPYING.mbsd            enum.c                  env.c  \
    file.c                  find.c                  genshell.c  \
    genshell.h              gettext.h               init.c  \
    load.c                  m4/libopts.m4           m4/liboptschk.m4  \
    MakeDefs.inc            makeshell.c             nested.c  \
    numeric.c               option-value-type.c     option-value-type.h  \
    option-xat-attribute.c  option-xat-attribute.h  parse-duration.c  \
    parse-duration.h        pgusage.c               proto.h  \
    putshell.c              README                  reset.c  \
    restore.c               save.c                  sort.c  \
    stack.c                 streqvcmp.c             text_mmap.c  \
    time.c                  tokenize.c              usage.c  \
    version.c
