import 'package:awesome_calendart/awesome_calendart.dart';
import 'package:awesome_calendart/src/utils/date_utils.dart';
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

  /// The text style for the year and month display. This value overrides the value passed in the theme's yearAndMonthColor property.
  final TextStyle? yearAndMonthTextStyle;

  /// The text style for the weekdays display. This value overrides the value passed in the theme's weekDaysColor property.
  final TextStyle? weeksDaysTextStyle;

  /// The text style for the selected days. This value overrides the value passed in the theme's selectedDayColor property.
  final TextStyle? selectedDaysTextStyle;

  /// The text style for the unselected days. This value overrides the value passed in the theme's unselectedDayColor property.
  final TextStyle? unselectedDaysTextStyle;

  /// A theme that can be applied to the calendar (default [LightTheme]).
  final AwesomeTheme? theme;

  const AwesomeCalenDart({
    super.key,
    this.elevation = 5,
    this.borderRadius = 20,
    this.locale = LocaleType.en,
    this.displayFullMonthName = false,
    this.yearAndMonthTextStyle,
    this.weeksDaysTextStyle,
    this.selectedDaysTextStyle,
    this.unselectedDaysTextStyle,
    this.theme,
  });

  @override
  State<AwesomeCalenDart> createState() => _AwesomeCalenDartState();
}

class _AwesomeCalenDartState extends State<AwesomeCalenDart> {
  late DateTime displayedMonth, selectedDate;
  late List<String> weekDays;
  late AwesomeTheme theme;

  _getNextMonth() {
    displayedMonth = AwesomeDateUtils.getNextMonth(displayedMonth);

    setState(() {});
  }

  _getPreviousMonth() {
    displayedMonth = AwesomeDateUtils.getPreviousMonth(displayedMonth);
    setState(() {});
  }

  _isDateSelected(int day, int month, int year) {
    return day == selectedDate.day &&
        month == selectedDate.month &&
        year == selectedDate.year;
  }

  @override
  void initState() {
    weekDays = widget.displayFullMonthName
        ? AwesomeDateUtils.getFullWeekdayNames(widget.locale)
        : AwesomeDateUtils.getShortWeekdayNames(widget.locale);
    selectedDate = DateTime.now();
    displayedMonth = DateTime(selectedDate.year, selectedDate.month, 1);
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
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: _getPreviousMonth,
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: theme.buttonColor,
                  ),
                ),
                Expanded(
                  child: Text(
                    AwesomeDateUtils.getMonthAndYear(displayedMonth),
                    textAlign: TextAlign.center,
                    style: widget.yearAndMonthTextStyle ??
                        TextStyle(
                            color: theme.yearAndMonthColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: _getNextMonth,
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: theme.buttonColor,
                  ),
                ),
              ],
            ),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 7,
              childAspectRatio: 1.5,
              padding: const EdgeInsets.all(0),
              children: List<Widget>.generate(7, (i) {
                return Center(
                  child: Text(
                    weekDays[i],
                    style: widget.weeksDaysTextStyle ??
                        TextStyle(color: theme.weekDaysColor),
                  ),
                );
              }),
            ),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 7,
              childAspectRatio: 1.5,
              padding: const EdgeInsets.all(0),
              children: List<Widget>.generate(
                  AwesomeDateUtils.getDaysInMonth(displayedMonth), (i) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = DateTime(
                          displayedMonth.year, displayedMonth.month, i + 1);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: _isDateSelected(
                              i + 1, displayedMonth.month, displayedMonth.year)
                          ? theme.selectedDateBackgroundColor
                          : null,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "${i + 1}",
                        style: _isDateSelected(i + 1, displayedMonth.month,
                                displayedMonth.year)
                            ? (widget.selectedDaysTextStyle ??
                                TextStyle(color: theme.selectedDayColor))
                            : (widget.unselectedDaysTextStyle ??
                                TextStyle(
                                  color: theme.unselectedDayColor,
                                )),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
