%{
    #include <stdio.h>
    // Declare stuff from Flex that Bison needs to know about:
    extern int yyparse();
    extern int yyerror(char* err);
    extern int yylex(void);
%}

%union {
  int val;
  float fval;
  char *sval;
}

%start stmtseq

%token VARIABLE
%precedence OPENPAR
%token CLOSEPAR
%token TOP
%token BOTTOM
%token KOMMA
%token NEWLINE

%precedence NOT
%precedence ALL
%precedence EX
%precedence PREDICATE
%precedence FUNCTION
%left BIIMP
%left IMP
%left OR
%left AND



%%

stmtseq: /* Empty */
    | NEWLINE stmtseq       {}
    | stmt  NEWLINE stmtseq {}
    | error NEWLINE stmtseq {};  /* After an error, start afresh */

/* Declaring Passable stmts */
stmt: term
    | atom
    | formula  

/* declaring term: x or f or f(termArgs) */
term: VARIABLE {printf("reducing variable %s to term\n", $<sval>1);}
    | FUNCTION {printf("reducing function %s to term\n", $<sval>1);}
    | FUNCTION OPENPAR termArgs CLOSEPAR {printf("reducing function %s to term\n", $<sval>1);};
    
/* declaring termArgs: (x) or (f) or (f(x,...),...) */
termArgs: term
    | term KOMMA termArgs {printf("reducing %s to term\n", $<sval>1);};

/* declaring atom: P or P(predArgs) */
atom: PREDICATE {printf("reducing predicate to atom %s\n", $<sval>1);}
    | PREDICATE OPENPAR predArgs CLOSEPAR {printf("reducing %s to atom\n", $<sval>1);};
/* declaring predArgs: term */
predArgs: term
    | term KOMMA predArgs;

/* declaring formula: */
formula: atom {printf("reducing atom %s to formula\n", $<sval>1);}     
    | formula junction formula {printf("reducing %s to formula\n", $<sval>1);}
    | NOT formula {printf("reducing negation %s\n", $<sval>1);}
    | OPENPAR formula CLOSEPAR {printf("reducing %s to formula\n", $<sval>1);}
    | quant VARIABLE formula {printf("reducing to %s formula\n", $<sval>1);}
    | TOP
    | BOTTOM;

/* declaring quantors: ex, all */
quant: ALL 
    | EX;

/* declaring junctions: and, or, imp, biimp */
junction: AND 
    | OR 
    | IMP 
    | BIIMP;
%%

int yyerror(char* err)
{
   printf("Error: %s\n", err);
   return 0;
}


int main (int argc, char* argv[])
{
  return yyparse();
}
