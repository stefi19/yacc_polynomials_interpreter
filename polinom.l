%{
    #include "y.tab.h"
    #include <stdlib.h>
    #include <stdio.h>
%}

%%

[0-9]+          { yylval.ival = atoi(yytext); return NUMBER; }

X               { return VARX; }
Y               { return VARY; }

value           { return VALUE; }

[-+*^()\[\],\n] { return yytext[0]; }
\'              { return yytext[0]; }

[ \t]           ; /* ignore whitespace */

.               { printf("Unknown character: %s\n", yytext); }
