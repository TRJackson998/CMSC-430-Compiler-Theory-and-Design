/*
Terrence Jackson
UMGC CMSC 430
9.18.24
Project 3

Implement more arithmetic operators
*/

// This file contains type definitions and the function
// definitions for the evaluation functions

typedef char *CharPtr;

enum Operators
{
    ADD,
    SUBTRACT,
    MULTIPLY,
    DIVIDE,
    EXP,
    MOD,
    NEG,
    LESS,
    AND
};

double evaluateArithmetic(double left, Operators operator_, double right);
double evaluateRelational(double left, Operators operator_, double right);
double evaluateUnary(Operators operator_, double right);
