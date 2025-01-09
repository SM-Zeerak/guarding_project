import 'package:flutter/material.dart';
import 'package:guarding_project/utils/color_utils.dart';
import 'package:guarding_project/utils/textStyle_utils.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final double? fontsize;
  final double? width;
  final double height; // Set height directly for the TextField
  final bool? isObscure;
  final bool? isPass;
  final String? label;
  final String? fontfamily;
  final String hintText;
  final Function()? onTapIcon;
  final Color borderColor;
  final Color labelColor;
  final double labelSize;
  final bool enable;
  final bool readOnly;
  final Color? hintColor;
  final Function()? onTap;
  final Widget? suffixIcon;
  final BorderRadius? borderRadius;
  final int? maxlines;

  final bool isDropdown; // Add this parameter to decide if it's a dropdown or text field
  final String? selectedCategory; // The selected category for dropdown

  const CustomTextField({
    super.key,
    this.controller,
    this.width,
    this.height = 54, // Height is now a required parameter
    this.isPass = false,
    this.isObscure,
    required this.hintText,
    this.onTapIcon,
    this.label,
    this.enable = true,
    this.readOnly = false,
    this.labelSize = 14,
    this.borderColor = Colors.white,
    this.labelColor = Colors.white,
    this.onTap,
    this.fontsize,
    this.fontfamily,
    this.hintColor,
    this.borderRadius,
    this.suffixIcon,
    this.maxlines,
    this.isDropdown = false, // Default to false, meaning it won't be a dropdown by default
    this.selectedCategory, // Default selected category
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isPasswordVisible = false; 
  String? _currentCategory; 

  @override
  void initState() {
    super.initState();
    _currentCategory = widget.selectedCategory; 
    if (widget.controller != null && _currentCategory != null) {
      widget.controller?.text = _currentCategory!; // Set the initial text if a selected category is provided
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), 
            offset: Offset(0, 4), 
            blurRadius: 6, 
            spreadRadius: 1, 
          ),
        ],
      ),
      child: widget.isDropdown
          ? _buildDropdown() // If isDropdown is true, show dropdown
          : _buildTextField(), // Otherwise, show regular text field
    );
  }

  // Method to build dropdown
  Widget _buildDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(15),
        border: Border.all(color: widget.borderColor, width: 2),
      ),
      child: DropdownButton<String>(
        value: _currentCategory,
        isExpanded: true,
        onChanged: (String? newValue) {
          setState(() {
            _currentCategory = newValue;
            if (widget.controller != null && newValue != null) {
              widget.controller?.text = newValue; // Update the controller text with the selected value
            }
          });
        },
        items: ['Baby', 'Maternity'] // Static list of dropdown options
            .map<DropdownMenuItem<String>>((String category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(
              category,
              style: TextStylesUtils.custom(color: Colors.black, fontSize: 14),
            ),
          );
        }).toList(),
        style: TextStyle(color: Colors.black, fontSize: widget.fontsize ?? 14),
        underline: Container(), // Remove default underline of dropdown
        icon: Icon(Icons.arrow_drop_down, color: ClrUtls.grey),
        hint: Text(
          widget.hintText,
          style: TextStyle(
            color: widget.hintColor ?? Colors.grey.shade400,
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // Method to build regular text field
  Widget _buildTextField() {
    return TextField(
      style: TextStylesUtils.custom(
        color: Colors.black,
        fontSize: widget.fontsize ?? 14,
      ),
      maxLines: widget.isPass == true ? 1 : widget.maxlines,
      readOnly: widget.readOnly,
      controller: widget.controller,
      onTap: widget.onTap,
      obscureText: widget.isPass == true
          ? !_isPasswordVisible
          : (widget.isObscure ?? false),
      decoration: InputDecoration(
        constraints: BoxConstraints(
          maxWidth: widget.width ?? double.infinity,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
          borderSide: BorderSide(color: widget.borderColor),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: widget.label,
        labelStyle: TextStyle(color: widget.labelColor, fontSize: widget.labelSize),
        suffixIcon: widget.isPass == true
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: ClrUtls.grey,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : widget.suffixIcon,
        contentPadding: EdgeInsets.symmetric(vertical: (widget.height - 24) / 2, horizontal: 16),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: widget.hintColor ?? Colors.grey.shade400,
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
        enabled: widget.enable,
        disabledBorder: OutlineInputBorder(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(15),
          borderSide: BorderSide(color: widget.borderColor, width: 2),
        ),
        fillColor: ClrUtls.white,
        filled: true,
      ),
    );
  }
}
