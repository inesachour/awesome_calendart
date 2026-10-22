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
