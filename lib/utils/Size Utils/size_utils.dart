// utils/sizes.dart
import 'package:flutter/material.dart';

class Sizes {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  static const double fontSmall = 12.0;
  static const double fontMedium = 16.0;
  static const double fontLarge = 20.0;

  static const double buttonHeight = 50.0;
  static const double borderRadius = 8.0;
}

// For responsive sizes based on screen width and height
double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

double responsiveWidth(BuildContext context, double percentage) =>
    screenWidth(context) * (percentage / 100);
double responsiveHeight(BuildContext context, double percentage) =>
    screenHeight(context) * (percentage / 100);
