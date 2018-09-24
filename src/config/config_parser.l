%option prefix="cfg"
%option noyywrap
%option yylineno
%{

#include "config.h"
#include "config_scanner.h"

%}

%x AUTH_GROUP
%x ACCOUNT_GROUP
%x PASSWORD_GROUP
%x SESSION_GROUP
%x SESSION_NI_GROUP

%x STR
%x BOOL
%%

^Name: {
    BEGIN(STR);
	cfglval.str = strdup(cfgtext);
	return(NAME);
}	

<STR>.* {
    /* Any symbols till the EOS */
    cfglval.str = strdup( cfgtext );
    BEGIN(INITIAL);
    return(STRING);
}

^Default: {
    BEGIN(BOOL);
	cfglval.str = strdup(cfgtext);
	return(DEFAULT);
}	

<BOOL>[^[:blank:]]*yes {
    cfglval.str = strdup( cfgtext );
    BEGIN(INITIAL);
    return(YES);
}
<BOOL>[^[:blank:]]*no {
    cfglval.str = strdup( cfgtext );
    BEGIN(INITIAL);
    return(NO);
}


%%


