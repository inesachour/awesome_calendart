import 'package:flutter/material.dart';

class AwesomeTheme {
  Color primaryColor;
  Color secondaryColor;
  Color backgroundColor;
  Color selectedDateColor;

  AwesomeTheme({
    this.primaryColor = const Color(0xFF4A5660),
    this.secondaryColor = const Color(0xFFB5BEC6),
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.selectedDateColor = const Color(0xFFF04D23),
  });
}

class LightTheme extends AwesomeTheme {}

class DarkTheme extends AwesomeTheme {
  Color primaryColor = const Color(0xFFFFFFFF);
  Color secondaryColor = const Color(0xFFB5BEC6);
  Color backgroundColor = const Color(0xFF464646);
  Color selectedDateColor = const Color(0xFFF04D23);
}
