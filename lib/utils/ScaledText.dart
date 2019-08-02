import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ScaledText extends StatelessWidget {
  final String text;
  final double scale;
  final bool negative;
  final TextStyle style;

  ScaledText(this.text, this.scale, {this.style, this.negative = false});

  @override
  Widget build(BuildContext context) {


    return Text(
      (negative ? '-' : '') + text,
      style: style.copyWith(fontSize: style.fontSize * scale),
    );
  }
}
