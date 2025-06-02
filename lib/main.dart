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

  List<String> _history = [];
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
      _history.add('$num1 $operation $num2'
          '= $_result');
      if (_history.length > 5) _history.removeAt(0);
    });
  }

  void clear() {
    setState(() {
      _number1Controller.clear();
      _number2Controller.clear();
      _result= 0;
    });
  }

  void clearAll() {
    setState(() {
      _number1Controller.clear();
      _number2Controller.clear();
      _result= 0;
      _history.clear();
    });
  }

  @override
  Widget build(BuildContext Context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kalkulator Sederhana"),
        backgroundColor: Colors.white24,
      ),
      backgroundColor: Colors.white70,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _history.isNotEmpty
                ? Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _history.length,
                itemBuilder: (BuildContext context, int index) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _history[index],
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  );
                },
              ),
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
                    child: Text('Clear All'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                    )
                  )
                ],
            ),
          ],
        ),
      ),
    );
  }
}