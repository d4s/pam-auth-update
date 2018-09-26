%option prefix="cfg"
%option noyywrap
%option yylineno
%{

#include "config.h"
#include "config_scanner.h"

#define yyterminate() return(END);
%}

%x STR
%x BOOL
%x TYPE
%x PAM_STRING

%%

^Name: {
    BEGIN(STR);
	cfglval.str = strdup(cfgtext);
	return(CFG_NAME);
}	

<STR>.* {
    /* Any symbols till the EOS */
    cfglval.str = strdup( cfgtext );
    BEGIN(INITIAL);
    return(CFG_STRING);
}

^Default: {
	cfglval.str = strdup(cfgtext);
	return(CFG_DEFAULT);
}	

^Priority: {
	cfglval.str = strdup(cfgtext);
    return(CFG_PRIORITY);
}

<*>^Auth-Type: {
    BEGIN(TYPE);
	cfglval.str = strdup(cfgtext);
    return(CFG_AUTH);
}

<*>^Auth: {
    BEGIN(PAM_STRING);
	cfglval.str = strdup(cfgtext);
    return(CFG_AUTH_MAIN);
}
<*>^Auth-Initial: {
    BEGIN(PAM_STRING);
	cfglval.str = strdup(cfgtext);
    return(CFG_AUTH_INITIAL);
}

<*>^Account-Type: {
    BEGIN(TYPE);
	cfglval.str = strdup(cfgtext);
    return(CFG_ACCOUNT);
}
<*>^Account: {
    BEGIN(PAM_STRING);
	cfglval.str = strdup(cfgtext);
    return(CFG_ACCOUNT_MAIN);
}
<*>^Account-Initial: {
    BEGIN(PAM_STRING);
	cfglval.str = strdup(cfgtext);
    return(CFG_ACCOUNT_INITIAL);
}

<*>^Password-Type: {
    BEGIN(TYPE);
	cfglval.str = strdup(cfgtext);
    return(CFG_PASSWORD);
}
<*>^Password: {
    BEGIN(PAM_STRING);
	cfglval.str = strdup(cfgtext);
    return(CFG_PASSWORD_MAIN);
}
<*>^Password-Initial: {
    BEGIN(PAM_STRING);
	cfglval.str = strdup(cfgtext);
    return(CFG_PASSWORD_INITIAL);
}

<*>^Session-Type: {
    BEGIN(TYPE);
	cfglval.str = strdup(cfgtext);
    return(CFG_SESSION);
}
<*>^Session-Interactive-Only: {
	cfglval.str = strdup(cfgtext);
    return(CFG_SESSION_NI);
}
<*>^Session: {
    BEGIN(PAM_STRING);
	cfglval.str = strdup(cfgtext);
    return(CFG_SESSION_MAIN);
}
<*>^Session-Initial: {
    BEGIN(PAM_STRING);
	cfglval.str = strdup(cfgtext);
    return(CFG_SESSION_INITIAL);
}



<PAM_STRING>^[[:blank:]].* {
	cfglval.str = strdup(cfgtext);
    return(CFG_PAM_STRING);
}

<TYPE>Primary {
    BEGIN(INITIAL);
	cfglval.str = strdup(cfgtext);
    return(CFG_PRIMARY);
}
<TYPE>Additional {
    BEGIN(INITIAL);
	cfglval.str = strdup(cfgtext);
    return(CFG_ADDITIONAL);
}


yes {
    cfglval.num = 1;
    BEGIN(INITIAL);
    return(CFG_YES);
}
no {
    cfglval.num = 0;
    BEGIN(INITIAL);
    return(CFG_NO);
}

<*>[0-9]+ {
        cfglval.num=atoi(cfgtext); 
        return(CFG_NUMBER);
}

<*>\n ;
<*>. ;
%%

