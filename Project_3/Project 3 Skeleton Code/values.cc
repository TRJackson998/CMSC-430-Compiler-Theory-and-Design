/*
Terrence Jackson
UMGC CMSC 430
9.20.24
Project 3

Implement more arithmetic operators,
relational operators,
fold statement
*/

// This file contains the bodies of the evaluation functions

#include <string>
#include <cmath>
#include <vector>

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
		if (right == 0)
		{
			result = NAN;
		}
		else
		{
			result = left / right;
		}
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
	case LESSEQ:
		result = left <= right;
		break;
	case MORE:
		result = left > right;
		break;
	case MOREEQ:
		result = left >= right;
		break;
	case EQUAL:
		result = (left == right);
		break;
	case NOTEQ:
		result = (left != right);
		break;
	}
	return result;
}

double evaluateFold(Directions direction, Operators operator_, std::vector<double> *list)
{
	double result;
	if (direction == L)
	{
		auto i = list->begin();
		result = *(i++);
		while (i != list->end())
		{
			result = evaluateArithmetic(result, operator_, *i);
			i++;
		}
	}
	else
	{
		auto i = list->rbegin();
		result = *(i++);
		while (i != list->rend())
		{
			result = evaluateArithmetic(*i, operator_, result);
			i++;
		}
	}

	return result;
}