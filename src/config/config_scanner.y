%define api.prefix {cfg}

%{
#include <stdio.h>

#define YYERROR_VERBOSE 1

#define DEBUG 1

#ifdef DEBUG
// TODO: change variadic macros
#define DBGPRINT(fmt, args...) \
    { fprintf(stderr, "%s:%d %s(): ", __FILE__, __LINE__, __func__ ); \
    fprintf(stderr, fmt, ##args);}
#else
#define DBGPRINT(fmt, args...) while(0){}
#endif

int cfg_debug=1;
extern int cfglineno;

int cfgerror (const char *s) {
	DBGPRINT("Config error : %s at line %d\n",s, cfglineno);
	return 0;
}

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
    CFG_HNAME CFG_HDEFAULT CFG_HPRIORITY CFG_MODULES
    ;

CFG_HNAME:
    CFG_NAME CFG_STRING
    {
        DBGPRINT("NAME -- %s\n", $2);
        free($1);
        free($2);
    }
    ;

CFG_HDEFAULT:
    | CFG_DEFAULT CFG_YES
    {
        DBGPRINT("DEFAULT -- '%d' (YES)\n", $2);
        free($1);
    }
    | CFG_DEFAULT CFG_NO
    {
        DBGPRINT("DEFAULT -- '%d' (NO)\n", $2);
        free($1);
    }
    ;

CFG_HPRIORITY:
    | CFG_PRIORITY CFG_NUMBER
    {
        DBGPRINT("Priority -- '%d'\n", $2);
        free($1);
    }
    ;

CFG_MODULES:
    | CFG_AUTH_MODULE CFG_MODULES
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
    CFG_AUTH CFG_PRIMARY
    {
        DBGPRINT("AUTH TYPE PRIMARY -- %s\n", $2);
        free($1);
        free($2);
    }
    | CFG_AUTH CFG_ADDITIONAL
    {
        DBGPRINT("AUTH TYPE ADDITIONAL -- %s\n", $2);
        free($1);
        free($2);
    }
    ;
CFG_AUTH_DATA:
    | CFG_AUTH_MAIN CFG_PAM_STRINGS CFG_AUTH_DATA
    {
        DBGPRINT("AUTH MAIN\n");
    }
    | CFG_AUTH_INITIAL CFG_PAM_STRINGS CFG_AUTH_DATA
    {
        DBGPRINT("AUTH INITIAL\n");
    }
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
    | CFG_SESSION CFG_PRIMARY
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
        free($1);
    }
    ;
%%

