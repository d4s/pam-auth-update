AC_INIT([], [0.1], [denis.pynkin@collabora.com],,[https://www.collabora.com/])

AC_CONFIG_AUX_DIR([build-aux])

AM_INIT_AUTOMAKE([foreign 1.11])

AC_PREREQ([2.60])

AC_CONFIG_HEADERS([config.h:config.in])

AC_SUBST([AM_CFLAGS], [-std=gnu99  -Wall -pedantic])

AC_ARG_ENABLE([debug],
    AS_HELP_STRING([--enable-debug], [Enable debug output]),
    [
    CFLAGS+="-g -O0"
    AC_DEFINE([DEBUG],[1],[Enable debug output])
    ],
    [CFLAGS+=" -O3"],)

AC_PROG_CC
AC_PROG_YACC
AC_PROG_LEX
AC_PROG_RANLIB

AC_DEFINE([COPYRIGHT_YEAR], [m4_esyscmd([date +%Y])], [year in copyright message])

AC_CONFIG_FILES([Makefile src/Makefile src/config/Makefile src/template/Makefile])

AC_OUTPUT
