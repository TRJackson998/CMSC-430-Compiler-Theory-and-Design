/* CMSC 430 Compiler Theory and Design
   Project 4 Skeleton
   UMGC CITE
   Summer 2023
   
   Project 4 Parser with semantic actions for static semantic errors */

%{
#include <string>
#include <vector>
#include <map>

using namespace std;

#include "types.h"
#include "listing.h"
#include "symbols.h"

int yylex();
Types find(Symbols<Types>& table, CharPtr identifier, string tableName);
void yyerror(const char* message);

Symbols<Types> scalars;
Symbols<Types> lists;

%}

%define parse.error verbose

%union {
	CharPtr iden;
	Types type;
}

%token <iden> IDENTIFIER

%token <type> INT_LITERAL CHAR_LITERAL REAL_LITERAL

%token ADDOP MULOP RELOP ANDOP ARROW OROP NOTOP MODOP EXPOP NEGOP

%token BEGIN_ CASE CHARACTER ELSE ELSIF END ENDIF ENDFOLD ENDSWITCH FOLD FUNCTION IF INTEGER IS LIST OF OTHERS
	RETURNS SWITCH WHEN LEFT RIGHT THEN REAL

%type <type> list expressions body type statement_ statement cases case expression
	term primary factor negate relation

%%

function:	
	function_header optional_variable body ;
	
		
function_header:	
	FUNCTION IDENTIFIER parameters RETURNS type ';' ;

parameters:
	parameter optional_parameters |
	%empty ;

optional_parameters:
	optional_parameters ',' parameter |
	%empty ;

parameter:	
	IDENTIFIER ':' type {scalars.insert($1, $3);};

type:
	INTEGER {$$ = INT_TYPE;} |
	CHARACTER {$$ = CHAR_TYPE; } |
	REAL {$$ = REAL_TYPE; } ;
	
optional_variable:
	optional_variable variable |
	%empty ;
    
variable:	
	IDENTIFIER ':' type IS statement ';' {checkAssignment($3, $5, "Variable Initialization"); scalars.insert($1, $3);} |
	IDENTIFIER ':' LIST OF type IS list ';' {checkAssignment($5, $7, "List Initialization"); lists.insert($1, $5);};

list:
	'(' expressions ')' {$$ = $2;} ;

expressions:
	expressions ',' expression {$$ = checkList($1, $3);} | 
	expression ;

body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;
    
statement_:
	statement ';' |
	error ';' {$$ = MISMATCH;} ;
	
statement:
	expression |
	WHEN condition ',' expression ':' expression 
		{$$ = checkWhen($4, $6);} |
	SWITCH expression IS cases OTHERS ARROW statement ';' ENDSWITCH 
		{$$ = checkSwitch($2, $4, $7);} |
	IF condition THEN statement_ elsifs ELSE statement_ ENDIF |
	FOLD direction operator list_choice ENDFOLD ;

cases:
	cases case {$$ = checkCases($1, $2);} | 
	%empty {$$ = NONE;} ;
	
case:
	CASE INT_LITERAL ARROW statement ';' {$$ = $4;} ; 

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
	condition OROP conjunction |
	conjunction ;

conjunction:
	conjunction ANDOP negation |
	negation ;

negation:
	NOTOP relation |
	relation ;

relation:
	'(' condition')' |
	expression RELOP expression {$$ = checkRelation($1, $3);} ;
	
expression:
	expression ADDOP term {$$ = checkArithmetic($1, $3);} |
	term ;
      
term:
	term MULOP factor {$$ = checkArithmetic($1, $3);} |
	term MODOP factor |
	factor ;

factor:
	negate EXPOP factor |
	negate ;

negate:
	NEGOP primary |
	primary ;

primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL | 
	CHAR_LITERAL |
	REAL_LITERAL |
	IDENTIFIER '(' expression ')' {checkType($3, INT_TYPE, "List Subscript Must Be Integer"); $$ = find(lists, $1, "List");} |
	IDENTIFIER  {$$ = find(scalars, $1, "Scalar");} ;

%%

Types find(Symbols<Types>& table, CharPtr identifier, string tableName) {
	Types type;
	if (!table.find(identifier, type)) {
		appendError(UNDECLARED, tableName + " " + identifier);
		return MISMATCH;
	}
	return type;
}

void yyerror(const char* message) {
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[]) {
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 
