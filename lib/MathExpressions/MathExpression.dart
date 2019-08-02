import 'package:dxart/MathExpressions/MathExpressions.dart';
import 'package:dxart/MathExpressions/MathOperators/MathOperator.dart';
import 'package:dxart/MathExpressions/MathOperators/MathOperators.dart';
import 'package:flutter/widgets.dart';

//TODO: better (shorter) names for the classes
//TODO: Properly implement Roots

abstract class MathExpression {
  //whether the expression is multiplied by -1 or not
  final bool negative;

  Widget toWidget({TextStyle style, @required BuildContext context}) {

    print(style);
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle effectiveTextStyle = style;
    if (style == null || style.inherit)
      effectiveTextStyle = defaultTextStyle.style.merge(style);
    return this.toWidgetPrivate(scale: 1, showMinusSign: true, style: effectiveTextStyle);
  }

  //returns the expression written as a widget.
  //should not be called directly.
  // scale is used to tell child widgets whether they should be smaller
  //(the base of a logarithm or an exponent, for example),
  //and showMinusSign is used when a parent expression should handle showing the minus sign (basically only sum).
  //neither of them should actually be used by the user.

  //TODO: make it private while allowing the child classes to use it
  Widget toWidgetPrivate({double scale, bool showMinusSign, TextStyle style});

  //returns the derivative (in relation to x, for now) of the function
  MathExpression derivative();

  //returns, in essence, '-this'
  MathExpression opposite();

  //returns |this|
  MathExpression abs();

  const MathExpression.constant([this.negative = false]);

  MathExpression([this.negative = false]);

  bool get isOperator => (this is MathOperator);

  MathExpression operator +(MathExpression other) => Sum.create([this, other]);

  MathExpression operator -(MathExpression other) => Sum.create([this, -other]);

  MathExpression operator *(MathExpression other) =>
      Multiplication.create([this, other]);

  MathExpression operator /(MathExpression other) =>
      Division.create([this], [other]);

  MathExpression operator -() {
    return this.opposite();
  }
}
