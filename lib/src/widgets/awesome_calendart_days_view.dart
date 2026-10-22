import 'package:awesome_calendart/awesome_calendart.dart';
import 'package:awesome_calendart/src/utils/date_utils.dart';
import 'package:flutter/material.dart';

class AwesomeCalenDartDaysView extends StatefulWidget {
  final DateTime selectedDate;
  final DateTime selectedMonth;
  final Function(DateTime) updateSelectedDate;
  final Function(DateTime) updateSelectedMonth;
  final bool displayFullMonthName;
  final AwesomeTheme theme;
  final LocaleType locale;
  final List<DateTime>? eventMarkers;

  const AwesomeCalenDartDaysView({
    super.key,
    required this.selectedDate,
    required this.selectedMonth,
    required this.updateSelectedDate,
    required this.updateSelectedMonth,
    required this.displayFullMonthName,
    required this.theme,
    required this.locale,
    this.eventMarkers,
  });

  @override
  State<AwesomeCalenDartDaysView> createState() =>
      _AwesomeCalenDartDaysViewState();
}

class _AwesomeCalenDartDaysViewState extends State<AwesomeCalenDartDaysView> {
  _getPreviousMonth() {
    DateTime newDate = AwesomeDateUtils.getPreviousMonth(widget.selectedMonth);
    widget.updateSelectedMonth(newDate);
  }

  _getNextMonth() {
    DateTime newMonth = AwesomeDateUtils.getNextMonth(widget.selectedMonth);
    widget.updateSelectedMonth(newMonth);
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = widget.displayFullMonthName
        ? AwesomeDateUtils.getFullWeekdayNames(widget.locale)
        : AwesomeDateUtils.getShortWeekdayNames(widget.locale);
    final leadingEmptyCells =
        AwesomeDateUtils.getFirstWeekdayOffset(widget.selectedMonth);

    final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
    final aspectRatio = 1.5 / textScale.clamp(1.0, 2.0);
    final months = AwesomeDateUtils.getMonthsNames(widget.locale);

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              tooltip: months[
                  AwesomeDateUtils.getPreviousMonth(widget.selectedMonth)
                          .month -
                      1],
              onPressed: _getPreviousMonth,
              icon: Icon(
                Icons.arrow_back_ios,
                color: widget.theme.buttonColor,
              ),
            ),
            Expanded(
              child: Text(
                AwesomeDateUtils.getMonthAndYear(
                    widget.selectedMonth, widget.locale),
                textAlign: TextAlign.center,
                style: widget.theme.yearAndMonthHeaderTextStyle,
              ),
            ),
            IconButton(
              tooltip: months[
                  AwesomeDateUtils.getNextMonth(widget.selectedMonth).month -
                      1],
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
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 7,
          childAspectRatio: aspectRatio,
          padding: const EdgeInsets.all(0),
          children: List<Widget>.generate(7, (i) {
            return Center(
              child: Text(
                weekDays[i],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: widget.theme.weekDaysTextStyle,
              ),
            );
          }),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 7,
          childAspectRatio: aspectRatio,
          padding: const EdgeInsets.all(0),
          children: List<Widget>.generate(
              leadingEmptyCells +
                  AwesomeDateUtils.getDaysInMonth(widget.selectedMonth),
              (cell) {
            if (cell < leadingEmptyCells) return const SizedBox.shrink();
            final i = cell - leadingEmptyCells;
            bool isDateSelected = DateUtils.isSameDay(
                widget.selectedDate,
                DateTime(widget.selectedMonth.year, widget.selectedMonth.month,
                    i + 1));

            bool isEvent = widget.eventMarkers?.any((eventDate) {
                  return eventDate.year == widget.selectedMonth.year &&
                      eventDate.month == widget.selectedMonth.month &&
                      eventDate.day == (i + 1);
                }) ??
                false;

            final date = DateTime(
                widget.selectedMonth.year, widget.selectedMonth.month, i + 1);

            return Semantics(
              button: true,
              selected: isDateSelected,
              label:
                  "${i + 1} ${months[date.month - 1]} ${date.year}${isEvent ? ', event' : ''}",
              excludeSemantics: true,
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => widget.updateSelectedDate(date),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: isDateSelected
                          ? widget.theme.selectedDateBackgroundColor
                          : null,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${i + 1}",
                              style: isDateSelected
                                  ? widget.theme.selectedDayTextStyle
                                  : widget.theme.unselectedDayTextStyle,
                            ),
                            if (isEvent)
                              Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: isDateSelected
                                      ? widget
                                          .theme.eventMarkerColorOnSelectedDay
                                      : widget.theme
                                          .eventMarkerColorOnUnselectedDay,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
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
