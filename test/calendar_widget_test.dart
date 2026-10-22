import 'package:awesome_calendart/awesome_calendart.dart';
import 'package:awesome_calendart/src/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pump(WidgetTester tester, {ValueChanged<DateTime>? onSelected}) {
    return tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: AwesomeCalenDart(onDateSelected: onSelected),
        ),
      ),
    ));
  }

  testWidgets('tapping a day calls onDateSelected', (tester) async {
    DateTime? picked;
    await pump(tester, onSelected: (d) => picked = d);
    await tester.tap(find.text('15'));
    expect(picked?.day, 15);
  });

  testWidgets('next button changes the month', (tester) async {
    await pump(tester);
    final now = DateTime.now();
    final next = DateTime(now.year, now.month + 1);
    await tester.tap(find.byIcon(Icons.arrow_forward_ios));
    await tester.pump();
    expect(find.text(AwesomeDateUtils.getMonthAndYear(next, LocaleType.en)),
        findsOneWidget);
  });

  test('copyWith overrides only given fields', () {
    final t = DarkTheme().copyWith(buttonColor: Colors.red);
    expect(t.buttonColor, Colors.red);
    expect(t.backgroundColor, DarkTheme().backgroundColor);
  });
}
