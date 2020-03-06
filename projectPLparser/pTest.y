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
%token OPENPAR
%token CLOSEPAR
%token TOP
%token BOTTOM
%token KOMMA
%token NEWLINE

%precedence BIIMP
%precedence IMP
%precedence OR
%precedence AND
%precedence NOT
%precedence ALL
%precedence EX
%precedence PREDICATE
%precedence FUNCTION


%%

stmtseq: /* Empty */
    | NEWLINE stmtseq       {}
    | stmt  NEWLINE stmtseq {}
    | error NEWLINE stmtseq {};  /* After an error, start afresh */

stmt: formula
    | VARIABLE
    | FUNCTION
    | PREDICATE
    | quant
   
    | junction;
    
term: VARIABLE {printf("reducing variable %s to term\n", $<sval>1);}
    | FUNCTION OPENPAR term CLOSEPAR {printf("reducing term %s to term\n", $<sval>3);}
    | term KOMMA term {printf("reducing to %s to term\n", $<sval>1);};

args: OPENPAR term CLOSEPAR;

atom: PREDICATE {printf("reducing to atom %s\n", $<sval>1);}
    | PREDICATE args {printf("reducing to atom %s\n", $<sval>1);};

formula: atom {printf("reduced formula %s\n", $<sval>1);} 
    | quant
    | junction 
    | NOT formula {printf("reducing negation %s\n", $<sval>1);}
    | OPENPAR formula CLOSEPAR {printf("reducing brackets %s%s%s\n",$<sval>1, $<sval>2, $<sval>3);};
    | TOP
    | BOTTOM;

quant: ALL VARIABLE formula {printf("reducing to all formula %s\n", $<sval>1);}
    | EX VARIABLE formula {printf("reducing to existential formula %s\n", $<sval>1);};

junction: formula AND formula {printf("reducing to conjunction %s\n", $<sval>1);}
    | formula OR formula {printf("reducing to disjunction %s\n", $<sval>1);}
    | formula IMP formula {printf("reducing to implication formula %s\n", $<sval>1);}
    | formula BIIMP formula {printf("reducing to biimplication%s\n", $<sval>1);};
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
