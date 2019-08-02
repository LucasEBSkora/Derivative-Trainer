import 'package:dxart/MathExpressions/MathExpression.dart';
import 'package:dxart/MathExpressions/MathNumber.dart';
import 'package:dxart/utils/Parentheses.dart';
import 'package:dxart/utils/ScaledText.dart';
import 'package:flutter/widgets.dart';

//TODO: make logarithms take less space when printing

class Log extends MathExpression {
  MathExpression base;
  MathExpression antilogarithm;

  static MathExpression create(MathExpression antilogarithm,
      [MathExpression base = MathNumber.e, bool negative = false]) {
    if (antilogarithm is MathNumber && base is MathNumber) {
      if (antilogarithm.value == base.value) return MathNumber(1);
    }
    return Log._(antilogarithm, base, negative);
  }

  Log._(this.antilogarithm, [this.base = MathNumber.e, bool negative = false])
      : super(negative);

  @override
  MathExpression derivative() {
    if (base is MathNumber) {
      return antilogarithm.derivative() / (Log.create(base) * antilogarithm);
    }
    //if necessary, uses the change of base rule to simplify the derivative
    return (Log.create(antilogarithm) / Log.create(base)).derivative();
  }

  @override
  Widget toWidgetPrivate(
      {double scale = 1, bool showMinusSign = true, TextStyle style}) {
    //if it is a natural logarithm, prints only ln()
    if (base == MathNumber.e)
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ScaledText('ln', scale, negative: negative && showMinusSign, style: style,),
          Parentheses(
            child: antilogarithm.toWidgetPrivate(scale: scale, style: style),
            scale: scale,
            textStyle: style,
          ),
        ],
      );
    //if it has another base, prints it as column. This, unfortunately, makes it take up too much vertical space
    else
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.ideographic,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Baseline(
            baselineType: TextBaseline.ideographic,
            baseline: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ScaledText(
                  'log',
                  scale,
                  negative: negative && showMinusSign,
                  style: style,
                ),
                base.toWidgetPrivate(scale: scale * 0.7, style: style),
              ],
            ),
          ),
          Baseline(
              baselineType: TextBaseline.ideographic,
              baseline: 0,
              child: Parentheses(
                child:
                    antilogarithm.toWidgetPrivate(scale: scale, style: style),
                scale: scale,
                textStyle: style,
              )),
        ],
      );
  }

  @override
  String toString() =>
      'log(' + base.toString() + ')(' + antilogarithm.toString() + ')';

  @override
  MathExpression opposite() {
    return Log.create(this.antilogarithm, this.base, !negative);
  }

  @override
  MathExpression abs() {
    return Log.create(this.antilogarithm, this.base, false);
  }
}
