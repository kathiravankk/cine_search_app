import 'package:flutter/material.dart';

class AppThemeManager{

  static const  Color backGroundColor = Color.fromRGBO(31, 30, 42, 1);
  static const  Color fieldColor = Color.fromRGBO(42, 56, 72, 1);
  static const  Color hintColor = Colors.white24;
  static const  Color primaryColor = Colors.white;

  static String defaultFont = 'Lato';

  static TextStyle customTextStyleWithSize({
    required double size,
    FontWeight weight = FontWeight.normal,
    Color? color,
    double lineSpace = 1.0,
    bool isUnderlined = false,
    Color? underlineColor,
    double underlineThickness = 1.0,
  }) {
    return TextStyle(
      fontFamily: AppThemeManager.defaultFont,
      height: lineSpace,
      color: color ?? Colors.white,
      fontWeight: weight,
      fontSize: size,
      decoration: isUnderlined ? TextDecoration.underline : TextDecoration.none,
      decorationColor: underlineColor,
      decorationThickness: underlineThickness,
    );
  }
}