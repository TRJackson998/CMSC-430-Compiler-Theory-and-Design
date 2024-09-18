/*
Terrence Jackson
UMGC CMSC 430
9.18.24
Project 3

Implement more arithmetic operators
*/

// This file contains the bodies of the evaluation functions

#include <string>
#include <cmath>

using namespace std;

#include "values.h"
#include "listing.h"

double evaluateArithmetic(double left, Operators operator_, double right)
{
	double result;
	switch (operator_)
	{
	case ADD:
		result = left + right;
		break;
	case SUBTRACT:
		result = left - right;
		break;
	case MULTIPLY:
		result = left * right;
		break;
	case DIVIDE:
		result = left / right;
		break;
	case MOD:
		result = (int)left % (int)right; // can only mod integers
		break;
	case EXP:
		result = pow(left, right);
		break;
	}
	return result;
}

double evaluateRelational(double left, Operators operator_, double right)
{
	double result;
	switch (operator_)
	{
	case LESS:
		result = left < right;
		break;
	}
	return result;
}

double evaluateUnary(Operators operator_, double right)
{
	double result;
	switch (operator_)
	{
	case NEG:
		result = right * -1;
		break;
	}
	return result;
}