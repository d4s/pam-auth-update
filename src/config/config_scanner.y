%define api.prefix {cfg}

%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <pam-auth-update.h>

typedef enum {
    PRIMARY,
    ADDITIONAL
} block_t;

int cfglex();

extern int cfglineno;

int cfgerror (const char *s) {
	DBGPRINT("Config error : %s at line %d\n",s, cfglineno);
	return 0;
}

int priority;
int default_conf;
common_conf_t conf;

block_t block;
int *block_num;
pam_str_t *block_modules;

module_t module;
%}

// Symbols.
%union
{
    char	*str;
    int     num;
};

%token <str> CFG_STRING
%token <num> CFG_NUMBER
%token <num> CFG_YES
%token <num> CFG_NO

%token <str> CFG_PAM_STRING

%token <str> CFG_NAME
%token <str> CFG_DEFAULT
%token <str> CFG_PRIORITY

%token <str> CFG_PRIMARY
%token <str> CFG_ADDITIONAL

%token <str> CFG_AUTH
%token <str> CFG_AUTH_MAIN
%token <str> CFG_AUTH_INITIAL

%token <str> CFG_ACCOUNT
%token <str> CFG_ACCOUNT_MAIN
%token <str> CFG_ACCOUNT_INITIAL

%token <str> CFG_PASSWORD
%token <str> CFG_PASSWORD_MAIN
%token <str> CFG_PASSWORD_INITIAL

%token <str> CFG_SESSION
%token <str> CFG_SESSION_MAIN
%token <str> CFG_SESSION_INITIAL
%token <str> CFG_SESSION_NI

%token END 0 "End of file"

%destructor { 
	DBGPRINT("Unexpected NAME %s at line %d\n", $$, cfglineno);
	free( $$);
	} CFG_NAME
%destructor {
	DBGPRINT("Unexpected DEFAULT %s at line %d\n", $$, cfglineno);
	free( $$);
	} CFG_DEFAULT
%destructor {
	DBGPRINT("Unexpected PRIORITY %s at line %d\n", $$, cfglineno);
	free( $$);
	} CFG_PRIORITY

%start CONFIG
%%

/** Configuration for pam-auth-update **/
CONFIG:
    CFG_HNAME CFG_HDEFAULT CFG_HPRIORITY CFG_MODULES EOF
    ;

CFG_HNAME:
    CFG_NAME CFG_STRING
    {
        DBGPRINT("NAME -- %s\n", $2);
        free($1);
        free($2);

        /* Set defaults */
        priority = 0;
        default_conf = 1;
        block = PRIMARY;
        /* New structure */
        memset(&conf, 0, sizeof(common_conf_t));
        conf.primary = calloc(ELEMENTS, sizeof(pam_str_t));
        conf.additional = calloc(ELEMENTS, sizeof(pam_str_t));
        if (conf.primary == NULL || conf.additional == NULL){
            DBGPRINT("Memory allocation error");
            exit(1);
        }
        module = NONE;
    }
    ;

CFG_HDEFAULT:
    | CFG_DEFAULT CFG_YES
    {
        DBGPRINT("DEFAULT -- '%d' (YES)\n", $2);
        free($1);
        default_conf = 1;
    }
    | CFG_DEFAULT CFG_NO
    {
        DBGPRINT("DEFAULT -- '%d' (NO)\n", $2);
        free($1);
        default_conf = 0;
    }
    ;

CFG_HPRIORITY:
    | CFG_PRIORITY CFG_NUMBER
    {
        DBGPRINT("Priority -- '%d'\n", $2);
        free($1);

        priority = $2;
    }
    ;

CFG_MODULES:
    | CFG_AUTH_MODULE COPY_COLLECTED CFG_MODULES
    | CFG_ACCOUNT_MODULE CFG_MODULES
    | CFG_PASSWORD_MODULE CFG_MODULES
    | CFG_SESSION_MODULE CFG_MODULES
    ;


CFG_AUTH_MODULE:
    CFG_AUTH_TYPE CFG_AUTH_DATA
    {
        DBGPRINT("Section: AUTH\n");
    }
    ;

CFG_AUTH_TYPE:
    | CFG_AUTH CFG_PRIMARY
    {
        DBGPRINT("AUTH TYPE PRIMARY -- %s\n", $2);
        free($1);
        free($2);

        block = PRIMARY;
        block_num = &conf.primary_num;
        block_modules = conf.primary;
        module = AUTH;
    }
    | CFG_AUTH CFG_ADDITIONAL
    {
        DBGPRINT("AUTH TYPE ADDITIONAL -- %s\n", $2);
        free($1);
        free($2);

        block = ADDITIONAL;
        block_num = &conf.additional_num;
        block_modules = conf.additional;
        module = AUTH;
    }
    ;

CFG_AUTH_DATA:
    | CFG_AUTH_DATA CFG_AUTH_MAIN
    {
        DBGPRINT("AUTH MAIN\n");
        *block_num = 0;
    }
    | CFG_AUTH_DATA CFG_AUTH_INITIAL
    {
        DBGPRINT("AUTH INITIAL\n");
        /* FIXME: for Apertis is used initial version if found */
        *block_num = 0;
    }
    | CFG_AUTH_DATA CFG_PAM_STRINGS
    ;


CFG_ACCOUNT_MODULE:
    CFG_ACCOUNT_TYPE CFG_ACCOUNT_DATA
    {
        DBGPRINT("Section: ACCOUNT\n");
    }
    ;

CFG_ACCOUNT_TYPE:
    CFG_ACCOUNT CFG_PRIMARY
    {
        DBGPRINT("ACCOUNT TYPE PRIMARY -- %s\n", $2);
        free($1);
        free($2);
    }
    | CFG_ACCOUNT CFG_ADDITIONAL
    {
        DBGPRINT("ACCOUNT TYPE ADDITIONAL -- %s\n", $2);
        free($1);
        free($2);
    }
    ;
CFG_ACCOUNT_DATA:
    | CFG_ACCOUNT_MAIN CFG_PAM_STRINGS CFG_ACCOUNT_DATA
    {
        DBGPRINT("ACCOUNT MAIN\n");
    }
    | CFG_ACCOUNT_INITIAL CFG_PAM_STRINGS CFG_ACCOUNT_DATA
    {
        DBGPRINT("ACCOUNT INITIAL\n");
    }
    ;


CFG_PASSWORD_MODULE:
    CFG_PASSWORD_TYPE CFG_PASSWORD_DATA
    {
        DBGPRINT("Section: PASSWORD\n");
    }
    ;

CFG_PASSWORD_TYPE:
    CFG_PASSWORD CFG_PRIMARY
    {
        DBGPRINT("PASSWORD TYPE PRIMARY -- %s\n", $2);
        free($1);
        free($2);
    }
    | CFG_PASSWORD CFG_ADDITIONAL
    {
        DBGPRINT("PASSWORD TYPE ADDITIONAL -- %s\n", $2);
        free($1);
        free($2);
    }
    ;
CFG_PASSWORD_DATA:
    | CFG_PASSWORD_MAIN CFG_PAM_STRINGS CFG_PASSWORD_DATA
    {
        DBGPRINT("PASSWORD MAIN\n");
    }
    | CFG_PASSWORD_INITIAL CFG_PAM_STRINGS CFG_PASSWORD_DATA
    {
        DBGPRINT("PASSWORD INITIAL\n");
    }
    ;


CFG_SESSION_MODULE:
    CFG_SESSION_TYPE CFG_SESSION_DATA
    {
        DBGPRINT("Section: SESSION\n");
    }
    ;

CFG_SESSION_TYPE:
    CFG_SESSION CFG_PRIMARY
    {
        DBGPRINT("SESSION TYPE PRIMARY -- %s\n", $2);
        free($1);
        free($2);
    }
    | CFG_SESSION CFG_ADDITIONAL
    {
        DBGPRINT("SESSION TYPE ADDITIONAL -- %s\n", $2);
        free($1);
        free($2);
    }
    | CFG_SESSION_NI CFG_YES
    {
        DBGPRINT("SESSION NON-INTERACTIVE -- '%d' (YES)\n", $2);
        free($1);
    }
    | CFG_SESSION_NI CFG_NO
    {
        DBGPRINT("SESSION NON-INTERACTIVE -- '%d' (NO)\n", $2);
        free($1);
    }
    ;
CFG_SESSION_DATA:
    | CFG_SESSION_MAIN CFG_PAM_STRINGS CFG_SESSION_DATA
    {
        DBGPRINT("SESSION MAIN\n");
    }
    | CFG_SESSION_INITIAL CFG_PAM_STRINGS CFG_SESSION_DATA
    {
        DBGPRINT("SESSION INITIAL\n");
    }
    ;

CFG_PAM_STRINGS:
    | CFG_PAM_STRING CFG_PAM_STRINGS
    {
        DBGPRINT("PAM MODULE -- %s\n", $1);
        /* Do not add this module if not set as default */

        if(default_conf != 0) {
            block_modules[*block_num].priority = priority;
            block_modules[*block_num].module = strdup($1);
            (*block_num)++;
        }
        DBGPRINT("STRINGS: block_num = %d\n", *block_num);
        free($1);
    }
    ;

COPY_COLLECTED:
    {
        DBGPRINT("Copy collected data to common:\n");
        common_conf_t *target;

        switch(module) {
            case AUTH:
                DBGPRINT("Copy from %s\n", "AUTH");
                target = &common->auth;
                break;
            default:
                DBGPRINT("Copy from %d\n", (int)module);
        }

        for(int i=0; i<(*block_num);i++){
            int num = target->primary_num;
            target->primary[num].priority = priority;
            target->primary[num].module = strdup(block_modules[i].module);
            (target->primary_num)++;
        }
     }
    ;

EOF:
    END
    {
        DBGPRINT("TXE END\n");
    }
    ;

%%

