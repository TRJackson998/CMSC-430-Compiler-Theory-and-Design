/*
Terrence Jackson
UMGC CMSC 430
9.20.24
Project 3

Implement more arithmetic operators,
relational operators, fold stmt
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
    MORE,
    LESSEQ,
    MOREEQ,
    EQUAL,
    NOTEQ,
    AND,
    OR,
    NOT
};

enum Directions
{
    L,
    R
};

double evaluateArithmetic(double left, Operators operator_, double right);
double evaluateRelational(double left, Operators operator_, double right);
double evaluateFold(Directions direction, Operators operator_, std::vector<double> *list);