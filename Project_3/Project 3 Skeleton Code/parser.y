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

#include <iostream>
#include <cmath>
#include <string>
#include <vector>
#include <map>

using namespace std;

#include "values.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);
double extract_element(CharPtr list_name, double subscript);

Symbols<double> scalars;
Symbols<vector<double>*> lists;
double result;

%}

%define parse.error verbose

%union {
	CharPtr iden;
	Operators oper;
	double value;
	vector<double>* list;
}

%token <iden> IDENTIFIER

%token <value> INT_LITERAL CHAR_LITERAL REAL_LITERAL

%token <oper> ADDOP MULOP ANDOP RELOP OROP NOTOP MODOP EXPOP NEGOP

%token ARROW

%token BEGIN_ CASE CHARACTER ELSE ELSIF END ENDIF ENDFOLD ENDSWITCH FOLD FUNCTION IF INTEGER IS LIST OF OTHERS
	RETURNS SWITCH WHEN LEFT RIGHT THEN REAL

%type <value> body statement_ statement cases case expression term primary
	 condition relation conjunction variable factor negate negation

%type <list> list expressions

%%

function:	
	function_header optional_variables  body ';' {result = $3;} ;
	
function_header:	
	FUNCTION IDENTIFIER parameters RETURNS type ';' ;

type:
	INTEGER |
	REAL |
	CHARACTER ;
	
optional_variables:
	optional_variables variable |
	%empty ;
	
variable:	
	IDENTIFIER ':' type IS statement ';' {scalars.insert($1, $5);}; |
	IDENTIFIER ':' LIST OF type IS list ';' {lists.insert($1, $7);}  |
	error ';' {$$ = 0;} ;

parameters:
	parameter optional_parameters |
	%empty ;

optional_parameters:
	optional_parameters ',' parameter |
	%empty ;

parameter:	
	IDENTIFIER ':' type ;

list:
	'(' expressions ')' {$$ = $2;} ;

expressions:
	expressions ',' expression {$1->push_back($3); $$ = $1;} | 
	expression {$$ = new vector<double>(); $$->push_back($1);}

body:
	BEGIN_ statement_ END {$$ = $2;} ;

statement_:
	statement ';' |
	error ';' {$$ = 0;} ;
    
statement:
	expression |
	WHEN condition ',' expression ':' expression {$$ = $2 ? $4 : $6;} |
	SWITCH expression IS cases OTHERS ARROW statement ';' ENDSWITCH
		{$$ = !isnan($4) ? $4 : $7;} |
	IF condition THEN statement_ elsifs ELSE statement_ ENDIF |
	FOLD direction operator list_choice ENDFOLD ;

cases:
	cases case {$$ = !isnan($1) ? $1 : $2;} |
	error ';' {$$ = 0;} |
	%empty {$$ = NAN;} ;
	
case:
	CASE INT_LITERAL ARROW statement ';' {$$ = $<value>-2 == $2 ? $4 : NAN;} ; 

elsifs:
	elsifs elsif |
	%empty ;

elsif:
	ELSIF condition THEN statement_ ;

direction:
	LEFT | RIGHT ;

operator:
	ADDOP | MULOP ;

list_choice:
	list | IDENTIFIER ;

condition:
	condition OROP conjunction {$$ = $1 || $3;} |
	conjunction ;

conjunction:
	conjunction ANDOP negation {$$ = $1 && $3;} |
	negation ;

negation:
	NOTOP relation {$$ = !$2;} |
	relation ;

relation:
	'(' condition ')' {$$ = $2;} |
	expression RELOP expression {$$ = evaluateRelational($1, $2, $3);} ;

expression:
	expression ADDOP term {$$ = evaluateArithmetic($1, $2, $3);} |
	term ;
      
term:
	term MULOP factor {$$ = evaluateArithmetic($1, $2, $3); if ($3 == 0) appendError(SYNTAX, "Error, division by 0");}  |
	term MODOP factor {$$ = evaluateArithmetic($1, $2, $3);}  |
	factor ;

factor:
	negate EXPOP factor {$$ = evaluateArithmetic($1, $2, $3);} |
	negate ;

negate:
	NEGOP primary {$$ = ($2 * -1);}|
	primary ;	

primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL | 
	CHAR_LITERAL |
	REAL_LITERAL |
	IDENTIFIER '(' expression ')' {$$ = extract_element($1, $3); } |
	IDENTIFIER {if (!scalars.find($1, $$)) appendError(UNDECLARED, $1);} ;

%%

void yyerror(const char* message) {
	appendError(SYNTAX, message);
}

double extract_element(CharPtr list_name, double subscript) {
	vector<double>* list; 
	if (lists.find(list_name, list))
		return (*list)[subscript];
	appendError(UNDECLARED, list_name);
	return NAN;
}

int main(int argc, char *argv[]) {
	firstLine();
	yyparse();
	if (lastLine() == 0)
		cout << "Result = " << result << endl;
	return 0;
} 
