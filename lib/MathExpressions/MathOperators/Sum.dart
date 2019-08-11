import 'package:dxart/MathExpressions/MathExpression.dart';
import 'package:dxart/MathExpressions/MathOperators/MathOperator.dart';
import 'package:dxart/utils/Parentheses.dart';
import 'package:dxart/utils/ScaledText.dart';

import 'package:flutter/widgets.dart';

import '../MathNumber.dart';

//class that represents a sequence of sums and subtractions

class Sum extends MathOperator {
  List<MathExpression> operands;

  //the constructor is secret because the class should be instantiated whether through the
  //create method (which performs simplifications) or the operator (which really just calls create)
  Sum._(this.operands, [bool negative = false]) : super(negative);

  //actually instanciates Sum, performing simplifications when possible
  static MathExpression create(List<MathExpression> operands) {


        //removes every number from the list, sums them all and add it again
    int number = 0;
    operands.removeWhere((MathExpression m) {
      if (m is MathNumber) {
        number += m.value;
        return true;
      } else
        return false;
    });
    if (number != 0) {
      operands.add(MathNumber(number));
    }
    //removes zeros from the sum
    operands.removeWhere((MathExpression m) {
      if (m is MathNumber) {
        return m.value == 0;
      } else
        return false;
    });

    if (operands.length == 0) return MathNumber(0);

    //if there ends up being only one non-null operand, returns it
    if (operands.length == 1) return operands[0];

    int index = operands.indexWhere((m) => (m is Sum));

    if (index != -1) {
      List<MathExpression> list = operands;
      Sum m = operands[index];
      list.removeAt(index);
      list.insertAll(index, m.operands);

      return Sum.create(list);
    }

    return (Sum._(operands));
  }

  @override
  Widget toWidgetPrivate(
      {double scale = 1, bool showMinusSign = true, TextStyle style}) {
    //creates a list of widgets alternating between the operands and '+' or '-',
    // using parentheses when the operand is an operator

    List<Widget> widgets = List<Widget>(operands.length * 2 - 1);
    widgets[0] = Parentheses(
        child: operands[0].toWidgetPrivate(scale: scale, style: style),
        scale: scale,
        textStyle: style,
        useParentheses: operands[0].isOperator,
        negative: operands[0].negative);

    for (int i = 1; i < widgets.length; ++i) {
      if (i % 2 == 1)
        widgets[i] = ScaledText(
          (operands[(i / 2).ceil()].negative) ? ' - ' : ' + ',
          scale,
          style: style,
        );
      else {
        MathExpression op = operands[(i / 2).floor()];
        widgets[i] = Parentheses(
          child: op.toWidgetPrivate(
              scale: scale, showMinusSign: false, style: style),
          scale: scale,
          textStyle: style,
          useParentheses: op.isOperator,
        );
      }
    }
    // return Wrap(
    //   direction: Axis.horizontal,
    //   alignment: WrapAlignment.center,
    //   crossAxisAlignment: WrapCrossAlignment.center,
    //   children: widgets,
    // );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: widgets,
    );
  }

  @override
  MathExpression derivative() {
    List<MathExpression> ops =
        List.generate(operands.length, (i) => operands[i].derivative());
    return Sum.create(ops);
  }

  @override
  String toString() {
    String s = '(' + operands[0].toString() + ')';
    for (int i = 1; i < operands.length; ++i)
      s += ' + (' + operands[i].toString() + ')';
    return s;
  }

  @override
  MathExpression opposite() {
    return Sum._(this.operands, !negative);
  }

  @override
  MathExpression abs() {
    return Sum._(this.operands, false);
  }
}
