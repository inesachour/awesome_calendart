import 'package:flutter/material.dart';

/// Class to define a customizable theme for a calendar (You can use predefined themes : [LightTheme] and [DarkTheme]).
class AwesomeTheme {
  /// The background color of the calendar.
  Color backgroundColor;

  /// The color of the next and previous buttons in the calendar.
  Color buttonColor;

  /// The color of the year and month header text (Days List View).
  TextStyle yearAndMonthHeaderTextStyle;

  /// The color of the weekdays text (Days List View).
  TextStyle weekDaysTextStyle;

  /// The background color of a selected date (Days List View).
  Color selectedDateBackgroundColor;

  /// The color of the selected day text (Days List View).
  TextStyle selectedDayTextStyle;

  /// The color of the unselected days texts (Days List View).
  TextStyle unselectedDayTextStyle;

  AwesomeTheme({
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.buttonColor = const Color(0xFF4A5660),

    // Days View
    this.yearAndMonthHeaderTextStyle =
        const TextStyle(color: Color(0xFF4A5660)),
    this.weekDaysTextStyle = const TextStyle(color: Color(0xFFB5BEC6)),
    this.selectedDateBackgroundColor = const Color(0xFFF04D23),
    this.selectedDayTextStyle = const TextStyle(color: Colors.white),
    this.unselectedDayTextStyle = const TextStyle(color: Color(0xFF4A5660)),
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
