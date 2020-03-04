%{
   #include <stdio.h>

   extern int yyerror(char* err);
   extern int yylex(void);
%}

%union {
   
}


%start stmtseq

%left AND, OR, BIIMP, IMP

%token VARIABLE
%token OPENPAR
%token CLOSEPAR
%token TOP
%token BOTTOM

%precedence BIIMP
%precedence IMP
%precedence OR
%precedence AND
%precedence NOT
%precedence ALL, EX
%precedence PREDICATE
%precedence FUNCTION


%%

stmtseq: /* Empty */
    | NEWLINE stmtseq       {}
    | stmt  NEWLINE stmtseq {}
    | error NEWLINE stmtseq {};  /* After an error, start afresh */

stmt: term      {printf("term:> %s",$<val>);}
    | atom      {printf("atom:> %s", $<val>1);   }
    | formula   {printf("formula:> %s", $<val>1);};

term: VAR {}
    | FUNCTION OPENPAR term CLOSEPAR {}
    | FUNCTION OPENPAR term CLOSEPAR {}
    | term KOMMA term {};

atom: PREDICATE {}
    | PREDICATE OPENPAR term CLOSEPAR {};

formula: atom {}
    | NOT formula {}
    | formula AND formula {}
    | formula OR formula {}
    | formula IMP formula {}
    | formula BIIMP formula {}
    | ALL VARIABLE formula {}
    | EX VARIABLE formula {}
    | OPENPAR formula CLOSEPAR {};


%%

int yyerror(char* err)
{
   printf("Error: %s\n", err);
   return 0;
}


int main (int argc, char* argv[])
{
  int i;

  for(i=0; i<MAXREGS; i++)
  {
     regfile[i] = 0.0;
  }
  return yyparse();
}
