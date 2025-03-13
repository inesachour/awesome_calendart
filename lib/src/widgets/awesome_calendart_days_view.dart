import 'package:awesome_calendart/awesome_calendart.dart';
import 'package:awesome_calendart/src/utils/date_utils.dart';
import 'package:flutter/material.dart';

class AwesomeCalenDartDaysView extends StatefulWidget {
  DateTime selectedDate;
  DateTime displayedMonth;
  final Function(DateTime) updateSelectedDate;
  final Function(DateTime) updateDisplayedMonth;
  List<String> weekDays;
  final bool displayFullMonthName;
  final TextStyle? yearAndMonthTextStyle;
  final TextStyle? weeksDaysTextStyle;
  final TextStyle? selectedDaysTextStyle;
  final TextStyle? unselectedDaysTextStyle;
  final AwesomeTheme theme;
  final LocaleType locale;

  AwesomeCalenDartDaysView({
    super.key,
    required this.selectedDate,
    required this.displayedMonth,
    required this.updateSelectedDate,
    required this.updateDisplayedMonth,
    required this.weekDays,
    required this.displayFullMonthName,
    required this.yearAndMonthTextStyle,
    required this.weeksDaysTextStyle,
    required this.selectedDaysTextStyle,
    required this.unselectedDaysTextStyle,
    required this.theme,
    required this.locale,
  });

  @override
  State<AwesomeCalenDartDaysView> createState() =>
      _AwesomeCalenDartDaysViewState();
}

class _AwesomeCalenDartDaysViewState extends State<AwesomeCalenDartDaysView> {
  _getPreviousMonth() {
    DateTime newDate = AwesomeDateUtils.getPreviousMonth(widget.selectedDate);
    widget.updateSelectedDate(newDate);
  }

  _getNextMonth() {
    DateTime newMonth = AwesomeDateUtils.getNextMonth(widget.displayedMonth);
    widget.updateDisplayedMonth(newMonth);
  }

  _isDateSelected(int day, int month, int year) {
    return day == widget.selectedDate.day &&
        month == widget.selectedDate.month &&
        year == widget.selectedDate.year;
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
              child: Text(
                AwesomeDateUtils.getMonthAndYear(widget.displayedMonth, widget.locale),
                textAlign: TextAlign.center,
                style: widget.yearAndMonthTextStyle ??
                    TextStyle(
                        color: widget.theme.yearAndMonthColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
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
                widget.weekDays[i],
                style: widget.weeksDaysTextStyle ??
                    TextStyle(color: widget.theme.weekDaysColor),
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
              AwesomeDateUtils.getDaysInMonth(widget.displayedMonth), (i) {
            return GestureDetector(
              onTap: () {
                widget.updateSelectedDate(DateTime(widget.displayedMonth.year,
                    widget.displayedMonth.month, i + 1));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _isDateSelected(i + 1, widget.displayedMonth.month,
                          widget.displayedMonth.year)
                      ? widget.theme.selectedDateBackgroundColor
                      : null,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    "${i + 1}",
                    style: _isDateSelected(i + 1, widget.displayedMonth.month,
                            widget.displayedMonth.year)
                        ? (widget.selectedDaysTextStyle ??
                            TextStyle(color: widget.theme.selectedDayColor))
                        : (widget.unselectedDaysTextStyle ??
                            TextStyle(
                              color: widget.theme.unselectedDayColor,
                            )),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
    ;
  }
}
