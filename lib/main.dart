import 'package:flutter/material.dart';

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

  void calculate(String operation) {
    double num1 = double.tryParse(_number1Controller.text) ?? 0;
    double num2 = double.tryParse(_number2Controller.text) ?? 0;

    setState(() {
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Pembagian dengan nol tidak diperbolehkan!')),
          );
        }
      }
    });
  }


  @override
  Widget build(BuildContext Context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kalkulator Sederhana"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            SizedBox(height: 20),
            Text(
              'Hasil: $_result',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}