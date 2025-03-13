import 'package:flutter/material.dart';

class AwesomeCalenDartMonthsView extends StatefulWidget {
  DateTime displayedMonth;
  final Function(DateTime) updateDisplayedMonth;
  List<String> months;

  AwesomeCalenDartMonthsView({
    super.key,
    required this.displayedMonth,
    required this.updateDisplayedMonth,
    required this.months,
  });

  @override
  State<AwesomeCalenDartMonthsView> createState() =>
      _AwesomeCalenDartMonthsViewState();
}

class _AwesomeCalenDartMonthsViewState
    extends State<AwesomeCalenDartMonthsView> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: 12,
      itemBuilder: (context, index) {
        Container(
          child: Text(
            widget.months[index],
          ),
        );
      },
    );
  }
}
