library awesome_calendar;

import 'package:awesome_calendart/src/date_utils.dart';
import 'package:awesome_calendart/theme.dart';
import 'package:flutter/material.dart';

class AwesomeCalenDart extends StatefulWidget {
  final bool isDarkMode;
  final double elevation;
  final double borderRadius;

  const AwesomeCalenDart({
    super.key,
    this.isDarkMode = false,
    this.elevation = 5,
    this.borderRadius = 20,
  });

  @override
  State<AwesomeCalenDart> createState() => _AwesomeCalenDartState();
}

class _AwesomeCalenDartState extends State<AwesomeCalenDart> {
  late DateTime today, firstDayInMonth, selectedDate;
  late int daysInMonth;
  List<String> days = ["MON", "TUE", "WED", "THU", "FRI", "SUN", "SAT"];
  late dynamic theme;

  _getNextMonth() {
    firstDayInMonth = AwesomeDateUtils.getNextMonth(firstDayInMonth);
    daysInMonth = DateTimeRange(
            start: firstDayInMonth,
            end: DateTime(firstDayInMonth.year, firstDayInMonth.month + 1))
        .duration
        .inDays;
    setState(() {});
  }

  _getPreviousMonth() {
    firstDayInMonth = AwesomeDateUtils.getPreviousMonth(firstDayInMonth);
    daysInMonth = DateTimeRange(
            start: firstDayInMonth,
            end: DateTime(firstDayInMonth.year, firstDayInMonth.month + 1))
        .duration
        .inDays;
    setState(() {});
  }

  _isDateSelected(int day, int month, int year) {
    return day == selectedDate.day &&
        month == selectedDate.month &&
        year == selectedDate.year;
  }

  @override
  void initState() {
    today = DateTime.now();
    selectedDate = today;
    firstDayInMonth = DateTime(today.year, today.month, 1);
    daysInMonth = DateTimeRange(
            start: firstDayInMonth,
            end: DateTime(firstDayInMonth.year, firstDayInMonth.month + 1))
        .duration
        .inDays;
    theme = widget.isDarkMode ? DarkTheme() : LightTheme();
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
                    color: theme.primaryColor,
                  ),
                ),
                Expanded(
                  child: Text(
                    AwesomeDateUtils.getMonthAndYear(firstDayInMonth),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: _getNextMonth,
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: theme.primaryColor,
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
                    days[i],
                    style: TextStyle(color: theme.secondaryColor),
                  ),
                );
              }),
            ),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 7,
              childAspectRatio: 1.5,
              padding: const EdgeInsets.all(0),
              children: List<Widget>.generate(daysInMonth, (i) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = DateTime(
                          firstDayInMonth.year, firstDayInMonth.month, i + 1);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: _isDateSelected(i + 1, firstDayInMonth.month,
                              firstDayInMonth.year)
                          ? theme.thirdColor
                          : null,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "${i + 1}",
                        style: TextStyle(
                          color: _isDateSelected(i + 1, firstDayInMonth.month,
                                  firstDayInMonth.year)
                              ? Colors.white
                              : theme.primaryColor,
                        ),
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
