import 'package:flutter/material.dart';

/// Class to define a customizable theme for a calendar (You can use predefined themes : [LightTheme] and [DarkTheme]).
class AwesomeTheme {
  /// The background color of the calendar.
  Color backgroundColor;

  /// The color of the year and month text.
  Color yearAndMonthColor;

  /// The color of the weekdays text.
  Color weekDaysColor;

  /// The color of the next and previous buttons in the calendar.
  Color buttonColor;

  /// The background color of a selected date.
  Color selectedDateBackgroundColor;

  /// The color of the selected day text.
  Color selectedDayColor;

  /// The color of the unselected days texts.
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
