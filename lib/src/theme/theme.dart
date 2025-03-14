import 'package:flutter/material.dart';

/// Class to define a customizable theme for a calendar (You can use predefined themes : [LightTheme] and [DarkTheme]).
class AwesomeTheme {
  /// The background color of the calendar.
  Color backgroundColor;

  /// The color of the next and previous buttons in the calendar.
  Color buttonColor;

  /// The color of the year and month header text.
  TextStyle yearAndMonthHeaderTextStyle;

  /// The color of the weekdays text.
  TextStyle weekDaysTextStyle;

  /// The background color of a selected date.
  Color selectedDateBackgroundColor;

  /// The color of the selected day text.
  TextStyle selectedDayTextStyle;

  /// The color of the unselected days texts.
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
  @override
  Color backgroundColor = const Color(0xFF464646);
  @override
  Color buttonColor = const Color(0xFFFFFFFF);
  @override
  TextStyle yearAndMonthHeaderTextStyle =
      const TextStyle(color: Color(0xFFFFFFFF));
  @override
  TextStyle weekDaysTextStyle = const TextStyle(color: Color(0xFFB5BEC6));
  @override
  TextStyle unselectedDayTextStyle = const TextStyle(color: Color(0xFFFFFFFF));
}
