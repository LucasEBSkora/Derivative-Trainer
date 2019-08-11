import 'package:dxart/ExpressionGenerator/ExpressionGenerator.dart';
import 'package:dxart/MathExpressions/MathExpressions.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MathExpression exp = ExpressionGenerator().generateTwoVariableFunction(5);
  final List<MathExpression> _expressions =
      ExpressionGenerator().generateExpressions(10);

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(
      fontSize: 15,
    );

    // print('exp: $exp');
    // print('derivative: ${exp.derivative()}');

    var fuck = MathVariable.x / MathNumber(2);
    print('fuck: $fuck');
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
                exp.toWidget(style: style),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: exp.derivative().toWidget(style: style)),
                RaisedButton(
                  child: Text('new expression'),
                  onPressed: () {
                    setState(() {
                      exp = ExpressionGenerator().generateExpression(5);
                    });
                  },
                ),
              fuck.toWidget(style: style),
              fuck.derivative().toWidget(style: style),
            ],
          ),
          // child: ListView.builder(
          //   itemBuilder: (BuildContext context, int i) {
          //     if (i % 2 == 1) return Divider();
          //     if (i / 2 >= _expressions.length)
          //       _expressions
          //           .addAll(ExpressionGenerator().generateExpressions(10));

          //     return Column(
          //       children: <Widget>[
          //         SingleChildScrollView(
          //           scrollDirection: Axis.horizontal,
          //           child: _expressions[(i / 2).floor()].toWidget(style: style),
          //         ),
          //         SingleChildScrollView(
          //             scrollDirection: Axis.horizontal,
          //             child: _expressions[(i / 2).floor()]
          //                 .derivative()
          //                 .toWidget(style: style)),
          //       ],
          //     );
          //   },
          // ),
        ),
      ),
    );
  }
}
