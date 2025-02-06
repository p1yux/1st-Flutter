import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = "";

  void _onButtonPressed(String value) {
    setState(() {
      if (value == "C") {
        _expression = "";
      } else if (value == "=") {
        try {
          _expression = _evaluateExpression(_expression);
        } catch (e) {
          _expression = "Error";
        }
      } else {
        _expression += value;
      }
    });
  }

  String _evaluateExpression(String expr) {
    if (expr.isEmpty) return "0";
    try {
      final normalizedExpr = expr.replaceAll('×', '*').replaceAll('÷', '/');
      List<String> numbers = normalizedExpr.split(RegExp(r'[+\-*/]'));
      List<String> operators = normalizedExpr
          .split(RegExp(r'[0-9.]+'))
          .where((e) => e.isNotEmpty)
          .toList();

      if (numbers.isEmpty) return "0";

      double result = double.parse(numbers[0]);
      for (int i = 0; i < operators.length; i++) {
        double nextNumber = double.parse(numbers[i + 1]);
        switch (operators[i]) {
          case '+':
            result += nextNumber;
            break;
          case '-':
            result -= nextNumber;
            break;
          case '*':
            result *= nextNumber;
            break;
          case '/':
            if (nextNumber == 0) throw Exception('Division by zero');
            result /= nextNumber;
            break;
        }
      }

      // Format the result to remove unnecessary decimal places
      if (result == result.roundToDouble()) {
        return result.toInt().toString();
      }
      return result.toString();
    } catch (e) {
      return "Error";
    }
  }

  Widget _buildButton(String text) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => _onButtonPressed(text),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(text, style: TextStyle(fontSize: 24)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculator")),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(20),
              child: Text(
                _expression,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Column(
            children: [
              Row(children: [
                _buildButton("7"),
                _buildButton("8"),
                _buildButton("9"),
                _buildButton("÷")
              ]),
              Row(children: [
                _buildButton("4"),
                _buildButton("5"),
                _buildButton("6"),
                _buildButton("×")
              ]),
              Row(children: [
                _buildButton("1"),
                _buildButton("2"),
                _buildButton("3"),
                _buildButton("-")
              ]),
              Row(children: [
                _buildButton("C"),
                _buildButton("0"),
                _buildButton("="),
                _buildButton("+")
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
