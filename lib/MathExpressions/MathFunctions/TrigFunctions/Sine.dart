import 'package:dxart/MathExpressions/MathExpression.dart';
import 'package:dxart/MathExpressions/MathFunctions/TrigFunctions/Cossine.dart';
import 'package:dxart/utils/Parentheses.dart';
import 'package:dxart/utils/ScaledText.dart';
import 'package:flutter/widgets.dart';

class Sin extends MathExpression {
  MathExpression expression;

  Sin(this.expression, [bool negative = false]) : super(negative);

  @override
  MathExpression derivative() {
    return Cos(expression) * expression.derivative();
  }

  @override
  Widget toWidgetPrivate(
      {double scale = 1, bool showMinusSign = true, TextStyle style}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ScaledText('sin', scale, negative: showMinusSign && negative, style: style,),
        Parentheses(
            child: expression.toWidgetPrivate(scale: scale, style: style),
            scale: scale,
            textStyle: style),
      ],
    );
  }

  @override
  String toString() {
    return 'sin(' + expression.toString() + ')';
  }

  @override
  MathExpression opposite() {
    return Sin(this.expression, !this.negative);
  }

  @override
  MathExpression abs() {
    return Sin(this.expression, false);
  }
}
