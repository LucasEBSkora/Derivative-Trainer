import 'package:dxart/MathExpressions/MathExpressions.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(
      color: Colors.red,
      
      fontSize: 25,
    );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Exp(MathNumber.e, MathVariable.x)
                  .toWidget(style: style, context: context),
              Exp(MathVariable.x, MathVariable.x)
                  .derivative()
                  .toWidget(style: style, context: context),
              ((Exp(-MathVariable.x, MathNumber(2)) *
                          -Log.create(MathVariable.x)) +
                      MathNumber(-2))
                  .toWidget(style: style, context: context),
              (MathVariable.x + MathNumber(2) + (-Sin(MathVariable.x)))
                  .toWidget(style: style, context: context),
              SizedBox(
                height: 50,
              ),
              ((MathNumber(1) + MathVariable.x) /
                      MathVariable('f') *
                      MathVariable.x *
                      MathNumber(2) *
                      Log.create(
                          MathVariable.x, Exp(MathVariable.x, MathNumber(2))))
                  .toWidget(style: style, context: context),
              (MathVariable.x / MathNumber(2))
                  .toWidget(style: style, context: context),
              (MathVariable.x * MathNumber(2))
                  .toWidget(style: style, context: context),
              Log.create(MathVariable.x, MathVariable.x + MathNumber(2))
                  .derivative()
                  .toWidget(style: style, context: context),
              (MathVariable.x *
                      MathNumber(2) *
                      (MathNumber(1) / Log.create(MathVariable.x)))
                  .toWidget(style: style, context: context),
            ],
          ),
        ),
      ),
    );
  }
}
