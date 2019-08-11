import 'dart:math';

class RandomValues {
  final Random _random;

  RandomValues({int seed}) : this._random = Random(seed);

  SimpleExpressionType generateSimpleExpressionType(bool allowNumbers) {
    int rand = _random.nextInt(10);
    if (allowNumbers && rand == 0)
      return SimpleExpressionType.number;
    else if (rand < 4)
      return SimpleExpressionType.variable;
    else
      return SimpleExpressionType.multipliedVariable;
  }

  ExpressionType generateExpressionType() {
    int rand = _random.nextInt(3);
    if (rand == 0)
      return ExpressionType.chainedOperations;
    else if (rand == 1)
      return ExpressionType.longComposition;
    else
      return ExpressionType.twoVariableFunction;
  }
}

enum ExpressionType { longComposition, chainedOperations, twoVariableFunction }

enum SimpleExpressionType { variable, number, multipliedVariable }
