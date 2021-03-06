  /* Find and add all integers and floats... */

%option noyywrap


%{
   int    intval   = 0;
   double floatval = 0.0;
%}
 
VAR            [n-z][0-9]*
FUNC           [a-m][0-9]*
PRAEDICATE      [A-Z][0-9]*

%%

{VAR} {
   printf("scanned variable %s\n", yytext);
   /* return VAR; */
}

{FUNC} {
   printf("scanned function %s\n", yytext);
   /* return FUNC; */
}

{PRAEDICATE} {
   printf("scanned praedicate %s\n", yytext);
   /* return PRAEDICATE */
}

"&" {
   printf("scanned AND %s\n", yytext);
   /* return AND; */
}

"|"  {
   printf("scanned OR %s\n", yytext);
   /* return OR; */
}

"~" {
   printf("scanned NOT %s\n", yytext);
   /* return NOT; */
}

"->" {
   printf("scanned implikation %s\n", yytext);
   /* return IMP; */
}

"<->"  {
   printf("scanned biimplikation %s\n", yytext);
   /* return BIIMP; */
}

"all" {
   printf("scanned allquantor %s\n", yytext);
   /* return ALL; */
}

"ex"  {
   printf("scanned existencequantor %s\n", yytext);
   /* return EX; */
}

"top" {
   printf("scanned top %s\n", yytext);
   /* return TOP; */
}

"bottom" {
   printf("scanned bot %s\n", yytext);
   /* return BOT; */
}

"("  {
   printf("scanned OPENPAR %s\n", yytext);
   /* return OPENPAR; */
}

")" {
   printf("scanned CLOSEPAR %s\n", yytext);
   /* return CLOSEPAR; */
}

"," {
   printf("scanned komma %s\n", yytext);
   /* return KOMMA; */
}

" " {
     /* DO NOTHING */
}

\n|. { 
        /* do NOTHING */
      }
%%

int main( int argc, char **argv )       
{
   ++argv, --argc;  /* skip over program name */
   if ( argc > 0 )
      yyin = fopen( argv[0], "r" );
   else
      yyin = stdin;
   
   yylex();
   
   printf("Final  %d : %f\n", intval, floatval);
}
