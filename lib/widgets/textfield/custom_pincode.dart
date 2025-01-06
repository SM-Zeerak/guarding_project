import 'package:flutter/material.dart';

class CustomPinCodeTextField extends StatefulWidget {
  final Function(String) onPinChanged;  // Callback parameter

  // Constructor to accept the callback
  const CustomPinCodeTextField({Key? key, required this.onPinChanged}) : super(key: key);

  @override
  _CustomPinCodeTextFieldState createState() => _CustomPinCodeTextFieldState();
}

class _CustomPinCodeTextFieldState extends State<CustomPinCodeTextField> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          width: 50,
          height: 60,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            obscureText: true,  // Text hidden (like a password field)
            keyboardType: TextInputType.number,
            maxLength: 1,  // Limit each field to 1 digit
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (value.length == 1 && index < 3) {
                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
              }

              // Call onPinChanged when a value is entered
              widget.onPinChanged(_controllers.map((e) => e.text).join());
            },
          ),
        );
      }),
    );
  }
}
