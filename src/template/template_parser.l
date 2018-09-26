%option prefix="tpl"
%option noyywrap
%option yylineno
%{

#include "config.h"
#include "template_scanner.h"

%}

%%

^.* {
    /* Any symbols till the EOS */
    tpllval.str = strdup( tpltext );
    return(TPL_STRING);
}

%%
