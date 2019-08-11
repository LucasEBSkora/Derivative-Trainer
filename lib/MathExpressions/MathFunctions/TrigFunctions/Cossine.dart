import 'package:dxart/MathExpressions/MathExpression.dart';
import 'package:dxart/MathExpressions/MathExpressions.dart';
import 'package:dxart/utils/Parentheses.dart';
import 'package:dxart/utils/ScaledText.dart';
import 'package:flutter/widgets.dart';

class Cos extends MathExpression {
  MathExpression expression;

  Cos(this.expression, [bool negative = false]) : super(negative);

  @override
  MathExpression derivative() {
    return -Sin(expression) * expression.derivative();
  }

  @override
  Widget toWidgetPrivate(
      {double scale = 1, bool showMinusSign = true, TextStyle style}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ScaledText(((negative) ? '-' : '') + 'cos', scale, style: style,),
        Parentheses(
            child: expression.toWidgetPrivate(scale: scale, style: style),
            scale: scale,
            textStyle: style),
      ],
    );
  }

  @override
  String toString() => 'cos(' + expression.toString() + ')';

  @override
  MathExpression opposite() {
    return Cos(this.expression, !this.negative);
  }

  @override
  MathExpression abs() {
    return Cos(this.expression, false);
  }
}
