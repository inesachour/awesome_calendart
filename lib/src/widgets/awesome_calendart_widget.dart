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

  /// A flag to indicate whether the full month name should be displayed (e.g., "January" instead of "Jan") (default false).
  final bool displayFullMonthName;

  /// A theme that can be applied to the calendar (default [LightTheme]).
  final AwesomeTheme? theme;

  const AwesomeCalenDart({
    super.key,
    this.elevation = 5,
    this.borderRadius = 20,
    this.locale = LocaleType.en,
    this.displayFullMonthName = false,
    this.theme,
  });

  @override
  State<AwesomeCalenDart> createState() => _AwesomeCalenDartState();
}

class _AwesomeCalenDartState extends State<AwesomeCalenDart> {
  late DateTime selectedDate, selectedMonth;
  late int selectedYear;
  late AwesomeTheme theme;

  int selectedView = 0;

  updateSelectedView(int index) {
    setState(() {
      selectedView = index;
    });
  }

  updateSelectedDate(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
    });
  }

  updateSelectedMonth(DateTime newMonth) {
    setState(() {
      selectedMonth = newMonth;
    });
  }

  updateSelectedYear(int newYear) {
    setState(() {
      selectedYear = newYear;
    });
  }

  @override
  void initState() {
    selectedDate = DateTime.now();
    selectedMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    selectedYear = selectedDate.year;
    theme = widget.theme ?? (widget.theme ?? LightTheme());
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
            updateSelectedView: updateSelectedView,
            displayFullMonthName: widget.displayFullMonthName,
            theme: theme,
            locale: widget.locale,
          )),
    );
  }
}
