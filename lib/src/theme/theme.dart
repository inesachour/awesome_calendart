import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Defines the colors and text styles used by the calendar.
///
/// Every field has a default, so you only need to pass what you want to
/// change. Use [LightTheme] and [DarkTheme] as ready-made starting points, and
/// [copyWith] to tweak them:
///
/// ```dart
/// AwesomeCalenDart(
///   theme: const DarkTheme().copyWith(
///     selectedDateBackgroundColor: Colors.teal,
///   ),
/// )
/// ```
///
/// `AwesomeTheme` is a [ThemeExtension], so you can also register it once in
/// your app's [ThemeData] and every calendar without an explicit `theme` picks
/// it up:
///
/// ```dart
/// MaterialApp(
///   theme: ThemeData(extensions: const [LightTheme()]),
///   darkTheme: ThemeData.dark().copyWith(extensions: const [DarkTheme()]),
/// )
/// ```
class AwesomeTheme extends ThemeExtension<AwesomeTheme> {
  /// The background color of the calendar.
  final Color backgroundColor;

  /// The color of the next and previous month buttons.
  final Color buttonColor;

  /// The text style of the month and year header (also used by the month and
  /// year pickers).
  final TextStyle yearAndMonthHeaderTextStyle;

  /// The text style of the weekday labels.
  final TextStyle weekDaysTextStyle;

  /// The background color of a selected day (and of the range end points).
  final Color selectedDateBackgroundColor;

  /// The text style of selected days.
  final TextStyle selectedDayTextStyle;

  /// The text style of regular (unselected) days.
  final TextStyle unselectedDayTextStyle;

  /// The text style of weekend days (see `AwesomeCalenDart.weekendDays`).
  /// When null, [unselectedDayTextStyle] is used.
  final TextStyle? weekendDayTextStyle;

  /// The text style of days that cannot be selected (outside of the
  /// min/max dates or listed in the disabled dates).
  final TextStyle disabledDayTextStyle;

  /// The text style of the days of the previous/next month shown in the grid
  /// when `showAdjacentMonthDays` is enabled.
  final TextStyle adjacentMonthDayTextStyle;

  /// The color of the ring drawn around today's date.
  final Color todayBorderColor;

  /// The width of the ring drawn around today's date.
  final double todayBorderWidth;

  /// The background color of the days between the start and the end of a
  /// selected range.
  final Color rangeBackgroundColor;

  /// The text style of the days inside a selected range (between the end
  /// points).
  final TextStyle rangeDayTextStyle;

  /// The text style of the week numbers column (`showWeekNumbers`).
  final TextStyle weekNumberTextStyle;

  /// The color of the ring drawn around the day that has keyboard focus.
  final Color focusedDayBorderColor;

  /// The default color of an event marker on an unselected day. Individual
  /// events can override it with `AwesomeEvent.color`.
  final Color eventMarkerColorOnUnselectedDay;

  /// The color of an event marker on a selected day.
  final Color eventMarkerColorOnSelectedDay;

  /// The diameter of an event marker dot.
  final double eventMarkerSize;

  const AwesomeTheme({
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.buttonColor = const Color(0xFF4A5660),
    this.yearAndMonthHeaderTextStyle = const TextStyle(
      color: Color(0xFF4A5660),
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
    this.weekDaysTextStyle = const TextStyle(color: Color(0xFFB5BEC6)),
    this.selectedDateBackgroundColor = const Color(0xFFF04D23),
    this.selectedDayTextStyle = const TextStyle(color: Colors.white),
    this.unselectedDayTextStyle = const TextStyle(color: Color(0xFF4A5660)),
    this.weekendDayTextStyle,
    this.disabledDayTextStyle = const TextStyle(color: Color(0xFFD5DADF)),
    this.adjacentMonthDayTextStyle = const TextStyle(color: Color(0xFFB5BEC6)),
    this.todayBorderColor = const Color(0xFFF04D23),
    this.todayBorderWidth = 1.5,
    this.rangeBackgroundColor = const Color(0x33F04D23),
    this.rangeDayTextStyle = const TextStyle(color: Color(0xFF4A5660)),
    this.weekNumberTextStyle =
        const TextStyle(color: Color(0xFFB5BEC6), fontSize: 12),
    this.focusedDayBorderColor = const Color(0xFF4A5660),
    this.eventMarkerColorOnSelectedDay = Colors.white,
    this.eventMarkerColorOnUnselectedDay = const Color(0xFFF04D23),
    this.eventMarkerSize = 4,
  });

  /// Returns a copy of this theme with the given fields replaced.
  @override
  AwesomeTheme copyWith({
    Color? backgroundColor,
    Color? buttonColor,
    TextStyle? yearAndMonthHeaderTextStyle,
    TextStyle? weekDaysTextStyle,
    Color? selectedDateBackgroundColor,
    TextStyle? selectedDayTextStyle,
    TextStyle? unselectedDayTextStyle,
    TextStyle? weekendDayTextStyle,
    TextStyle? disabledDayTextStyle,
    TextStyle? adjacentMonthDayTextStyle,
    Color? todayBorderColor,
    double? todayBorderWidth,
    Color? rangeBackgroundColor,
    TextStyle? rangeDayTextStyle,
    TextStyle? weekNumberTextStyle,
    Color? focusedDayBorderColor,
    Color? eventMarkerColorOnUnselectedDay,
    Color? eventMarkerColorOnSelectedDay,
    double? eventMarkerSize,
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
      weekendDayTextStyle: weekendDayTextStyle ?? this.weekendDayTextStyle,
      disabledDayTextStyle: disabledDayTextStyle ?? this.disabledDayTextStyle,
      adjacentMonthDayTextStyle:
          adjacentMonthDayTextStyle ?? this.adjacentMonthDayTextStyle,
      todayBorderColor: todayBorderColor ?? this.todayBorderColor,
      todayBorderWidth: todayBorderWidth ?? this.todayBorderWidth,
      rangeBackgroundColor: rangeBackgroundColor ?? this.rangeBackgroundColor,
      rangeDayTextStyle: rangeDayTextStyle ?? this.rangeDayTextStyle,
      weekNumberTextStyle: weekNumberTextStyle ?? this.weekNumberTextStyle,
      focusedDayBorderColor:
          focusedDayBorderColor ?? this.focusedDayBorderColor,
      eventMarkerColorOnUnselectedDay: eventMarkerColorOnUnselectedDay ??
          this.eventMarkerColorOnUnselectedDay,
      eventMarkerColorOnSelectedDay:
          eventMarkerColorOnSelectedDay ?? this.eventMarkerColorOnSelectedDay,
      eventMarkerSize: eventMarkerSize ?? this.eventMarkerSize,
    );
  }

  @override
  AwesomeTheme lerp(ThemeExtension<AwesomeTheme>? other, double t) {
    if (other is! AwesomeTheme) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    TextStyle ts(TextStyle a, TextStyle b) => TextStyle.lerp(a, b, t)!;
    return AwesomeTheme(
      backgroundColor: c(backgroundColor, other.backgroundColor),
      buttonColor: c(buttonColor, other.buttonColor),
      yearAndMonthHeaderTextStyle:
          ts(yearAndMonthHeaderTextStyle, other.yearAndMonthHeaderTextStyle),
      weekDaysTextStyle: ts(weekDaysTextStyle, other.weekDaysTextStyle),
      selectedDateBackgroundColor:
          c(selectedDateBackgroundColor, other.selectedDateBackgroundColor),
      selectedDayTextStyle:
          ts(selectedDayTextStyle, other.selectedDayTextStyle),
      unselectedDayTextStyle:
          ts(unselectedDayTextStyle, other.unselectedDayTextStyle),
      weekendDayTextStyle:
          TextStyle.lerp(weekendDayTextStyle, other.weekendDayTextStyle, t),
      disabledDayTextStyle:
          ts(disabledDayTextStyle, other.disabledDayTextStyle),
      adjacentMonthDayTextStyle:
          ts(adjacentMonthDayTextStyle, other.adjacentMonthDayTextStyle),
      todayBorderColor: c(todayBorderColor, other.todayBorderColor),
      todayBorderWidth:
          lerpDouble(todayBorderWidth, other.todayBorderWidth, t)!,
      rangeBackgroundColor: c(rangeBackgroundColor, other.rangeBackgroundColor),
      rangeDayTextStyle: ts(rangeDayTextStyle, other.rangeDayTextStyle),
      weekNumberTextStyle: ts(weekNumberTextStyle, other.weekNumberTextStyle),
      focusedDayBorderColor:
          c(focusedDayBorderColor, other.focusedDayBorderColor),
      eventMarkerColorOnUnselectedDay: c(eventMarkerColorOnUnselectedDay,
          other.eventMarkerColorOnUnselectedDay),
      eventMarkerColorOnSelectedDay:
          c(eventMarkerColorOnSelectedDay, other.eventMarkerColorOnSelectedDay),
      eventMarkerSize: lerpDouble(eventMarkerSize, other.eventMarkerSize, t)!,
    );
  }

  List<Object?> get _props => [
        backgroundColor,
        buttonColor,
        yearAndMonthHeaderTextStyle,
        weekDaysTextStyle,
        selectedDateBackgroundColor,
        selectedDayTextStyle,
        unselectedDayTextStyle,
        weekendDayTextStyle,
        disabledDayTextStyle,
        adjacentMonthDayTextStyle,
        todayBorderColor,
        todayBorderWidth,
        rangeBackgroundColor,
        rangeDayTextStyle,
        weekNumberTextStyle,
        focusedDayBorderColor,
        eventMarkerColorOnUnselectedDay,
        eventMarkerColorOnSelectedDay,
        eventMarkerSize,
      ];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AwesomeTheme) return false;
    final a = _props, b = other._props;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(_props);
}

/// The default light theme.
class LightTheme extends AwesomeTheme {
  const LightTheme() : super();
}

/// A ready-made dark theme.
class DarkTheme extends AwesomeTheme {
  const DarkTheme()
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
          weekNumberTextStyle:
              const TextStyle(color: Color(0xFF9AA3AB), fontSize: 12),
          focusedDayBorderColor: const Color(0xFFFFFFFF),
          disabledDayTextStyle: const TextStyle(color: Color(0xFF7A7A7A)),
          adjacentMonthDayTextStyle: const TextStyle(color: Color(0xFF8C8C8C)),
          rangeDayTextStyle: const TextStyle(color: Color(0xFFFFFFFF)),
        );
}
