import 'package:dxart/MathExpressions/MathExpression.dart';
import 'package:dxart/utils/ScaledText.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as core;

//Wrapper for numbers that allows for named constants
class MathNumber extends MathExpression {
  static const MathNumber e = MathNumber.constant(core.e, 'e');
  static const MathNumber pi = MathNumber.constant(core.pi, '\u{03c0}');

  final num value;
  final String name;

  //defines named constants
  const MathNumber.constant(this.value, this.name, [bool negative = false])
      : super.constant(negative);

  //for normal numbers, the name of the number is the standard string representation of it
  // - MathNumber(<number>) is equivalent to MathNumber(-<number>), but the minus inside is slightly more efficient
  MathNumber(num value)
      : this.value = value.abs(),
        name = value.abs().toString(),
        super(value.isNegative);

  @override
  MathExpression derivative() {
    return MathNumber(0);
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
    return MathNumber((negative) ? value : -value);
  }

  @override
  MathExpression abs() {
    return MathNumber(value.abs());
  }
}
