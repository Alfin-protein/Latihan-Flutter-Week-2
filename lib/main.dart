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

  bool validateInputs(String operation) {
    if (_number1Controller.text.isEmpty) {
      setState(() {
        _status = 'Angka pertama tidak boleh kosong!';
      });
      return false;
    }
    double? num1 = double.tryParse(_number1Controller.text);
    if (num1 == null) {
      setState(() {
        _status = 'Angka pertama harus berupa angka valid!';
      });
      return false;
    }

    if (['+','-','*','/','%','^','% of'].contains(operation)) {
      if (_number2Controller.text.isEmpty) {
        setState(() {
          _status = 'Angka kedua tidak boleh kosong!';
        });
        return false;
      }
      double? num2 = double.tryParse(_number2Controller.text);
      if (num2 == null) {
        setState(() {
          _status = 'Angka kedua harus berupa angka valid';
        });
      }
    }
    return true;
  }

  void calculate(String operation) {
    double num1 = double.tryParse(_number1Controller.text) ?? 0;
    double num2 = double.tryParse(_number2Controller.text) ?? 0;

    setState(() {
      _lastNum1 = num1;
      _lastNum2 = num2;
      _lastResult = _result;
      _status = '';
      if (['+','-','*','/','%','^','% of'].contains(operation)) {
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
        } else if (operation == '% of') {
          _result = (num1 / num2) * 100;
        }
        if (_status == '') {
          _history.add('$num1 $operation $num2 = ${_result.toStringAsFixed(operation == '% of' ? 2 : 4)}${operation == '% of' ? '%' : ''}');
          if (_history.length > 5) _history.removeAt(0);
        }
      }
      if (['sin','cos','tan'].contains(operation)) {
        double radian = num1 * (2 * pi / 360);
        if (operation == 'sin') {
          _result = sin(radian);
        } else if (operation == 'cos') {
          _result = cos(radian);
        } else if (operation == 'tan') {
          _result = tan(radian);
        }
        _history.add('$operation($num1°) = ${_result.toStringAsFixed(4)}');
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

  // void clearAll() {
  //   setState(() {
  //     _number1Controller.clear();
  //     _number2Controller.clear();
  //     _result= 0;
  //     _history.clear();
  //     _status = '';
  //   });
  // }

  Widget buildButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 30,vertical: 30),
      ),
    );
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
            Expanded(
                child: ListView.builder(
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _history[index],
                                style: TextStyle(fontSize: 14),
                              )
                            ],
                        ),
                      );
                    }
                )
            ),
            SizedBox(height: 20),
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
            Text(
              _status,
              style: TextStyle(fontSize: 10),
            ),
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
                    labelText: 'Angka Kedua (kosongkan untuk trig)',
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0)
                ),
                keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 6,
              shrinkWrap: true,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                buildButton('+', Colors.blueGrey, () => calculate('+')),
                buildButton('-', Colors.blueGrey, () => calculate('-')),
                buildButton('x', Colors.blueGrey, () => calculate('*')),
                buildButton(':', Colors.blueGrey, () => calculate('/')),
                buildButton('%', Colors.blueAccent, () => calculate('%')),
                buildButton('^', Colors.blueAccent, () => calculate('^')),
                buildButton('% of', Colors.blueAccent, () => calculate('% of')),
                buildButton('sin', Colors.deepOrange, () => calculate('sin')),
                buildButton('cos', Colors.deepOrange, () => calculate('cos')),
                buildButton('tan', Colors.deepOrange, () => calculate('tan')),
                buildButton('Undo', Colors.teal, undo),
                buildButton('C', Colors.teal, clear),
              ],
            ),
          ],
        ),
      ),
    );
  }
}