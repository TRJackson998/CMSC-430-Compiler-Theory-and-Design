/*
Terrence Jackson
UMGC CMSC 430
8.27.24
Project 2
*/

// This file contains the function prototypes for the functions that produce
// the compilation listing

enum ErrorCategories
{
	LEXICAL,
	SYNTAX,
	GENERAL_SEMANTIC,
	DUPLICATE_IDENTIFIER,
	UNDECLARED
};

void firstLine();
void nextLine();
int lastLine();
void appendError(ErrorCategories errorCategory, string message);
