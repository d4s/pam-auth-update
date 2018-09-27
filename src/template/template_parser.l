%option prefix="tpl"
%option noyywrap
%option yylineno
%{

#include <pam-auth-update.h>

%}

%%

^$auth_primary {
    for(int i=0; i < common->auth.primary_num; i++){
        fprintf(tplout, "auth%s\n", common->auth.primary[i].module);
    }
}
^$auth_additional {
    for(int i=0; i < common->auth.additional_num; i++){
        fprintf(tplout, "auth%s\n", common->auth.additional[i].module);
    }
}

^$account_primary {
    for(int i=0; i < common->account.primary_num; i++){
        fprintf(tplout, "account%s\n", common->account.primary[i].module);
    }
}
^$account_additional {
    for(int i=0; i < common->account.additional_num; i++){
        fprintf(tplout, "account%s\n", common->account.additional[i].module);
    }
}

^$password_primary {
    for(int i=0; i < common->password.primary_num; i++){
        fprintf(tplout, "password%s\n", common->password.primary[i].module);
    }
}
^$password_additional {
    for(int i=0; i < common->password.additional_num; i++){
        fprintf(tplout, "password%s\n", common->password.additional[i].module);
    }
}

^$session_primary {
    for(int i=0; i < common->session.primary_num; i++){
        fprintf(tplout, "session%s\n", common->session.primary[i].module);
    }
}
^$session_additional {
    for(int i=0; i < common->session.additional_num; i++){
        fprintf(tplout, "session%s\n", common->session.additional[i].module);
    }
}

^$session_nonint_primary {
    for(int i=0; i < common->session_ni.primary_num; i++){
        fprintf(tplout, "session%s\n", common->session_ni.primary[i].module);
    }
}
^$session_nonint_additional {
    for(int i=0; i < common->session_ni.additional_num; i++){
        fprintf(tplout, "session%s\n", common->session_ni.additional[i].module);
    }
}

^.* {
    /* Any symbols till the EOS */
    fprintf(tplout, "%s\n", tpltext);
}

\n ;

%%
