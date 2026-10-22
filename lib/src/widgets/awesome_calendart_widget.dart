import 'package:awesome_calendart/awesome_calendart.dart';
import 'package:awesome_calendart/src/widgets/awesome_calendart_days_view.dart';
import 'package:flutter/material.dart';

class AwesomeCalenDart extends StatefulWidget {
  /// The elevation of the calendar (default 5).
  final double elevation;

  /// The border radius for rounded corners of the calendar (default 20)
  final double borderRadius;

  /// The locale type for the calendar, determining the language (default [LocaleType.en]).
  final LocaleType locale;

  /// A flag to indicate whether full weekday names should be displayed (e.g., "Monday" instead of "Mon") (default false).
  final bool displayFullMonthName;

  /// A theme that can be applied to the calendar (default [LightTheme]).
  final AwesomeTheme? theme;

  /// A list of dates with markers to highlight events, reminders, or special occasions.
  final List<DateTime>? eventMarkers;

  /// Called when the user taps a day.
  final ValueChanged<DateTime>? onDateSelected;

  const AwesomeCalenDart({
    super.key,
    this.elevation = 5,
    this.borderRadius = 20,
    this.locale = LocaleType.en,
    this.displayFullMonthName = false,
    this.theme,
    this.eventMarkers,
    this.onDateSelected,
  });

  @override
  State<AwesomeCalenDart> createState() => _AwesomeCalenDartState();
}

class _AwesomeCalenDartState extends State<AwesomeCalenDart> {
  late DateTime selectedDate, selectedMonth;

  AwesomeTheme get theme => widget.theme ?? LightTheme();

  updateSelectedDate(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
    });
    widget.onDateSelected?.call(newDate);
  }

  updateSelectedMonth(DateTime newMonth) {
    setState(() {
      selectedMonth = newMonth;
    });
  }

  @override
  void initState() {
    selectedDate = DateTime.now();
    selectedMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: widget.elevation,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      color: theme.backgroundColor,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: AwesomeCalenDartDaysView(
            selectedDate: selectedDate,
            selectedMonth: selectedMonth,
            updateSelectedDate: updateSelectedDate,
            updateSelectedMonth: updateSelectedMonth,
            displayFullMonthName: widget.displayFullMonthName,
            theme: theme,
            locale: widget.locale,
            eventMarkers: widget.eventMarkers,
          )),
    );
  }
}
