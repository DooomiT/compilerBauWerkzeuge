  /* Find and add all integers and floats... */

%option noyywrap

%{
   #include "pTest.tab.h"
%}

%{
   int    intval   = 0;
   double floatval = 0.0;
%}
 
VARIABLE    [n-z][0-9]*
FUNCTION    [a-m][0-9]*
PREDICATE   [A-Z][0-9]*

%%

{VARIABLE} {
   printf("scanning variable %s\n", yytext);
   yylval.sval = strdup(yytext);
   return VARIABLE;
}

{FUNCTION}   {

   printf("scanning function %s\n", yytext);
   yylval.sval = strdup(yytext);
   return FUNCTION;
}

{PREDICATE} {
   printf("scanning predicate %s\n", yytext);
   yylval.sval = strdup(yytext);
   return PREDICATE;
}

"&" {
   printf("scanning AND\n");
   return AND;
}

"|"  {
   printf("scanning OR\n");
   return OR;
}

"~" {
   printf("scanning NOT\n");
   return NOT;
}

"->" {
   printf("scanning implikation\n");
   return IMP;
}

"<->"  {
   printf("scanning biimplikation\n");
   return BIIMP;
}

"all" {
   printf("scanning allquantor\n");
   return ALL;
}

"ex"  {
   printf("scanning ex\n");
   return EX;
}

"top" {
   printf("scanning top\n");
   return TOP;
}

"bottom" {
   printf("scanning bot\n");
   return BOTTOM;
}

"("  {
   printf("scanning open brackets\n");
   return OPENPAR;
}

")" {
   printf("scanning close brackets\n");
   return CLOSEPAR;
}

"," {
   printf("scanning comma\n");
   return KOMMA;
}

" " {
   /* DO NOTHING */
}

\n|. { 
   return NEWLINE;
      }
%%


