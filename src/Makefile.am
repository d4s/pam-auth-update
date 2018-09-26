bin_PROGRAMS = pam-auth-update

AM_CFLAGS += -Wno-variadic-macros -I$(top_srcdir)/src

pam_auth_update_SOURCES = pam-auth-update.c pam-auth-update.h
pam_auth_update_SOURCES += parse_args.c parse_args.h

pam_auth_update_LDADD = -ly
pam_auth_update_LDADD += config/libconfig_scanner.a
pam_auth_update_LDADD += template/libtemplate_scanner.a

SUBDIRS = config template
