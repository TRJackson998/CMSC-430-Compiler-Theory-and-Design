// CMSC 430 Compiler Theory and Design
// Project 4 Skeleton
// UMGC CITE
// Summer 2023

// This file contains the bodies of the type checking functions

/*
Terrence Jackson
UMGC CMSC 430
10.8.24
Project 4

Updates to type checking and type validation
*/

#include <string>
#include <vector>

using namespace std;

#include "types.h"
#include "listing.h"

void checkAssignment(Types lValue, Types rValue, string message)
{
	if (lValue == INT_TYPE && rValue == REAL_TYPE)
		appendError(GENERAL_SEMANTIC, "Illegal Narrowing on " + message);
	else if (lValue != MISMATCH && rValue != MISMATCH && lValue != rValue)
		appendError(GENERAL_SEMANTIC, "Type Mismatch on " + message);
}

bool checkType(Types value, Types type, string message)
{
	if (value == MISMATCH || value != type)
	{
		appendError(GENERAL_SEMANTIC, message);
		return false;
	}
	else
		return true;
}

Types checkWhen(Types true_, Types false_)
{
	if (true_ == MISMATCH || false_ == MISMATCH)
		return MISMATCH;
	if (true_ != false_)
		appendError(GENERAL_SEMANTIC, "When Types Mismatch ");
	return true_;
}

Types checkSwitch(Types case_, Types when, Types other)
{
	if (case_ != INT_TYPE)
		appendError(GENERAL_SEMANTIC, "Switch Expression Not Integer");
	return checkCases(when, other);
}

Types checkCases(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left == NONE || left == right)
		return right;
	appendError(GENERAL_SEMANTIC, "Case Types Mismatch");
	return MISMATCH;
}

Types checkNumeric(Types value, string message)
{
	// let mismatch float up to the top
	if (value == MISMATCH)
		return MISMATCH;

	// check if it's one of the numeric types
	if ((value == INT_TYPE) || (value == REAL_TYPE))
		return value;

	// error if we get this far
	appendError(GENERAL_SEMANTIC, message);
	return MISMATCH;
}

Types checkNumeric(Types left, Types right, string message)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left == INT_TYPE && right == INT_TYPE)
		return INT_TYPE;
	if (left == INT_TYPE && right == REAL_TYPE)
		return REAL_TYPE;
	if (left == REAL_TYPE && right == INT_TYPE)
		return REAL_TYPE;
	appendError(GENERAL_SEMANTIC, message);
	return MISMATCH;
}

Types checkList(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left == NONE || left == right)
		return right;
	appendError(GENERAL_SEMANTIC, "List Element Types Do Not Match");
	return MISMATCH;
}

Types checkRelation(Types left, Types right)
{
	// let mismatch float up to the top
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;

	// if one is a char, check that both are
	if (left == CHAR_TYPE || right == CHAR_TYPE)
	{
		if (left != CHAR_TYPE || right != CHAR_TYPE)
		{
			// if one side is a char, both sides must be a char
			appendError(GENERAL_SEMANTIC, "Character Literals Cannot be Compared to Numeric Expressions");
			return MISMATCH;
		}
		else
			// both are chars
			return CHAR_TYPE;
	}
	return checkNumeric(left, right, "Relational Operator Requires Character or Numeric Types");
}

Types checkMod(Types left, Types right)
{
	if (left == INT_TYPE && right == INT_TYPE)
	{
		return INT_TYPE;
	}
	appendError(GENERAL_SEMANTIC, "Remainder Operator Requires Integer Operands");
	return MISMATCH;
}

Types checkIf(Types if_, Types elsifs_, Types else_)
{
	// let mismatch float up to the top
	if ((if_ == MISMATCH) || (elsifs_ == MISMATCH) || (else_ == MISMATCH))
	{
		return MISMATCH;
	}

	// compare elsif/else to if
	if (((elsifs_ != NONE) && (if_ != elsifs_)) || (if_ != else_))
	{
		appendError(GENERAL_SEMANTIC, "If-Elsif-Else Type Mismatch");
		return MISMATCH;
	}
	return if_;
}