SUFFIXES = .c .h .y .l

noinst_LIBRARIES = libtemplate_scanner.a

AM_CFLAGS += -Wno-variadic-macros -I$(top_srcdir)/src
AM_YFLAGS = -d

LEX_OUTPUT_ROOT = lex.tpl

libtemplate_scanner_a_SOURCES = template_parser.l
