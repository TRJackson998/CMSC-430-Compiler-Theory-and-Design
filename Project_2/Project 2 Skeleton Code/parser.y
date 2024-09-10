/* CMSC 430 Compiler Theory and Design
   Project 2 Skeleton
   UMGC CITE
   Summer 2023 

   Project 2 Parser */
/*
Terrence Jackson
UMGC CMSC 430
9.8.24
Project 2

Additional tokens and productions to implement parsing
for more operators, statements, expressions, and variables
*/   

%{

#include <string>

using namespace std;

#include "listing.h"

int yylex();
void yyerror(const char* message);

%}

%define parse.error verbose

%token IDENTIFIER INT_LITERAL CHAR_LITERAL REAL_LITERAL

%token ADDOP MULOP ANDOP RELOP ARROW OROP NOTOP MODOP EXPOP NEGOP

%token BEGIN_ CASE CHARACTER ELSE ELSIF END ENDIF ENDFOLD ENDSWITCH FOLD FUNCTION IF INTEGER IS LIST OF OTHERS
	RETURNS SWITCH WHEN LEFT RIGHT THEN REAL

%%

function:	
	function_header optional_variables body ;

function_header:	
	FUNCTION IDENTIFIER parameters RETURNS type ';' |
	error ';' ;

type:
	INTEGER |
	REAL |	
	CHARACTER ;
	
optional_variables:
	optional_variables variable |
	%empty ;

variable:	
	IDENTIFIER ':' type IS statement ';' |
	IDENTIFIER ':' LIST OF type IS list ';' |
	error ';' ;

parameters:
	parameter optional_parameters |
	%empty ;

optional_parameters:
	optional_parameters ',' parameter |
	%empty ;

parameter:	
	IDENTIFIER ':' type ;

list:
	'(' expressions ')' ;

expressions:
	expressions ',' expression| 
	expression ;

body:
	BEGIN_ statement_ END ';' ;

statement_:
	statement ';' |
	error ';' ;
    
statement:
	expression |
	WHEN condition ',' expression ':' expression |
	SWITCH expression IS cases OTHERS ARROW statement ';' ENDSWITCH |
	IF condition THEN statement ';' elsifs ELSE statement ';' ENDIF |
	FOLD direction operator list_choice ENDFOLD ;

cases:
	cases case |
	error ';' |
	%empty ;
	
case:
	CASE INT_LITERAL ARROW statement ';' ; 

elsifs:
	elsifs elsif |
	%empty ;

elsif:
	ELSIF condition THEN statement ';' ;

direction:
	LEFT | RIGHT ;

operator:
	ADDOP | MULOP ;

list_choice:
	list | IDENTIFIER ;

condition:
	condition OROP conjunction |
	conjunction ;

conjunction:
	conjunction ANDOP negation |
	negation ;

negation:
	NOTOP relation |
	relation ;

relation:
	'(' condition ')' |
	expression RELOP expression ;

expression:
	expression ADDOP term |
	term ;
      
term:
	term MULOP factor |
	term MODOP factor |
	factor ;

factor:
	negate EXPOP factor |
	negate ;

negate:
	NEGOP primary |
	primary ;

primary:
	'(' expression ')' |
	INT_LITERAL |
	CHAR_LITERAL |
	REAL_LITERAL |
	IDENTIFIER '(' expression ')' |
	IDENTIFIER ;

%%

void yyerror(const char* message) {
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[]) {
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 
