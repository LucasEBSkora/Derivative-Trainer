import 'package:dxart/MathExpressions/MathExpression.dart';
import 'package:dxart/MathExpressions/MathExpressions.dart';

import 'package:dxart/utils/Parentheses.dart';
import 'package:flutter/widgets.dart';

class Exp extends MathExpression {
  MathExpression base;
  MathExpression exponent;

  Exp(this.base, this.exponent, [bool negative = false]) : super(negative);

  @override
  MathExpression derivative() {
    print(this * (Log.create(base) * exponent));
    return (this * ((Log.create(base) * exponent).derivative()));
  }

  @override
  Widget toWidgetPrivate(
      {double scale = 1, bool showMinusSign = true, TextStyle style}) {
    //in order to print the exponent as expected, uses CrossAxisAligment.start and makes the text for the exponent smaller

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Parentheses(
            child: base.toWidgetPrivate(scale: scale, style: style),
            scale: scale,
            textStyle: style,
            useParentheses: base.isOperator || base.negative,
            negative: negative),
        exponent.toWidgetPrivate(scale: scale * 0.7, style: style),
      ],
    );
  }

  @override
  String toString() => base.toString() + '^' + exponent.toString();

  @override
  MathExpression opposite() {
    return Exp(this.base, this.exponent, !negative);
  }

  @override
  MathExpression abs() {
    return Exp(this.base, this.exponent, false);
  }
}
