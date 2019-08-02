import 'package:dxart/MathExpressions/MathExpressions.dart';
import 'package:dxart/utils/ScaledText.dart';
import 'package:flutter/widgets.dart';

//class that represents a variable.
//as of now, since the program always doesn't identify variables as different, the derivative is always 1
class MathVariable extends MathExpression {
  static const MathVariable x = const MathVariable.constant('x');

  final String name;

  const MathVariable.constant(this.name, [bool negative = false])
      : super.constant(negative);

  MathVariable(this.name, [bool negative = false]) : super(negative = negative);

  @override
  MathExpression derivative() {
    return MathNumber(1);
  }

  @override
  Widget toWidgetPrivate(
          {double scale = 1, bool showMinusSign = true, TextStyle style}) =>
      ScaledText(
        name,
        scale,
        negative: showMinusSign && negative,
        style: style,
      );

  @override
  String toString() => name;

  @override
  MathExpression opposite() {
    return MathVariable(name, !negative);
  }

  @override
  MathExpression abs() {
    return MathVariable(name, false);
  }
}
