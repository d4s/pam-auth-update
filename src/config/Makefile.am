SUFFIXES = .c .h .y .l

noinst_LIBRARIES = libconfig_scanner.a

AM_CFLAGS += -Wno-variadic-macros -I$(top_srcdir)/src
AM_YFLAGS = -d

LEX_OUTPUT_ROOT = lex.cfg

libconfig_scanner_a_SOURCES = config_scanner.y
libconfig_scanner_a_SOURCES += config_parser.l
