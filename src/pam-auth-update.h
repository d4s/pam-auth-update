/**
 * @file pam-auth-update.h
 * @author Denis Pynkin (d4s) <denis.pynkin@collabora.com>
 * @brief 
 */

#ifndef PAM_AUTH_UPDATE_H
#define PAM_AUTH_UPDATE_H

#include <stdio.h>
#include <config.h>

#define YYERROR_VERBOSE 1

#ifdef DEBUG
// TODO: change variadic macros
#define DBGPRINT(fmt, args...) \
    { fprintf(stderr, "%s:%d %s(): ", __FILE__, __LINE__, __func__ ); \
    fprintf(stderr, fmt, ##args);}
#else
#define DBGPRINT(fmt, args...) while(0){}
#endif

/* How many elements in block by default */
#define ELEMENTS 256

typedef enum {
    NONE,
    AUTH,
    ACCOUNT,
    PASSWORD,
    SESSION,
    SESSION_NI
} module_t;

typedef struct pam_str {
    int priority;
    char *module;
} pam_str_t;

typedef struct common_conf {
    int primary_num;
    int additional_num;
    pam_str_t *primary;
    pam_str_t *additional;
} common_conf_t;


typedef struct common_configuration {
    common_conf_t auth;
    common_conf_t account;
    common_conf_t password;
    common_conf_t session;
    common_conf_t session_ni;
} common_configuration_t;

extern common_configuration_t *common;

void print_configuration();
#endif /* PAM_AUTH_UPDATE_H */
