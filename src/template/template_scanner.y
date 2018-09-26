%define api.prefix {tpl}

%{
#include <stdio.h>
#include <pam-auth-update.h>

int tpllex();

extern int tpllineno;

int tplerror (const char *s) {
	DBGPRINT("Template error : %s at line %d\n",s, tpllineno);
	return 0;
}

%}

// Symbols.
%union
{
    char	*str;
    int     num;
};

%token <str> TPL_STRING

%destructor { 
	DBGPRINT("Unexpected STRING %s at line %d\n", $$, tpllineno);
	free($$);
	} TPL_STRING

%start TEMPLATE
%%

/** Template for pam-auth-update **/
TEMPLATE:
    | TPL_STRING TEMPLATE
    {
        DBGPRINT("STRING: %s\n", $1);
        free($1);
    }
    ;

%%

