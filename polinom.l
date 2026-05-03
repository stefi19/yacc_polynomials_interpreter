%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "y.tab.h"
%}

%%

"value"     { return VALUE; }
[0-9]+      { yylval.ival = atoi(yytext); return NUMBER; }
"Y"         { return VAR; }

"\n"        { return '\n'; }
"["         { return '['; }
"]"         { return ']'; }
","         { return ','; }
"'"         { return '\''; }

[-+*^()]    { return yytext[0]; }

[ \t\r]+    { /* ignore whitespace */ }

.           { printf("Unknown character: %s\n", yytext); }
