%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
//#include "tokendefs.h"
#include "y.tab.h"
//#include "funcdefs.h"
//don't put punct in symbol table, only keywords and ID
//return spaces and tabs to yacc
//scope, lineno, value
//so multiple rows even for the same thing, differentiated by lineno and scope
//update values in semantic analysis

//int linecount = 0;
extern int linenum;
int yylval; //temporary
extern int install_id(char *n);
//int install_num(int n);
//maybe prepopulate symbol table with #defined things, return them in lex but don't install()
%}


letter [A-Za-z]
digit  [0-9]
id {letter}({letter}|{digit})*
number {digit}+(\.{digit}+)?(E|e[+\-]?{digit}+)?

%%


#[A-Za-z0-9 \t\(\"\);]* {;/*comment*/}
\"\"\"[A-Za-z0-9 \t\n\/]*\"\"\" {;/*multiline double quote comment*/}
\'\'\'[A-Za-z0-9 \t\n\/]*\'\'\' {;/*multiline single quote comment*/}
\"[A-Za-z0-9 \.\'\t\n\/\\]*\"     {;/*text in print statements*/}

\n {++linenum; printf("%d\n", linenum);}
[ \t] {;}

"<=" {yylval = RELOP; 
      return(RELOP);
      //changed from LE etc
      } 
"<" {yylval = RELOP; 
     return(RELOP);}
">=" {yylval = RELOP; 
      return(RELOP);}
">" {yylval = RELOP; 
     return(RELOP);}
"!=" {yylval = RELOP; 
      return(RELOP);}
"==" {yylval = RELOP; 
      return(RELOP);}

"("         {yylval = LPAREN; return(LPAREN);}
")"         {yylval = RPAREN; return(RPAREN);}
"["         {yylval = LBRACK; return(LBRACK);}
"]"         {yylval = RBRACK; return(RBRACK);}
"{"         {yylval = LBRACE; return(LBRACE);}
"}"         {yylval = RBRACE; return(RBRACE);}

and {yylval = LOGOP; return(LOGOP); //changed from NOT AND OR
    }
or  {yylval = LOGOP; return(LOGOP);}
not {yylval = LOGOP; return(LOGOP);}

if {return(IF);}
else {return(ELSE);}
while {return(WHILE);}
return {return(RETURN);}

continue {return(CONTINUE);}
break    {return(BREAK);}

print {return(PRINT);}
def {return(DEF);}


"+=" {return(PLUSEQ);}
"-=" {return(MINUSEQ);}
"*=" {return(MULTEQ);}
"/=" {return(DIVEQ);}


"=" {yylval = EQUALS; return(EQUALS);}
";" {yylval = SEMI; return(SEMI);}
":" {yylval = COLON; return(COLON);}
"," {yylval = COMMA; return(COMMA);;}

\+ {yylval = PLUS; return(PLUS);}
-  {yylval = MINUS; return(MINUS);}
\/  {yylval = DIV; return(DIV);}
\* {yylval = MULT; return(MULT);}

{id}       {yylval = install_id(yytext); return(ID);}
{number}   {yylval = atoi(yytext); return(NUM);}

.   {;}

%%

/*
int main()
{
 init_table();
 yyin=fopen("pyeg2.py","r");
 //yyout=fopen("pyeg2.py","w");
 //printf("hi 1\n");
 yylex();
 //printf("h1 2\n");
 print_table();
 return 0;
}
*/
