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

%token <str> STRING
%token <num> NUMBER
%token <str> YES
%token <str> NO

%token <str> NAME
%token <str> DEFAULT
%token <str> PRIORITY


%destructor { 
	DBGPRINT("Unexpected NAME %s at line %d\n", $$, cfglineno);
	free( $$);
	} NAME
%destructor { 
	DBGPRINT("Unexpected STRING %s at line %d\n", $$, cfglineno);
	free( $$);
	} STRING

%start CONFIG
%%

/** Configuration for pam-auth-update **/
CONFIG:
    HNAME HDEFAULT HPRIORITY GROUPS
    ;

HNAME:
    NAME STRING
    {
        DBGPRINT("NAME -- %s\n", $2);
    }
    ;

HDEFAULT:
    | DEFAULT YES
    {
        DBGPRINT("DEFAULT -- '%s' (YES)\n", $2);
    }
    | DEFAULT NO
    {
        DBGPRINT("DEFAULT -- '%s' (NO)\n", $2);
    }
    ;

HPRIORITY:
    | PRIORITY NUMBER
    ;

GROUPS:
    | AUTH
    | ACCOUNT
    | PASSWORD
    | SESSION
    | SESSION_NI
    ;


AUTH:
    {
        DBGPRINT("Section: AUTH\n");
    }
    ;

ACCOUNT:
    {
        DBGPRINT("Section: ACCOUNT\n");
    }
    ;

PASSWORD:
    {
        DBGPRINT("Section: PASSWORD\n");
    }
    ;

SESSION:
    {
        DBGPRINT("Section: SESSION\n");
    }
    ;

SESSION_NI:
    {
        DBGPRINT("Section: SESSION Non-Interactive\n");
    }
    ;

%%

