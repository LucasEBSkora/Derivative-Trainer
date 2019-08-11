import 'package:dxart/MathExpressions/MathExpression.dart';
import 'package:dxart/MathExpressions/MathExpressions.dart';
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
  Division._(
      this.numerator, this.denominator, bool negative)
      : assert(numerator != null),
        assert(denominator != null),
        super(negative);

  //creates an Division, performing simplifications when possible
  static MathExpression create(
      List<MathExpression> numerator, List<MathExpression> denominator,
      [bool negative = false]) {
    print(numerator);
    print(denominator);
    if (numerator.indexWhere((MathExpression m) {
          if (m is MathNumber)
            return m.value == 0;
          else
            return false;
        }) !=
        -1) {
      return MathNumber(0);
    }
    print(numerator);
    print(denominator);
    //if an expression is both in the numerator and the denominator, removes both

    for (int i = 0; i < numerator.length;) {
      bool removed = false;

      for (int j = 0; j < denominator.length;) {
        if (numerator[i] == denominator[j]) {
          numerator.removeAt(i);
          denominator.removeAt(j);
          removed = true;
          break;
        } else {
          ++j;
        }
      }
      if (removed == false) ++i;
    }
    print(numerator);
    print(denominator);
    //if there are any divisions in the numerator, adds its numerator and denominator to the outer division
    int index = numerator.indexWhere((m) => (m is Division));

    if (index != -1) {
      Division m = numerator[index];
      numerator.removeAt(index);
      MathExpression ops = m.numerator;

      if (ops is Multiplication)
        numerator.insertAll(index, ops.operands);
      else
        numerator.insertAll(index, [m.numerator]);

      ops = m.denominator;

      if (ops is Multiplication)
        denominator.addAll(ops.operands);
      else
        denominator.addAll([m.denominator]);
      return Division.create(numerator, denominator);
    }
    print(numerator);
    print(denominator);
    //same for the denominator
    index = denominator.indexWhere((m) => (m is Division));

    if (index != -1) {
      List<MathExpression> list = denominator;
      Division m = denominator[index];
      list.removeAt(index);
      MathExpression ops = m.numerator;
      if (ops is Multiplication)
        list.addAll(ops.operands);
      else
        list.addAll([m.numerator]);
      ops = m.denominator;
      if (ops is Multiplication)
        numerator.addAll(ops.operands);
      else
        numerator.addAll([m.denominator]);
      return Division.create(numerator, denominator);
    }

    //if, after simplifying, there are no more expressions in the denominator, returns the numerator as a Multiplication
    if (denominator.length == 0) return Multiplication.create(numerator);
    print(numerator);
    print(denominator);
    MathExpression numExp;
    MathExpression denExp;
    //if after the simplifications both lists are empty, returns 1
    if (numerator.length == 0 && denominator.length == 0)
      return MathNumber(1);
    else {
      if (numerator.length == 1)
        numExp = numerator[0];
      else
        numExp = Multiplication.create(numerator);
      if (denominator.length == 1)
        denExp = denominator[0];
      else
        denExp = Multiplication.create(denominator);
    }
    print(numExp);
    print(denExp);
    return Division._(numExp, denExp,
        (numExp.negative ? -1 : 1) * (denExp.negative ? -1 : 1) == -1);
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

    Color borderColor = (style.color ?? Colors.black);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 3, right: 3),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: numerator.toWidgetPrivate(scale: scale, style: style)),
        Container(
            padding: EdgeInsets.only(left: 3, right: 3),
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: borderColor))),
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
      Exp.create(denominator, MathNumber(2))
    ]);
  }

  @override
  String toString() =>
      '(' + numerator.toString() + ')/(' + denominator.toString() + ')';

  @override
  MathExpression opposite() {
    return Division._(this.numerator, this.denominator, !this.negative);
  }

  @override
  MathExpression abs() {
    return Division._(this.numerator, this.denominator, false);
  }
}
