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
   printf("scanned variable %s\n", yytext);
   yylval.sval = yytext;
   return VARIABLE;
}

{FUNCTION}   {

   printf("scanned function %s\n", yytext);
   yylval.sval = yytext;
   return FUNCTION;
}

{PREDICATE} {
   printf("scanned predicate %s\n", yytext);
   yylval.sval = yytext;
   return PREDICATE;
}

"&" {
   printf("scanned AND\n");
   return AND;
}

"|"  {
   printf("scanned OR\n");
   return OR;
}

"~" {
   printf("scanned NOT\n");
   return NOT;
}

"->" {
   printf("scanned implikation\n");
   return IMP;
}

"<->"  {
   printf("scanned biimplikation\n");
   return BIIMP;
}

"all" {
   printf("scanned allquantor\n");
   return ALL;
}

"ex"  {
   printf("scanned ex\n");
   return EX;
}

"top" {
   printf("scanned top\n");
   return TOP;
}

"bottom" {
   printf("scanned bot\n");
   return BOTTOM;
}

"("  {
   printf("scanned open brackets\n");
   return OPENPAR;
}

")" {
   printf("scanned close brackets\n");
   return CLOSEPAR;
}

"," {
   printf("scanned comma\n");
   return KOMMA;
}

" " {
   /* DO NOTHING */
}

\n|. { 
   return NEWLINE;
      }
%%


