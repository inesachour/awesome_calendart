import 'package:awesome_calendart/awesome_calendart.dart';
import 'package:awesome_calendart/src/utils/date_utils.dart';
import 'package:awesome_calendart/theme.dart';
import 'package:flutter/material.dart';

class AwesomeCalenDart extends StatefulWidget {
  final bool isDarkMode;
  final double elevation;
  final double borderRadius;
  final LocaleType locale;
  final bool displayFullMonthName;
  final TextStyle? yearAndMonthTextStyle;
  final TextStyle? weeksDaysTextStyle;
  final TextStyle? daysTextStyle;

  const AwesomeCalenDart({
    super.key,
    this.isDarkMode = false,
    this.elevation = 5,
    this.borderRadius = 20,
    this.locale = LocaleType.en,
    this.displayFullMonthName = false,
    this.yearAndMonthTextStyle,
    this.weeksDaysTextStyle,
    this.daysTextStyle,
  });

  @override
  State<AwesomeCalenDart> createState() => _AwesomeCalenDartState();
}

class _AwesomeCalenDartState extends State<AwesomeCalenDart> {
  late DateTime displayedMonth, selectedDate;
  late List<String> weekDays;
  late dynamic theme;

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
                    AwesomeDateUtils.getMonthAndYear(displayedMonth),
                    textAlign: TextAlign.center,
                    style: widget.yearAndMonthTextStyle ??
                        TextStyle(
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
                    weekDays[i],
                    style: widget.weeksDaysTextStyle ??
                        TextStyle(color: theme.secondaryColor),
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
                          ? theme.thirdColor
                          : null,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "${i + 1}",
                        style: widget.daysTextStyle ??
                            TextStyle(
                              color: _isDateSelected(i + 1,
                                      displayedMonth.month, displayedMonth.year)
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
