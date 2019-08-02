import 'package:dxart/MathExpressions/MathExpression.dart';

abstract class MathOperator extends MathExpression {
  MathOperator([bool negative]) : super(negative);
}
