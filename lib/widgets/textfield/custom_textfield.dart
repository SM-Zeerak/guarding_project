import 'package:flutter/material.dart';
import 'package:guarding_project/utils/Color%20Utils/color_utils.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final Color? color;
  final Color? borderColor;
  final Function(String)? onChanged;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.color = Colors.black,
    this.borderColor = Colors.grey,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onChanged,
      controller: widget.controller,
      obscureText: widget.isPassword && _isPasswordVisible,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: widget.color?.withOpacity(0.6)),
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: widget.color)
            : null,
        suffixIcon: widget.isPassword == true
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                child: Icon(
                  (!_isPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                  color: widget.color,
                ),
              )
            : InkWell(
                onTap: widget.onSuffixTap, child: Icon(widget.suffixIcon)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.borderColor ?? Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ClrUtils.primary, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        filled: true,
        fillColor: ClrUtils.surface,
      ),
      style: TextStyle(color: widget.color),
    );
  }
}
