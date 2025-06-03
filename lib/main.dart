import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorApp(),
    );
  }
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  final TextEditingController _number1Controller = TextEditingController();
  final TextEditingController _number2Controller = TextEditingController();
  double _result = 0;
  List<String> _history = [];
  String _status = '';
  double _lastNum1 = 0;
  double _lastNum2 = 0;
  double _lastResult = 0;

  void calculate(String operation) {
    double num1 = double.tryParse(_number1Controller.text) ?? 0;
    double num2 = double.tryParse(_number2Controller.text) ?? 0;

    setState(() {
      _lastNum1 = num1;
      _lastNum2 = num2;
      _lastResult = _result;

      _status = '';
      if (operation == '+') {
        _result = num1 + num2;
      } else if (operation == '-') {
        _result = num1 - num2;
      } else if (operation == '*') {
        _result = num1 * num2;
      } else if (operation == '/') {
        if (num2 != 0) {
          _result = num1 / num2;
        } else {
          _result = 0;
          _status = 'Pembagian dengan nol tidak diperbolehkan!';
        }
      } else if (operation == '%') {
        _result = num1 % num2;
      } else if (operation == '^') {
        _result = pow(num1, num2).toDouble();
      }
      if (_status == '') {
        _history.add('$num1 $operation $num2 = $_result');
        if (_history.length > 5) _history.removeAt(0);
      }
    });
  }

  void undo() {
    setState(() {
      if (_history.isNotEmpty) {
        _history.removeLast();
        _number1Controller.text = _lastNum1.toString();
        _number2Controller.text = _lastNum2.toString();
        _result = _lastResult;
        _status = 'Operasi Terakhir Dibatalkan';
      } else {
        _status = 'Tidak ada operasi untuk di batalkan';
      }
    });
  }

  void clear() {
    setState(() {
      _number1Controller.clear();
      _number2Controller.clear();
      _result= 0;
      _status = '';
    });
  }

  void clearAll() {
    setState(() {
      _number1Controller.clear();
      _number2Controller.clear();
      _result= 0;
      _history.clear();
      _status = '';
    });
  }

  @override
  Widget build(BuildContext Context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kalkulator Sederhana"),
        backgroundColor: Colors.tealAccent,
      ),
      backgroundColor: Colors.cyan,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _history.isNotEmpty
            ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: _history.map((item) => Text(item)).toList(),
            )
            : SizedBox(),
            SizedBox(height: 20),
            _result !=0
            ? Text(
              '= $_result'
            )
            : SizedBox(),
            TextField(
              controller: _number1Controller,
              decoration: InputDecoration(
                  labelText: 'Angka Pertama',
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0)
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
                controller: _number2Controller,
                decoration: InputDecoration(
                    labelText: 'Angka Kedua',
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0)
                ),
                keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => calculate('+'),
                    child: Text('+'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => calculate('-'),
                    child: Text('-'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => calculate('*'),
                    child: Text('x'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => calculate('/'),
                    child: Text(':'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => calculate('%'),
                  child: Text('%'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => calculate('^'),
                  child: Text('^'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: undo,
                  child: Text('Undo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: clear,
                  child: Text('Clear'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton(
                    onPressed: clearAll,
                    child: Text('ClearAll'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                    )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}