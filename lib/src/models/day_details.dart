import 'package:awesome_calendart/src/models/awesome_event.dart';
import 'package:flutter/material.dart';

/// Everything known about a day cell. It is passed to `dayBuilder` so you can
/// draw the day yourself.
@immutable
class AwesomeDayDetails {
  /// The day (time part is midnight).
  final DateTime date;

  /// Whether the day is selected (or an end point of the selected range).
  final bool isSelected;

  /// Whether the day is today.
  final bool isToday;

  /// Whether the day cannot be selected.
  final bool isDisabled;

  /// Whether the day is one of the weekend days (`weekendDays`).
  final bool isWeekend;

  /// Whether the day has keyboard focus.
  final bool isFocused;

  /// Whether the day belongs to the previous or next month (only shown when
  /// `showAdjacentMonthDays` is enabled).
  final bool isOutsideMonth;

  /// Whether the day is the first day of the selected range.
  final bool isRangeStart;

  /// Whether the day is the last day of the selected range.
  final bool isRangeEnd;

  /// Whether the day is strictly between the range start and end.
  final bool isInRange;

  /// The events on this day.
  final List<AwesomeEvent> events;

  const AwesomeDayDetails({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.isDisabled,
    required this.isWeekend,
    required this.isFocused,
    required this.isOutsideMonth,
    required this.isRangeStart,
    required this.isRangeEnd,
    required this.isInRange,
    required this.events,
  });
}

/// Builds the content of a day cell. See `AwesomeCalenDart.dayBuilder`.
typedef AwesomeDayBuilder = Widget Function(
    BuildContext context, AwesomeDayDetails details);

/// Builds the header of the calendar. See `AwesomeCalenDart.headerBuilder`.
typedef AwesomeHeaderBuilder = Widget Function(
    BuildContext context, AwesomeHeaderDetails details);

/// Builds one weekday label. [weekday] is `DateTime.monday`..`DateTime.sunday`
/// and [label] the localized name. See `AwesomeCalenDart.weekdayBuilder`.
typedef AwesomeWeekdayBuilder = Widget Function(
    BuildContext context, int weekday, String label);

/// Builds the list of events shown under the grid. See
/// `AwesomeCalenDart.eventListBuilder`.
typedef AwesomeEventListBuilder = Widget Function(
    BuildContext context, DateTime date, List<AwesomeEvent> events);

/// Overrides how one particular day looks. See `AwesomeCalenDart.specialDates`.
@immutable
class AwesomeDayStyle {
  /// Merged on top of the day's text style (unless the day is selected).
  final TextStyle? textStyle;

  /// The fill color of the day (unless the day is selected).
  final Color? backgroundColor;

  /// The color of a ring drawn around the day.
  final Color? borderColor;

  const AwesomeDayStyle(
      {this.textStyle, this.backgroundColor, this.borderColor});
}

/// What `AwesomeCalenDart.headerBuilder` receives to draw the header.
@immutable
class AwesomeHeaderDetails {
  /// The month shown (or, in week formats, the month of the focused day).
  final DateTime month;

  /// The title the calendar would show (affected by `monthYearFormatter`,
  /// locale and `useLocaleDigits`).
  final String title;

  /// Whether going to the previous period is allowed (`minDate`).
  final bool canGoPrevious;

  /// Whether going to the next period is allowed (`maxDate`).
  final bool canGoNext;

  /// Shows the previous month (or week / two weeks).
  final VoidCallback goToPrevious;

  /// Shows the next month (or week / two weeks).
  final VoidCallback goToNext;

  /// Opens the month and year pickers, or null when they are disabled.
  final VoidCallback? openPicker;

  /// Cycles the calendar format, or null when `showFormatButton` is false.
  final VoidCallback? changeFormat;

  const AwesomeHeaderDetails({
    required this.month,
    required this.title,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.goToPrevious,
    required this.goToNext,
    required this.openPicker,
    required this.changeFormat,
  });
}
