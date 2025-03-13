import 'package:awesome_calendart/awesome_calendart.dart';
import 'package:awesome_calendart/src/utils/date_utils.dart';
import 'package:flutter/material.dart';

class AwesomeCalenDartDaysView extends StatefulWidget {
  DateTime selectedDate;
  DateTime selectedMonth;
  final Function(DateTime) updateSelectedDate;
  final Function(DateTime) updateSelectedMonth;
  final Function(int) updateSelectedView;
  final bool displayFullMonthName;
  final AwesomeTheme theme;
  final LocaleType locale;

  AwesomeCalenDartDaysView({
    super.key,
    required this.selectedDate,
    required this.selectedMonth,
    required this.updateSelectedDate,
    required this.updateSelectedMonth,
    required this.updateSelectedView,
    required this.displayFullMonthName,
    required this.theme,
    required this.locale,
  });

  @override
  State<AwesomeCalenDartDaysView> createState() =>
      _AwesomeCalenDartDaysViewState();
}

class _AwesomeCalenDartDaysViewState extends State<AwesomeCalenDartDaysView> {
  late List<String> weekDays;

  _getPreviousMonth() {
    DateTime newDate = AwesomeDateUtils.getPreviousMonth(widget.selectedDate);
    widget.updateSelectedMonth(newDate);
  }

  _getNextMonth() {
    DateTime newMonth = AwesomeDateUtils.getNextMonth(widget.selectedMonth);
    widget.updateSelectedMonth(newMonth);
  }

  _isDateSelected(int day, int month, int year) {
    return day == widget.selectedDate.day &&
        month == widget.selectedDate.month &&
        year == widget.selectedDate.year;
  }

  @override
  void initState() {
    super.initState();
    weekDays = widget.displayFullMonthName
        ? AwesomeDateUtils.getFullWeekdayNames(widget.locale)
        : AwesomeDateUtils.getShortWeekdayNames(widget.locale);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: _getPreviousMonth,
              icon: Icon(
                Icons.arrow_back_ios,
                color: widget.theme.buttonColor,
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  widget.updateSelectedView(1);
                },
                child: Text(
                  AwesomeDateUtils.getMonthAndYear(
                      widget.selectedMonth, widget.locale),
                  textAlign: TextAlign.center,
                  style: widget.theme.yearAndMonthHeaderTextStyle,
                ),
              ),
            ),
            IconButton(
              onPressed: _getNextMonth,
              icon: Icon(
                Icons.arrow_forward_ios,
                color: widget.theme.buttonColor,
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
                style: widget.theme.weekDaysTextStyle,
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
              AwesomeDateUtils.getDaysInMonth(widget.selectedMonth), (i) {
            return GestureDetector(
              onTap: () {
                widget.updateSelectedDate(DateTime(widget.selectedMonth.year,
                    widget.selectedMonth.month, i + 1));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _isDateSelected(i + 1, widget.selectedMonth.month,
                          widget.selectedMonth.year)
                      ? widget.theme.selectedDateBackgroundColor
                      : null,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    "${i + 1}",
                    style: _isDateSelected(i + 1, widget.selectedMonth.month,
                            widget.selectedMonth.year)
                        ? widget.theme.selectedDayTextStyle
                        : widget.theme.unselectedDayTextStyle,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
