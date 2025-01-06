import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final bool isLoading;
  final IconData? icon;
  final bool iconOnRight;
  final double? fontsize;
  final FontWeight? fontWeight;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.isLoading = false,
    this.icon,
    this.iconOnRight = false,
    this.fontsize,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null && !iconOnRight)
                    Icon(icon, color: textColor),
                  if (icon != null && !iconOnRight) const SizedBox(width: 8),
                  Text(
                    text,
                    style: TextStyle(
                      color: textColor ?? Colors.white,
                      fontSize: fontsize ?? 16,
                      fontWeight: fontWeight ?? FontWeight.bold,
                    ),
                  ),
                  if (icon != null && iconOnRight) const SizedBox(width: 8),
                  if (icon != null && iconOnRight) Icon(icon, color: textColor),
                ],
              ),
      ),
    );
  }
}
