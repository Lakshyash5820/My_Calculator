import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.black,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ).apply(bodyColor: Colors.white),
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _output = "0";
  String _currentNumber = "0";
  double _previousNumber = 0.0;
  String _operator = "";
  bool _isNewNumber = true;

  void _onButtonPressed(String buttonText) {
    setState(() {
      // Clear button
      if (buttonText == "C") {
        _output = "0";
        _currentNumber = "0";
        _previousNumber = 0.0;
        _operator = "";
        _isNewNumber = true;
      }
      // Backspace button
      else if (buttonText == "⌫") {
        if (_currentNumber.length > 1) {
          _currentNumber = _currentNumber.substring(0, _currentNumber.length - 1);
        } else {
          _currentNumber = "0";
        }
        _output = _currentNumber;
      }
      // Operator buttons (+, -, ×, ÷, =)
      else if (buttonText == "+" ||
          buttonText == "-" ||
          buttonText == "×" ||
          buttonText == "÷" ||
          buttonText == "=") {
        // If there's already an operator, calculate the result
        if (_operator.isNotEmpty) {
          double num2 = double.tryParse(_currentNumber) ?? 0.0;
          double result = 0.0;

          if (_operator == "+") {
            result = _previousNumber + num2;
          } else if (_operator == "-") {
            result = _previousNumber - num2;
          } else if (_operator == "×") {
            result = _previousNumber * num2;
          } else if (_operator == "÷") {
            if (num2 != 0) {
              result = _previousNumber / num2;
            } else {
              _output = "Error";
              _currentNumber = "0";
              _previousNumber = 0.0;
              _operator = "";
              _isNewNumber = true;
              return; // Stop execution to prevent further errors
            }
          }
          _output = result.toString();
          // Remove trailing '.0' for whole numbers
          if (_output.endsWith(".0")) {
            _output = _output.substring(0, _output.length - 2);
          }
          _currentNumber = _output; // The result becomes the new current number
          _previousNumber = result; // Store the result for the next operation
        } else {
          // No operator yet, store the first number
          _previousNumber = double.tryParse(_currentNumber) ?? 0.0;
        }
        _operator = buttonText == "=" ? "" : buttonText; // Clear operator on equals
        _isNewNumber = true;
        
        // This is the fix for the operator not showing up
        if(buttonText != "=" && _output != "Error") {
          _output = '$_output $_operator';
        }
      }
      // Number and decimal buttons
      else {
        if (_isNewNumber) {
          _currentNumber = buttonText;
          _isNewNumber = false;
        } else {
          // Prevent multiple decimal points
          if (buttonText == "." && _currentNumber.contains(".")) {
            return;
          }
          _currentNumber += buttonText;
        }
        _output = _currentNumber;
      }
    });
  }

  Widget _buildButton(String buttonText, Color color, [Color textColor = Colors.white]) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
          onPressed: () => _onButtonPressed(buttonText),
          child: Text(
            buttonText,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions to make the UI responsive
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Display area with dynamic font size
            Expanded(
              flex: (screenHeight * 0.3).toInt(), // Adjust flex based on screen size
              child: Container(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03, horizontal: screenWidth * 0.05),
                alignment: Alignment.bottomRight,
                child: Text(
                  _output,
                  style: GoogleFonts.poppins(
                    fontSize: screenHeight * 0.09, // Font size scales with height
                    fontWeight: FontWeight.w300,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const Divider(color: Colors.white12, height: 1),
            // Button area with dynamic sizing
            Expanded(
              flex: (screenHeight * 0.7).toInt(), // Adjust flex for button panel
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildButton("C", const Color(0xFF616161)),
                      _buildButton("⌫", const Color(0xFF616161)),
                      _buildButton("÷", Colors.deepOrange),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton("7", const Color(0xFF424242)),
                      _buildButton("8", const Color(0xFF424242)),
                      _buildButton("9", const Color(0xFF424242)),
                      _buildButton("×", Colors.deepOrange),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton("4", const Color(0xFF424242)),
                      _buildButton("5", const Color(0xFF424242)),
                      _buildButton("6", const Color(0xFF424242)),
                      _buildButton("-", Colors.deepOrange),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton("1", const Color(0xFF424242)),
                      _buildButton("2", const Color(0xFF424242)),
                      _buildButton("3", const Color(0xFF424242)),
                      _buildButton("+", Colors.deepOrange),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton("0", const Color(0xFF424242)),
                      _buildButton(".", const Color(0xFF424242)),
                      _buildButton("=", Colors.deepOrange),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
