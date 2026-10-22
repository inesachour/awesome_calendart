import 'package:flutter/material.dart';

/// Class to define a customizable theme for a calendar (You can use predefined themes : [LightTheme] and [DarkTheme]).
class AwesomeTheme {
  /// The background color of the calendar.
  final Color backgroundColor;

  /// The color of the next and previous buttons in the calendar.
  final Color buttonColor;

  /// The text style of the year and month header text.
  final TextStyle yearAndMonthHeaderTextStyle;

  /// The text style of the weekdays text.
  final TextStyle weekDaysTextStyle;

  /// The background color of a selected date.
  final Color selectedDateBackgroundColor;

  /// The text style of the selected day text.
  final TextStyle selectedDayTextStyle;

  /// The text style of the unselected days texts.
  final TextStyle unselectedDayTextStyle;

  /// The color of the event marker on unselected day.
  final Color eventMarkerColorOnUnselectedDay;

  /// The color of the event marker on selected day.
  final Color eventMarkerColorOnSelectedDay;

  AwesomeTheme({
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.buttonColor = const Color(0xFF4A5660),

    // Days View
    this.yearAndMonthHeaderTextStyle = const TextStyle(
      color: Color(0xFF4A5660),
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
    this.weekDaysTextStyle = const TextStyle(color: Color(0xFFB5BEC6)),
    this.selectedDateBackgroundColor = const Color(0xFFF04D23),
    this.selectedDayTextStyle = const TextStyle(color: Colors.white),
    this.unselectedDayTextStyle = const TextStyle(color: Color(0xFF4A5660)),
    this.eventMarkerColorOnSelectedDay = Colors.white,
    this.eventMarkerColorOnUnselectedDay = const Color(0xFFF04D23),
  });

  /// Returns a copy of this theme with the given fields replaced.
  AwesomeTheme copyWith({
    Color? backgroundColor,
    Color? buttonColor,
    TextStyle? yearAndMonthHeaderTextStyle,
    TextStyle? weekDaysTextStyle,
    Color? selectedDateBackgroundColor,
    TextStyle? selectedDayTextStyle,
    TextStyle? unselectedDayTextStyle,
    Color? eventMarkerColorOnUnselectedDay,
    Color? eventMarkerColorOnSelectedDay,
  }) {
    return AwesomeTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      buttonColor: buttonColor ?? this.buttonColor,
      yearAndMonthHeaderTextStyle:
          yearAndMonthHeaderTextStyle ?? this.yearAndMonthHeaderTextStyle,
      weekDaysTextStyle: weekDaysTextStyle ?? this.weekDaysTextStyle,
      selectedDateBackgroundColor:
          selectedDateBackgroundColor ?? this.selectedDateBackgroundColor,
      selectedDayTextStyle: selectedDayTextStyle ?? this.selectedDayTextStyle,
      unselectedDayTextStyle:
          unselectedDayTextStyle ?? this.unselectedDayTextStyle,
      eventMarkerColorOnUnselectedDay: eventMarkerColorOnUnselectedDay ??
          this.eventMarkerColorOnUnselectedDay,
      eventMarkerColorOnSelectedDay:
          eventMarkerColorOnSelectedDay ?? this.eventMarkerColorOnSelectedDay,
    );
  }
}

class LightTheme extends AwesomeTheme {
  LightTheme() : super();
}

class DarkTheme extends AwesomeTheme {
  DarkTheme()
      : super(
          backgroundColor: const Color(0xFF464646),
          buttonColor: const Color(0xFFFFFFFF),
          yearAndMonthHeaderTextStyle: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          weekDaysTextStyle: const TextStyle(color: Color(0xFFB5BEC6)),
          unselectedDayTextStyle: const TextStyle(color: Color(0xFFFFFFFF)),
        );
}
