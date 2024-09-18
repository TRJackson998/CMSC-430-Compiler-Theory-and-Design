/* CMSC 430 Compiler Theory and Design
   Project 3 Skeleton
   UMGC CITE
   Summer 2023 */

/* This file contains flex input file */

/*
Terrence Jackson
UMGC CMSC 430
9.18.24
Project 3

Updates from Project 2
Implement floats and hexadecimals
escape characters, arithmetic operators
*/

%{
#include <cstdio>
#include <string>
#include <vector>

using namespace std;

#include "values.h"
#include "listing.h"
#include "tokens.h"

int atoh(char hex[]) {
   // convert a string into hexadecimal
   int result = 0;
   int base = 1; // 16^0

   for (int i = strlen(hex) -1; i > 0; i--) {
      // lowercase -> uppercase
      if (hex[i] > 90) {
         hex[i] -= 32;
      }

      // hex to decimal
      if (hex[i] >= 65 && hex[i] <= 70) {
         //A-f
         hex[i] -= 55;
      } else {
         hex[i] -= 48;
      }

      // store the result and update the base (16^0, 16^1, etc)
      result += hex[i] * base;
      base *= 16;
   }
   return result;
}

int atoe(char escape[]) {
   // list of currently accepted escape characters
   constexpr char options[5] = {'b', 't', 'n', 'f', 'r'};

   // swicth on input, provide output from options list
   switch(escape[2]) { 
      case options[0]:
         return '\b';
      case options[1]:
         return '\t';
      case options[2]:
         return '\n';
      case options[3]:
         return '\f';
      case options[4]:
         return '\r';
      default:
         return -1; // if all else fails, return -1
   }   
}

%}

%option noyywrap

ws		[ \t\r]+
comment		("//"|"--").*\n
line		[\n]
id		[A-Za-z]([A-Za-z0-9]|_[A-Za-z0-9]|__[A-Za-z0-9])*
digit		[0-9]
dec		{digit}+
float	{digit}*"."{dec}([Ee]([-+]*){dec})*
hex		#({digit}|[A-Fa-f])+
char		'.'
escape		'\\[btnfr]'
punc		[\(\),:;]
%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine(); }
{line}		{ ECHO; nextLine(); }
"+"		{ ECHO; yylval.oper = ADD; return(ADDOP); }
"-"		{ ECHO; yylval.oper = SUBTRACT; return(ADDOP); }
"~"		{ ECHO; yylval.oper = NEG; return(NEGOP); }
"*"		{ ECHO; yylval.oper = MULTIPLY; return(MULOP); }
"/"		{ ECHO; yylval.oper = DIVIDE; return(MULOP); }
"%"		{ ECHO; yylval.oper = MOD; return(MODOP); }
"^"		{ ECHO; yylval.oper = EXP; return(EXPOP); }
"&"		{ ECHO; yylval.oper = AND; return(ANDOP); }
"<"		{ ECHO; yylval.oper = LESS; return(RELOP); }
">"		{ ECHO; yylval.oper = MORE; return(RELOP); }
"<="	{ ECHO; yylval.oper = LESSEQ; return(RELOP); }
">="	{ ECHO; yylval.oper = MOREEQ; return(RELOP); }
"<>"	{ ECHO; yylval.oper = NOTEQ; return(RELOP); }
"="		{ ECHO; yylval.oper = EQUAL; return(RELOP); }
"|" 	{ ECHO; yylval.oper = OR; return(OROP); }
"!" 	{ ECHO; yylval.oper = NOT; return(NOTOP); }
"=>"		{ ECHO; return(ARROW); }
begin		{ ECHO; return(BEGIN_); }
case		{ ECHO; return(CASE); }
character	{ ECHO; return(CHARACTER); }
end		{ ECHO; return(END); }
endswitch	{ ECHO; return(ENDSWITCH); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
is		{ ECHO; return(IS); }
list		{ ECHO; return(LIST); }
of		{ ECHO; return(OF); }
others		{ ECHO; return(OTHERS); }
returns		{ ECHO; return(RETURNS); }
switch		{ ECHO; return(SWITCH); }
when		{ ECHO; return(WHEN); }
else { ECHO; return(ELSE); }
elsif { ECHO; return(ELSIF); }
endfold { ECHO; return(ENDFOLD); }
endif { ECHO; return(ENDIF); }
fold { ECHO; return(FOLD); }
if { ECHO; return(IF); }
left { ECHO; return(LEFT); }
right { ECHO; return(RIGHT); }
then { ECHO; return(THEN); }
real { ECHO; return(REAL); }

{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); 
			strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{dec}		{ ECHO; yylval.value = atoi(yytext); return(INT_LITERAL); }
{float}		{ ECHO; yylval.value = atof(yytext); return(REAL_LITERAL); }
{hex}		{ ECHO; yylval.value = atoh(yytext); return(INT_LITERAL); }
{char}		{ ECHO; yylval.value = yytext[1]; return(CHAR_LITERAL); }
{escape}		{ ECHO; yylval.value = atoe(yytext); return(CHAR_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }
%%

