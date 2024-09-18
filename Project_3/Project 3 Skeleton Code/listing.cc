// This file contains the bodies of the functions that produces the
// compilation listing

/*
Terrence Jackson
UMGC CMSC 430
8.27.24
Project 3
*/

#include <cstdio>
#include <string>
#include <vector>

using namespace std;

#include "listing.h"

static int lineNumber;
static vector<string> errors;
static int lexicalErrors = 0;
static int syntacticErrors = 0;
static int semanticErrors = 0;

static void displayErrors();

void firstLine()
{
	lineNumber = 1;
	printf("\n%4d  ", lineNumber);
}

void nextLine()
{
	displayErrors();
	lineNumber++;
	printf("%4d  ", lineNumber);
}

int lastLine()
{
	printf("\r");
	// compute total errors
	int totalErrors = lexicalErrors + syntacticErrors + semanticErrors;

	// final message depends on number of errors
	if (totalErrors == 0)
	{
		printf("Compiled Successfully.\n");
	}
	else
	{
		displayErrors();
		printf("\n\n");

		printf("Lexical Errors %d\n", lexicalErrors);
		printf("Syntax Errors %d\n", syntacticErrors);
		printf("Semantic Errors %d\n", semanticErrors);
	}

	printf("     \n");
	return totalErrors;
}

void appendError(ErrorCategories errorCategory, string message)
{
	string messages[] = {"Lexical Error, Invalid Character ", "",
						 "Semantic Error, ", "Semantic Error, Duplicate ",
						 "Semantic Error, Undeclared "};

	errors.push_back(messages[errorCategory] + message);

	// Keep track of how many specific error types
	switch (errorCategory)
	{
	case LEXICAL:
		lexicalErrors++;
		break;
	case SYNTAX:
		syntacticErrors++;
		break;
	case GENERAL_SEMANTIC:
	case DUPLICATE_IDENTIFIER:
	case UNDECLARED:
		semanticErrors++;
		break;
	default:
		break;
	}
}

void displayErrors()
{
	for (int i = 0; i < errors.size(); i++)
	{
		printf("%s\n", errors[i].c_str());
	}
	errors.clear();
}
