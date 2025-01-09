import 'package:flutter/material.dart';
import 'package:guarding_project/utils/color_utils.dart';
import 'package:guarding_project/utils/textStyle_utils.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double borderRadius;
  final double elevation;
  final double fontSize;
  final double height;
  final double width;
  final FontWeight? fontWeight;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = ClrUtls.blue,
    this.textColor = Colors.white,
    this.borderRadius = 10.0,
    this.elevation = 0,
    this.fontSize = 16.0,
    this.height = 45,
    this.width = double.infinity,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width, height),
        minimumSize:Size(width, height),
        padding: EdgeInsets.zero,
        foregroundColor: textColor,
        backgroundColor: color,
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(
        text,
        style: TextStylesUtils.custom(
            fontSize: fontSize, color: textColor, fontWeight: fontWeight ?? FontWeight.normal),
      ),
    );
  }
}
