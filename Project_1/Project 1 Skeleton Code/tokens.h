// CMSC 430 Compiler Theory and Design
// Project 1 Skeleton
// UMGC CITE
// Summer 2023

// This file contains the enumerated type definition for tokens

/*
Terrence Jackson
UMGC CMSC 430
8.27.24
Project 1

Added more tokens for keywords, operators, and literals
*/

enum Tokens
{
    ADDOP = 256,
    MULOP,
    ANDOP,
    RELOP,
    ARROW,
    BEGIN_,
    CASE,
    CHARACTER,
    END,
    ENDSWITCH,
    FUNCTION,
    INTEGER,
    IS,
    LIST,
    OF,
    OTHERS,
    RETURNS,
    SWITCH,
    WHEN,
    IDENTIFIER,
    INT_LITERAL,
    CHAR_LITERAL,
    ELSE,
    ELSEIF,
    ENDFOLD,
    ENDIF,
    FOLD,
    IF,
    LEFT,
    RIGHT,
    THEN,
    OROP,
    NOTOP,
    REMOP,
    EXPOP,
    NEGOP,
    REAL_LITERAL
};
