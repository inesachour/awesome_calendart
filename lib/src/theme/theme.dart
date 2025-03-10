import 'package:flutter/material.dart';

class AwesomeTheme {
  Color backgroundColor;
  Color yearAndMonthColor;
  Color weekDaysColor;
  Color buttonColor;
  Color selectedDateBackgroundColor;
  Color selectedDayColor;
  Color unselectedDayColor;

  AwesomeTheme({
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.yearAndMonthColor = const Color(0xFF4A5660),
    this.weekDaysColor = const Color(0xFFB5BEC6),
    this.buttonColor = const Color(0xFF4A5660),
    this.selectedDateBackgroundColor = const Color(0xFFF04D23),
    this.selectedDayColor = Colors.white,
    this.unselectedDayColor = const Color(0xFF4A5660),
  });
}

class LightTheme extends AwesomeTheme {}

class DarkTheme extends AwesomeTheme {
  Color backgroundColor = const Color(0xFF464646);
  Color yearAndMonthColor = const Color(0xFFFFFFFF);
  Color weekDaysColor = const Color(0xFFB5BEC6);
  Color buttonColor = const Color(0xFFFFFFFF);
  Color unselectedDayColor = const Color(0xFFFFFFFF);
}
