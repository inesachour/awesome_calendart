import 'package:awesome_calendart/awesome_calendart.dart';
import 'package:awesome_calendart/src/utils/date_utils.dart';
import 'package:flutter/material.dart';

class AwesomeCalenDartMonthsView extends StatefulWidget {
  DateTime displayedMonth;
  final Function(DateTime) updateDisplayedMonth;
  final AwesomeTheme theme;
  final LocaleType locale;

  AwesomeCalenDartMonthsView({
    super.key,
    required this.displayedMonth,
    required this.updateDisplayedMonth,
    required this.theme,
    required this.locale,
  });

  @override
  State<AwesomeCalenDartMonthsView> createState() =>
      _AwesomeCalenDartMonthsViewState();
}

class _AwesomeCalenDartMonthsViewState
    extends State<AwesomeCalenDartMonthsView> {
  late List<String> months;

  _getPreviousYear() {
    //TODO
  }

  _getNextYear() {
    //TODO
  }

  @override
  void initState() {
    super.initState();
    months = AwesomeDateUtils.getMonthsNames(widget.locale);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: _getPreviousYear,
              icon: Icon(
                Icons.arrow_back_ios,
                color: widget.theme.buttonColor,
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // TODO widget.updateSelectedView(1);
                },
                child: Text(
                  widget.displayedMonth.year.toString(),
                  textAlign: TextAlign.center,
                  style: widget.theme.yearHeaderTextStyle,
                ),
              ),
            ),
            IconButton(
              onPressed: _getNextYear,
              icon: Icon(
                Icons.arrow_forward_ios,
                color: widget.theme.buttonColor,
              ),
            ),
          ],
        ),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemCount: 12,
          itemBuilder: (context, index) {
            return Text(
              months[index],
            );
          },
        ),
      ],
    );
  }
}
