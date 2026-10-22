import 'package:flutter/material.dart';

/// An event shown as a marker (dot) under a day.
///
/// When several events fall on the same day, up to three dots are drawn, each
/// with its own [color].
@immutable
class AwesomeEvent {
  /// The day of the event. The time part is ignored.
  final DateTime date;

  /// The color of the marker. Falls back to the theme's event marker colors.
  final Color? color;

  /// A description of the event, read out by screen readers.
  final String? label;

  /// Creates an event on [date], optionally with a [color] and a [label].
  const AwesomeEvent({required this.date, this.color, this.label});
}
