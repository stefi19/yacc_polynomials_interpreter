%{
    #include "y.tab.h"
%}

%%

[0-9]+ {yylval.ival=atoi(yytext); return NUMBER;}
Y {return VAR;}
[-+*^()/n] {return yytext[0];}
[ \t]  ; // ignore whitespace
