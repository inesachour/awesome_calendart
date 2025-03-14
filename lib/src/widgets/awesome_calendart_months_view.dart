import 'package:awesome_calendart/awesome_calendart.dart';
import 'package:awesome_calendart/src/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AwesomeCalenDartMonthsView extends StatefulWidget {
  DateTime selectedMonth;
  int selectedYear;
  final Function(DateTime) updateSelectedDate;
  final Function(DateTime) updateSelectedMonth;
  final Function(int) updateSelectedView;
  final AwesomeTheme theme;
  final LocaleType locale;

  AwesomeCalenDartMonthsView({
    super.key,
    required this.selectedMonth,
    required this.selectedYear,
    required this.updateSelectedDate,
    required this.updateSelectedMonth,
    required this.updateSelectedView,
    required this.theme,
    required this.locale,
  });

  @override
  State<AwesomeCalenDartMonthsView> createState() =>
      _AwesomeCalenDartMonthsViewState();
}

class _AwesomeCalenDartMonthsViewState
    extends State<AwesomeCalenDartMonthsView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {},
          child: Text(widget.selectedYear.toString()),
        ),
        GridView.builder(
          shrinkWrap: true,
          itemCount: 12,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemBuilder: (context, index) {
            List<String> weekDays =
                AwesomeDateUtils.getFullWeekdayNames(widget.locale);
            return monthView(weekDays, index);
          },
        ),
      ],
    );
  }

  Widget monthView(List<String> weekDays, int index) {
    return Column(
      children: [
        Text(
          AwesomeDateUtils.getMonthsNames(widget.locale)[index],
          textAlign: TextAlign.center,
          style: widget.theme.yearAndMonthHeaderTextStyle.copyWith(
              color:
                  widget.selectedMonth.month - 1 == index ? Colors.blue : null),
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
                style: widget.theme.weekDaysTextStyle.copyWith(fontSize: 10),
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
              child: Center(
                child: Text(
                  "${i + 1}",
                  style:
                      widget.theme.unselectedDayTextStyle.copyWith(fontSize: 8),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
