%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//shorthand like += is not working
//maybe remove compound_stmt from Stmt grammar
//#include "tokendefs.h"
//#include "funcdefs.h"
/*
logOp : || | && ;
relOp : < | > | <= | >= | != | == ;
Decl Stmt?
*/
extern FILE* yyin;

struct symbol_table
{
 char name[80];
 int token; //defined in tokendefs.h
 int attribute;
 int value;
 int lineno;
 char scope[80];
}st[100];


int table_row = 0;
int linenum = 1;

%}

%start Program
%token ID NUM LOGOP RELOP LPAREN RPAREN LBRACE RBRACE RBRACK LBRACK SEMI COMMA PLUS MINUS MULT DIV COLON
%token PLUSEQ MINUSEQ MULTEQ DIVEQ EQUALS CONTINUE BREAK RETURN IF ELSE WHILE PRINT DEF

%%

Program : compound_stmt      {return 0;}
        ;

compound_stmt : Decls Stmts     {printf("Compound statement found 1\n");}
              | Stmts       {printf("Compound statement found 2\n");}
              ;
Stmts :  
      | Stmts Stmt {printf("Mult stmts\n");}
      ;
Decls :  
      | Decls Decl {printf("Mult decls\n");}
      ;            
      
Stmt :  
     | AssignExpr | compound_stmt | selection_stmt | iteration_stmt | jump_stmt 
     ;
     
selection_stmt : IF LPAREN cond RPAREN COLON compound_stmt    {printf("If found\n");}
               | IF LPAREN cond RPAREN COLON compound_stmt ELSE COLON compound_stmt 
               | IF cond COLON compound_stmt    {printf("If found\n");}
               | IF cond COLON compound_stmt ELSE COLON compound_stmt
               ;
               
iteration_stmt : WHILE LPAREN cond RPAREN COLON compound_stmt {printf("While found\n");}
               | WHILE cond COLON compound_stmt {printf("While found\n");}
               ;
jump_stmt : CONTINUE  | BREAK  | RETURN E ;
cond : expr            {printf("cond found 1\n");}
     | expr LOGOP expr {printf("cond found 2\n");}
     ;   
expr : relexp | logexp | E ;
relexp : E RELOP E ;
logexp : E LOGOP E ;
Decl : AssignExpr SEMI
     | AssignExpr 
     ;
     
AssignExpr : ID EQUALS E COMMA AssignExpr | ID EQUALS E; 
E : E PLUS T | E MINUS T | T ;
T : T MULT F | T DIV F | F ;
F : ID | NUM | LPAREN E RPAREN | Unary_operation ;
Unary_operation : ID u_op ID SEMI | ID u_op NUM SEMI | ID u_op LPAREN E RPAREN SEMI | ID u_op ID 
                | ID u_op NUM {printf("Found a+=1 type\n");}
                | ID u_op LPAREN E RPAREN 
                ;
u_op : PLUSEQ {printf("+= found\n");}
     | MINUSEQ 
     | MULTEQ 
     | DIVEQ 
     ;


%%


int already(char*n, char*s) //checks if it is already in the table
{
 for(int i = 0; i < table_row; ++i)
 {
  //printf("In already fn1\n");
  if (strcmp(st[i].name, n) == 0 && strcmp(st[i].scope, s) == 0)
  {
   //printf("In already fn2\n");
   return 1;
  }
 } 
return 0;
}
void insert(char *n, int t, int a, int val, int line, char *scop)
{
 printf("In insert\n");
 if(already(n, scop) == 0)
 {
  //printf("In already if\n");
  strcpy(st[table_row].name, n);
  //printf("In already if 3\n");
  st[table_row].token = t;
  //printf("In already if 4\n");
  st[table_row].attribute = a;
  //printf("In already if 5\n");
  st[table_row].value = val;
  //printf("In already if 6\n");
  st[table_row].lineno = line;
  //printf("In already if 7\n");
  strcpy(st[table_row].scope, scop);
  //printf("In already if 2\n");
  ++table_row;
 }
}

int init_table() 
{
 printf("Init\n");
 insert("if", IF, 0, 0, 0, "");
 printf("Init 1.5\n");
 insert("while", WHILE, 0, 0, 0, "");
 insert("else", ELSE, 0, 0, 0, "");
 insert("return", RETURN, 0, 0, 0, "");
 insert("print", PRINT, 0, 0, 0, "");
 insert("def", DEF, 0, 0, 0, "");
 printf("Init 2\n");
}

int install_id(char *n) //can return row number in symbol table
{
 //printf("in install_id\n");
 insert(n, ID, table_row, 0, linenum, "");
 return(table_row-1);
}
/*
int install_num(int n) //can return row number in symbol table
{
 insert(n, NUMBER, table_row);
 return(table_row-1);
}
*/
void print_table()
{
 printf("Name\tToken\tAttr\tValue\tLine\tScope\n");
 for(int i = 0; i < table_row; ++i)
 {
  //printf("About to print\n");
  printf("%s\t%d\t%d\t%d\t%d\t%s\n", st[i].name, st[i].token, st[i].attribute, st[i].value, st[i].lineno, st[i].scope);
 } 
}

int main()
{
 printf("Hi");
 fflush(stdout);
 yyin = fopen("pyeg2.py", "r");
 init_table();
 yyparse();
 print_table();
 printf("Bye");
 fflush(stdout);
 printf("Valid program");
 fflush(stdout);
 return 0;
}

void yyerror()
{
 printf("Invalid string.");
 exit(0);
}
