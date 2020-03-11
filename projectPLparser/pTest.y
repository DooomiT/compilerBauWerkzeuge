%{
    #include <stdio.h>
    #include <string.h>
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

%precedence NOT
%precedence ALL EX
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
stmt: formula  

/* declaring term: x or f or f(termArgs) */
term: VARIABLE {
        $<sval>$ = $<sval>1;
        printf("reducing VARIABLE %s to term\n", $<sval>$);
      }
    | FUNCTION {
        $<sval>$ = $<sval>1;
        printf("reducing FUNCTION %s to term\n", $<sval>$);
      }
    | FUNCTION OPENPAR termArgs CLOSEPAR {
        char * x = malloc((strlen($<sval>1) + 20 + strlen($<sval>3))* sizeof(char));
        strcat(x, $<sval>1); 
        strcat(x, " ( "); 
        strcat(x, $<sval>3);
        strcat(x, " ) ");
        strcat(x,  $<sval>3);
        $<sval>$ = strdup(x);
        free(x);
        printf("reducing FUNCTION %s to term\n", $<sval>$);
      };
    
/* declaring termArgs: (x) or (f) or (f(x,...),...) */
termArgs: term {
        $<sval>$ = $<sval>1;
        printf("reducing term %s to termArgs\n", $<sval>$);
      }
    | term KOMMA termArgs {
        char * x = malloc((strlen($<sval>1) + 20 + strlen($<sval>3))* sizeof(char));
        strcat(x, $<sval>1);
        strcat(x, " , "); 
        strcat(x,  $<sval>3);
        $<sval>$ = strdup(x);
        free(x);
        printf("reducing term %s to termArgs\n", $<sval>$);
      };

/* declaring atom: P or P(predArgs) */
atom: PREDICATE {
        $<sval>$ = $<sval>1;
        printf("reducing PREDICATE %s to atom\n", $<sval>$);
      }
    | PREDICATE OPENPAR predArgs CLOSEPAR {
        char * x = malloc((strlen($<sval>1) + 20 + strlen($<sval>3))* sizeof(char));
        strcat(x, $<sval>1); 
        strcat(x, " ("); 
        strcat(x, $<sval>3);
        strcat(x, ") ");
        $<sval>$ = strdup(x);
        free(x);
        printf("reducing PREDICATE %s to atom\n", $<sval>$);
      };

/* declaring predArgs: term */
predArgs: term {
        $<sval>$ = $<sval>1;
        printf("reducing term %s to predArgs\n", $<sval>$);
      }
    | term KOMMA predArgs {
        char * x = malloc((strlen($<sval>1) + 20 + strlen($<sval>3))* sizeof(char));
        strcat(x, $<sval>1);
        strcat(x, " , "); 
        strcat(x,  $<sval>3);
        $<sval>$ = strdup(x);
        free(x);
        printf("reducing term %s to predArgs\n", $<sval>$);
      };

/* declaring formula: */
formula: atom {printf("reducing atom %s to formula\n", $<sval>1);}    
    | TOP
    | BOTTOM; 
    | ALL VARIABLE formula {
        char * x = malloc((strlen($<sval>2) + strlen($<sval>3) + 20)* sizeof(char));
        strcat(x, " ALL ");
        strcat(x, $<sval>2); 
        strcat(x, $<sval>3);
        $<sval>$ = strdup(x);
        free(x);
        printf("reducing %s to formula\n", $<sval>$);
      }
    | EX VARIABLE formula {
        char * x = malloc((strlen($<sval>2) + strlen($<sval>3) + 20)* sizeof(char));
        strcat(x, " EX ");
        strcat(x, $<sval>2); 
        strcat(x, $<sval>3);
        $<sval>$ = strdup(x);
        free(x);
        printf("reducing ex formula %s\n", $<sval>$);
      }
    | formula AND formula {
        char * x = malloc((strlen($<sval>1) + 20 + strlen($<sval>3))* sizeof(char));
        strcat(x, $<sval>1);
        strcat(x, " AND "); 
        strcat(x,  $<sval>3);
        $<sval>$ = strdup(x);
        free(x);
        printf("reducing all formula %s\n", $<sval>$);
      }
    | formula OR formula {
        char * x = malloc((strlen($<sval>1) + 20 + strlen($<sval>3))* sizeof(char));
        strcat(x, $<sval>1);
        strcat(x, " OR "); 
        strcat(x,  $<sval>3);
        $<sval>$ = strdup(x);
        free(x);
        printf("reducing %s to formula\n", $<sval>$);
      }
    | formula IMP formula {
        char * x = malloc((strlen($<sval>1) + 20 + strlen($<sval>3))* sizeof(char));
        strcat(x, $<sval>1);
        strcat(x, " IMP "); 
        strcat(x,  $<sval>3);
        $<sval>$ = strdup(x);
        free(x);
        printf("reducing %s to formula\n", $<sval>$);
      }
    | formula BIIMP formula {
        char * x = malloc((strlen($<sval>1) + 20 + strlen($<sval>3))* sizeof(char));
        strcat(x, $<sval>1);
        strcat(x, " BIIMP "); 
        strcat(x,  $<sval>3);
        $<sval>$ = strdup(x);
        free(x);
        printf("reducing %s to formula\n", $<sval>$);
      }
    | NOT formula {
        char * x = malloc((strlen($<sval>2) + 20)* sizeof(char));
        strcat(x, " NOT ");
        strcat(x, $<sval>2);
        $<sval>$ = strdup(x);
        free(x); 
        printf("reducing %s to formula\n", $<sval>$);
      }
    | OPENPAR formula CLOSEPAR {
        char * x = malloc((strlen($<sval>2) + 20)* sizeof(char));
        strcat(x, " (");
        strcat(x, $<sval>2); 
        strcat(x, ") ");
        $<sval>$ = strdup(x);
        free(x);
        printf("reducing %s to formula\n", $<sval>$);
      }
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
