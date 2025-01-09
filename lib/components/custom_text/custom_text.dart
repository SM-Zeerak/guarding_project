import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final int? maxLines;
  final TextOverflow overflow;
  final String? googleFontName;

  const CustomText(
    this.text, {
    Key? key,
    this.fontSize = 16.0,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.googleFontName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = googleFontName != null && googleFontName!.isNotEmpty
        ? GoogleFonts.getFont(
            googleFontName!,
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
          )
        : TextStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
          );

    return Text(
      text,
      style: textStyle,
      // textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
