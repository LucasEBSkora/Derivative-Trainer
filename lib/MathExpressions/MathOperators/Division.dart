import 'package:dxart/MathExpressions/MathExpression.dart';
import 'package:dxart/MathExpressions/MathFunctions/Exponentiation.dart';
import 'package:dxart/MathExpressions/MathNumber.dart';
import 'package:dxart/MathExpressions/MathOperators/MathOperator.dart';
import 'package:dxart/MathExpressions/MathOperators/Multiplication.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//TODO: Fix printing the fraction slash

class Division extends MathOperator {
  MathExpression numerator;
  MathExpression denominator;

  //takes two lists of expressions as parameters, and transforms them into Multiplications if they have more than one entry.
  //use create to actually instantiate this class
  Division._(List<MathExpression> numerator, List<MathExpression> denominator,
      [bool negative = false])
      : this.numerator = (numerator.length == 1)
            ? numerator[0]
            : Multiplication.create(numerator),
        this.denominator = (denominator.length == 1)
            ? denominator[0]
            : Multiplication.create(denominator),
        super(negative);

  //creates an Division, performing simplifications when possible
  static MathExpression create(
      List<MathExpression> numerator, List<MathExpression> denominator,
      [bool negative = false]) {
    //if an expression is both in the numerator and the denominator, removes both
    for (int i = 0; i < numerator.length;) {
      for (int j = 0; j < denominator.length;) {
        if (numerator[i] == denominator[j]) {
          numerator.removeAt(i);
          denominator.removeAt(j);
          continue;
        } else {
          ++i;
          ++j;
        }
      }
    }

    //if, after simplifying, there are no more expressions in the denominator, returns the numerator as a Multiplication
    if (denominator.length == 0) return Multiplication.create(numerator);

    //if after the simplifications both lists are empty, returns 1
    if (numerator.length == 0 && denominator.length == 0)
      return MathNumber(1);
    else
      return Division._(numerator, denominator, negative);
  }

  @override
  Widget toWidgetPrivate(
      {double scale = 1, bool showMinusSign = true, TextStyle style}) {
    //attempt to use a stack to represent a division

    // return Stack(
    //   alignment: Alignment.center,
    //   overflow: Overflow.visible,
    //   fit: StackFit.loose,
    //   children: <Widget>[
    //     Align(
    //       heightFactor: 0,
    //       child: Container(
    //           padding: EdgeInsets.only(left: 3, right: 3),
    //           decoration: BoxDecoration(border: Border(bottom: BorderSide())),
    //           child: numerator.toWidgetPrivate(scale)),
    //     ),
    //     Align(
    //       heightFactor: 0,
    //       child: Container(
    //           padding: EdgeInsets.only(left: 3, right: 3),
    //           decoration: BoxDecoration(border: Border(top: BorderSide())),
    //           child: denominator.toWidgetPrivate(scale)),
    //     ),
    //   ],
    // );

    //prints numerator and denominator as widgets with a bottom or top border, respectively.
    //if there is a way to make these borders overlap, it would fix the slash

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 3, right: 3),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: style.color)
            ),
            ),
            child: numerator.toWidgetPrivate(scale: scale, style: style)),
        Container(
            padding: EdgeInsets.only(left: 3, right: 3),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: style.color))),
            child: denominator.toWidgetPrivate(scale: scale, style: style)),
      ],
    );
  }

  @override
  MathExpression derivative() {
    return Division.create([
      (numerator.derivative() * denominator) -
          (numerator * denominator.derivative())
    ], [
      Exp(denominator, MathNumber(2))
    ]);
  }

  @override
  String toString() =>
      '(' + numerator.toString() + ')/(' + denominator.toString() + ')';

  @override
  MathExpression opposite() {
    return Division._([this.numerator], [this.denominator], !this.negative);
  }

  @override
  MathExpression abs() {
    return Division._([this.numerator], [this.denominator], false);
  }
}
