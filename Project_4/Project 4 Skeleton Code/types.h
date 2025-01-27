// CMSC 430 Compiler Theory and Design
// Project 4 Skeleton
// UMGC CITE
// Summer 2023

// This file contains type definitions and the function
// prototypes for the type checking functions

/*
Terrence Jackson
UMGC CMSC 430
10.8.24
Project 4

Updates to type checking and type validation
*/

typedef char *CharPtr;

enum Types
{
    MISMATCH,
    INT_TYPE,
    CHAR_TYPE,
    REAL_TYPE,
    NONE
};

void checkAssignment(Types lValue, Types rValue, string message);
bool checkType(Types value, Types type, string message);
Types checkWhen(Types true_, Types false_);
Types checkSwitch(Types case_, Types when, Types other);
Types checkCases(Types left, Types right);
Types checkNumeric(Types value, string message = "Arithmetic Operator Requires Numeric Types");
Types checkNumeric(Types left, Types right, string message = "Arithmetic Operator Requires Numeric Types");
Types checkList(Types left, Types right);
Types checkRelation(Types left, Types right);
Types checkMod(Types left, Types right);
Types checkIf(Types if_, Types elsifs_, Types else_);