import 'package:dxart/MathExpressions/MathExpression.dart';
import 'package:dxart/MathExpressions/MathOperators/MathOperator.dart';
import 'package:dxart/MathExpressions/MathOperators/MathOperators.dart';
import 'package:dxart/utils/Parentheses.dart';
import 'package:dxart/utils/ScaledText.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter/widgets.dart';

import '../MathNumber.dart';

class Multiplication extends MathOperator {
  List<MathExpression> operands;

  //in order to actually instantiate this class, use create.
  Multiplication._(this.operands, [bool negative = false])
      : assert((operands?.length ?? 0) >= 2),
        super(negative);

  //instantiates the class, performing simplifications when possible
  static MathExpression create(List<MathExpression> operands) {
    print(operands);
    //if there are any zeroes in the list, returns zero
    if (operands.indexWhere((MathExpression m) {
          if (m is MathNumber)
            return m.value == 0;
          else
            return false;
        }) !=
        -1) {
      return MathNumber(0);
    }

    //removes ones from the list
    operands.removeWhere((MathExpression m) {
      if (m is MathNumber) {
        return m.value == 1;
      } else
        return false;
    });
    
    //if the list ends up empty, returns 1
    if (operands.length == 0) return MathNumber(1);
    //if there is a single element in the list, returns it directly instead of creating a Multiplication with a single operand
    if (operands.length == 1) return operands[0];

    //if there are any multiplications in the operands, replaces the multiplications with its operands in the same position
    int index = operands.indexWhere((m) => (m is Multiplication));

    if (index != -1) {
      List<MathExpression> list = operands;
      Multiplication m = operands[index];
      list.removeAt(index);
      list.insertAll(index, m.operands);

      return Multiplication._(list);
    }

    //if there are any Divisions in the operands, returns another Division with the other operands included in the numerator
    index = operands.indexWhere((m) => (m is Division));

    if (index != -1) {
      List<MathExpression> list = operands;
      Division m = operands[index];
      list.removeAt(index);
      list.insert(index, m.numerator);

      return Division.create(list, [m.denominator]);
    }

    return Multiplication._(operands);
  }

  @override
  Widget toWidgetPrivate(
      {double scale = 1, bool showMinusSign = true, TextStyle style}) {
    //creates a list of widgets alternating between the operands and '*',
    // using parentheses when the operand is negative or itself an operator

    List<Widget> widgets = List<Widget>(operands.length * 2 - 1);
    widgets[0] = Parentheses(
        child: operands[0].toWidgetPrivate(scale: scale, style: style),
        scale: scale,
        textStyle: style,
        useParentheses: operands[0].isOperator || operands[0].negative);

    for (int i = 1; i < widgets.length; ++i) {
      if (i % 2 == 1)
        widgets[i] = ScaledText(
          '*',
          scale,
          style: style,
        );
      else {
        MathExpression op = operands[(i / 2).floor()];

        widgets[i] = Parentheses(
          child: op.toWidgetPrivate(scale: scale, style: style),
          scale: scale,
          useParentheses: op.isOperator || op.negative,
          textStyle: style,
        );
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: widgets,
    );
  }

  @override
  MathExpression derivative() {
    List<MathExpression> ops = List.from(operands);
    ops[0] = ops[0].derivative();
    MathExpression df = Multiplication.create(ops);

    for (int i = 1; i < operands.length; ++i) {
      ops = operands;
      ops[i] = ops[i].derivative();
      df += Multiplication.create(ops);
    }

    return df;
  }

  @override
  String toString() {
    String s = '(' + operands[0].toString() + ')';
    for (int i = 1; i < operands.length; ++i)
      s += '*(' + operands[i].toString() + ')';
    return s;
  }

  @override
  MathExpression opposite() {
    return Multiplication._(operands, !negative);
  }

  @override
  MathExpression abs() {
    return Multiplication._(operands, false);
  }
}
