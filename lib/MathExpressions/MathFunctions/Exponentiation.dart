import 'package:dxart/MathExpressions/MathExpression.dart';
import 'package:dxart/MathExpressions/MathExpressions.dart';

import 'package:dxart/utils/Parentheses.dart';
import 'package:flutter/widgets.dart';

class Exp extends MathExpression {
  MathExpression base;
  MathExpression exponent;

  Exp._(this.base, this.exponent, [bool negative = false]) : super(negative);

  static MathExpression create(MathExpression base, MathExpression exponent, [bool negative = false]) {
    if (base is Exp) {
      return Exp.create(base.base, base.exponent* exponent);
    }

    return Exp._(base, exponent, negative);
  }
  @override
  MathExpression derivative() {
    return (this * ((Log.create(base) * exponent).derivative()));
  }
  @override
  Widget toWidgetPrivate(
      {double scale = 1.0, bool showMinusSign = true, TextStyle style}) {
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
            negative: negative && showMinusSign),
        exponent.toWidgetPrivate(scale: scale * 0.7, style: style),
      ],
    );
  }

  @override
  String toString() => '(' + base.toString() + '^' + exponent.toString() + ')';

  @override
  MathExpression opposite() {
    return Exp._(this.base, this.exponent, !negative);
  }

  @override
  MathExpression abs() {
    return Exp._(this.base, this.exponent, false);
  }
}
