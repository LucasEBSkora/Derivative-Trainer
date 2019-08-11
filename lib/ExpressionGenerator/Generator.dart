import 'dart:math';

import 'package:dxart/ExpressionGenerator/ExpressionGenerator.dart';
import 'package:dxart/ExpressionGenerator/RandomValues.dart';
import 'package:dxart/MathExpressions/MathExpressions.dart';

class ExpressionGenerator {
  ExpressionGeneratorSettings settings;

  ExpressionGenerator({this.settings});

  static Map<int, MathExpression Function(MathExpression expression)>
      singleVariableFunctions = {
    0: (MathExpression expression) => Sin(expression),
    1: (MathExpression expression) => Cos(expression),
    2: (MathExpression expression) => Log.create(expression),
    3: (MathExpression expression) => Exp.create(MathNumber.e, expression),
    4: (MathExpression expression) =>
        Exp.create(expression, MathNumber(Random().nextInt(4) + 2)),
  };

  static Map<int,
          MathExpression Function(MathExpression first, MathExpression second)>
      twoVariableFunctions = {
    0: (MathExpression first, MathExpression second) =>
        Division.create([first], [second]),
    1: (MathExpression first, MathExpression second) => Exp.create(first, second),
    2: (MathExpression first, MathExpression second) =>
        Log.create(first, second),
  };

  static Map<int, MathExpression Function(List<MathExpression> list)>
      chainedOperations = {
    0: (List<MathExpression> list) => Sum.create(list),
    1: (List<MathExpression> list) => Multiplication.create(list),
  };

  MathExpression _generateVariable(bool allowNumbers) {
    SimpleExpressionType type =
        RandomValues().generateSimpleExpressionType(allowNumbers);
    MathExpression exp;
    if (type == SimpleExpressionType.number)
      exp = MathNumber(Random().nextInt(10) + 1);
    else if (type == SimpleExpressionType.variable)
      exp = MathVariable.x;
    else
      exp = MathNumber(Random().nextInt(10) + 1) * MathVariable.x;

    return exp;
  }

  MathExpression _generateLongComposition(int size) {
    MathExpression exp = _generateVariable(false);

    for (int i = 1; i < size; ++i) {
      print(exp);
      exp = singleVariableFunctions[
          Random().nextInt(singleVariableFunctions.length)](exp);
    }
    return exp;
  }

  MathExpression generateTwoVariableFunction(int size) {
    int sizeFirst = Random().nextInt(size - 1) + 1;
    print('size: $size sizeFirst: $sizeFirst');
    var first = _generateLongComposition(sizeFirst);
    var second = _generateLongComposition(size - sizeFirst);
    print('first: $first');
    print('second: $second');
    return twoVariableFunctions[Random().nextInt(twoVariableFunctions.length)](
        first, second);
  }

  MathExpression _generateChainedOperations(int size) {
    int length = Random().nextInt((size / 2).floor()) + 1;

    int remainingSize = size;

    List<int> lengths = List<int>.generate(length, (int i) {
      int opSize = Random().nextInt(remainingSize - (length - i) + 1) + 1;

      remainingSize -= opSize;
      return opSize;
    });
    List<MathExpression> operands =
        List<MathExpression>.generate(length, (int i) {
      var exp = _generateLongComposition(lengths[i]);

      return exp;
    });
    MathExpression exp =
        chainedOperations[Random().nextInt(chainedOperations.length)](operands);

    return exp;
  }

  MathExpression generateExpression(int size) {
    if (size <= 1) return _generateVariable(false);
    MathExpression exp;

    ExpressionType type = RandomValues().generateExpressionType();

    if (type == ExpressionType.longComposition) {
      exp = _generateLongComposition(size);
    } else if (type == ExpressionType.chainedOperations) {
      exp = _generateChainedOperations(size);
    } else
      // exp = _generateVariable(false);
      exp = generateTwoVariableFunction(size);

    return exp;
  }

  List<MathExpression> generateExpressions(int size) {
    List<MathExpression> expressions = List<MathExpression>.generate(
        size, (i) => generateExpression(Random().nextInt(5) + 3));
    return expressions;
  }
}
