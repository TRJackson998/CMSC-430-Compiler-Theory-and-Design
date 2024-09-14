/* CMSC 430 Compiler Theory and Design
   Project 3 Skeleton
   UMGC CITE
   Summer 2023 */

/* This file contains flex input file */

%{
#include <cstdio>
#include <string>
#include <vector>

using namespace std;

#include "values.h"
#include "listing.h"
#include "tokens.h"

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
"-"		{ ECHO; return(ADDOP); }
"~"		{ ECHO; return(NEGOP); }
"*"		{ ECHO; yylval.oper = MULTIPLY; return(MULOP); }
"/"		{ ECHO; return(MULOP); }
"%"		{ ECHO; return(MODOP); }
"^"		{ ECHO; return(EXPOP); }
"&"		{ ECHO; yylval.oper = AND; return(ANDOP); }
"<"		{ ECHO; yylval.oper = LESS; return(RELOP); }
">"		{ ECHO; return(RELOP); }
"<="	{ ECHO; return(RELOP); }
">="	{ ECHO; return(RELOP); }
"<>"	{ ECHO; return(RELOP); }
"="		{ ECHO; return(RELOP); }
"|" 	{ ECHO; return(OROP); }
"!" 	{ ECHO; return(NOTOP); }
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
{float}		{ ECHO; return(REAL_LITERAL); }
{hex}		{ ECHO; return(INT_LITERAL); }
{char}		{ ECHO; yylval.value = yytext[1]; return(CHAR_LITERAL); }
{escape}		{ ECHO; return(CHAR_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }
%%

