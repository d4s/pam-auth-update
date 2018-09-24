bin_PROGRAMS = pam-auth-update

AM_CFLAGS = \
	-std=gnu99 -Wno-variadic-macros -Wall -pedantic

AM_LDFLAGS = \
	-Wl,--as-needed

pam_auth_update_SOURCES = pam-auth-update.c

pam_auth_update_LDADD = -ly
pam_auth_update_LDADD += config/libconfig_scanner.a

SUBDIRS = config
