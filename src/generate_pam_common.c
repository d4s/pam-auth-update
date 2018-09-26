/**
 * @file generate_pam_common.c
 * @author Denis Pynkin (d4s) <denis.pynkin@collabora.com>
 * @brief Read templates and generate appropriate configuration in "/etc/pam.d/common-*"
 */

#include <pam-auth-update.h>
#include <parse_args.h>
#include <template/template_scanner.h>



