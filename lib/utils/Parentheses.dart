import 'package:dxart/utils/ScaledText.dart';
import 'package:flutter/widgets.dart';

class Parentheses extends StatelessWidget {
  final Widget child;
  final double scale;
  final bool useParentheses;
  final bool negative;
  final TextStyle textStyle;

  const Parentheses(
      {Key key,
      @required this.child,
      @required this.scale,
      this.useParentheses = true,
      this.negative = false,
      this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return useParentheses
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ScaledText(
                ((negative) ? '-' : '') + '(',
                scale,
                style: textStyle,
              ),
              child,
              ScaledText(
                ')',
                scale,
                style: textStyle,
              ),
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ScaledText(
                (negative) ? '-' : '',
                scale,
                style: textStyle,
              ),
              child,
            ],
          );
  }
}
