import 'package:awesome_calendart/awesome_calendart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final _oct2026 = DateTime(2026, 10, 15);

Future<void> pumpCalendar(WidgetTester tester, AwesomeCalenDart calendar) {
  return tester.pumpWidget(MaterialApp(
    home: Scaffold(body: SingleChildScrollView(child: calendar)),
  ));
}

void main() {
  group('selection', () {
    testWidgets('single: tapping a day calls onDateSelected', (tester) async {
      DateTime? picked;
      await pumpCalendar(
          tester,
          AwesomeCalenDart(
            initialDate: _oct2026,
            onDateSelected: (d) => picked = d,
          ));
      await tester.tap(find.text('20'));
      expect(picked, DateTime(2026, 10, 20));
    });

    testWidgets('multiple: taps toggle dates', (tester) async {
      List<DateTime> last = [];
      await pumpCalendar(
          tester,
          AwesomeCalenDart(
            initialDate: _oct2026,
            selectionMode: AwesomeSelectionMode.multiple,
            onDatesChanged: (d) => last = d,
          ));
      await tester.tap(find.text('3'));
      await tester.tap(find.text('5'));
      expect(last, [DateTime(2026, 10, 3), DateTime(2026, 10, 5)]);
      await tester.tap(find.text('3'));
      expect(last, [DateTime(2026, 10, 5)]);
    });

    testWidgets('range: start, end, then a new range', (tester) async {
      final calls = <(DateTime, DateTime?)>[];
      final controller = AwesomeCalenDartController();
      await pumpCalendar(
          tester,
          AwesomeCalenDart(
            controller: controller,
            initialDate: _oct2026,
            selectionMode: AwesomeSelectionMode.range,
            onRangeChanged: (s, e) => calls.add((s, e)),
          ));
      controller.jumpToMonth(_oct2026);
      await tester.pumpAndSettle();
      await tester.tap(find.text('10'));
      await tester.tap(find.text('14'));
      await tester.tap(find.text('20'));
      expect(calls, [
        (DateTime(2026, 10, 10), null),
        (DateTime(2026, 10, 10), DateTime(2026, 10, 14)),
        (DateTime(2026, 10, 20), null),
      ]);
      expect(controller.selectedRange, isNull);
    });
  });

  group('limits', () {
    testWidgets('days outside min/max and disabled dates are not selectable',
        (tester) async {
      final picked = <DateTime>[];
      await pumpCalendar(
          tester,
          AwesomeCalenDart(
            initialDate: _oct2026,
            minDate: DateTime(2026, 10, 10),
            maxDate: DateTime(2026, 10, 25),
            disabledDates: [DateTime(2026, 10, 15)],
            onDateSelected: picked.add,
          ));
      await tester.tap(find.text('5'));
      await tester.tap(find.text('28'));
      await tester.tap(find.text('15'));
      await tester.tap(find.text('16'));
      expect(picked, [DateTime(2026, 10, 16)]);
    });

    testWidgets('navigation stops at the min and max months', (tester) async {
      await pumpCalendar(
          tester,
          AwesomeCalenDart(
            initialDate: _oct2026,
            minDate: DateTime(2026, 10, 1),
            maxDate: DateTime(2026, 11, 30),
          ));
      final previous = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.arrow_back_ios));
      expect(previous.onPressed, isNull);
      await tester.tap(find.byIcon(Icons.arrow_forward_ios));
      await tester.pumpAndSettle();
      expect(find.text('November 2026'), findsOneWidget);
      final next = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.arrow_forward_ios));
      expect(next.onPressed, isNull);
    });
  });

  group('navigation', () {
    testWidgets('buttons change the month and fire onMonthChanged',
        (tester) async {
      DateTime? month;
      await pumpCalendar(
          tester,
          AwesomeCalenDart(
            initialDate: _oct2026,
            onMonthChanged: (m) => month = m,
          ));
      await tester.tap(find.byIcon(Icons.arrow_forward_ios));
      await tester.pumpAndSettle();
      expect(find.text('November 2026'), findsOneWidget);
      expect(month, DateTime(2026, 11));
    });

    testWidgets('swiping changes the month', (tester) async {
      await pumpCalendar(tester, AwesomeCalenDart(initialDate: _oct2026));
      await tester.fling(find.text('15'), const Offset(-300, 0), 1000);
      await tester.pumpAndSettle();
      expect(find.text('November 2026'), findsOneWidget);
    });

    testWidgets('swipe can be disabled', (tester) async {
      await pumpCalendar(
          tester, AwesomeCalenDart(initialDate: _oct2026, enableSwipe: false));
      await tester.fling(find.text('15'), const Offset(-300, 0), 1000);
      await tester.pumpAndSettle();
      expect(find.text('October 2026'), findsOneWidget);
    });

    testWidgets('month and year pickers jump to a month', (tester) async {
      await pumpCalendar(tester, AwesomeCalenDart(initialDate: _oct2026));
      await tester.tap(find.text('October 2026'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('2026')); // open the year picker
      await tester.pumpAndSettle();
      expect(find.text('2016 - 2027'), findsOneWidget);
      await tester.tap(find.text('2020'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mar'));
      await tester.pumpAndSettle();
      expect(find.text('March 2020'), findsOneWidget);
    });

    testWidgets('the picker can be disabled', (tester) async {
      await pumpCalendar(
          tester,
          AwesomeCalenDart(
              initialDate: _oct2026, enableMonthYearPicker: false));
      await tester.tap(find.text('October 2026'));
      await tester.pumpAndSettle();
      expect(find.text('October 2026'), findsOneWidget);
      expect(find.text('Mar'), findsNothing);
    });
  });

  group('controller', () {
    testWidgets('reads and changes state from code', (tester) async {
      final controller = AwesomeCalenDartController();
      await pumpCalendar(tester, AwesomeCalenDart(controller: controller));
      controller.selectDate(DateTime(2027, 3, 14, 9, 30));
      await tester.pumpAndSettle();
      expect(find.text('March 2027'), findsOneWidget);
      expect(controller.selectedDate, DateTime(2027, 3, 14));
      controller.clearSelection();
      expect(controller.selectedDates, isEmpty);
      controller.dispose();
    });
  });

  group('layout and customization', () {
    testWidgets('first day of week and weekday labels', (tester) async {
      await pumpCalendar(
          tester,
          AwesomeCalenDart(
            initialDate: _oct2026,
            firstDayOfWeek: DateTime.sunday,
          ));
      final labels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
      final xs = [for (final l in labels) tester.getCenter(find.text(l)).dx];
      expect(xs, orderedEquals([...xs]..sort()));
      // 1 October 2026 is a Thursday: it sits under "Thu".
      expect(tester.getCenter(find.text('1')).dx, closeTo(xs[4], 1));
    });

    testWidgets('adjacent month days are optional', (tester) async {
      await pumpCalendar(tester, AwesomeCalenDart(initialDate: _oct2026));
      expect(find.text('30'), findsOneWidget); // only 30 Oct
      await pumpCalendar(tester,
          AwesomeCalenDart(initialDate: _oct2026, showAdjacentMonthDays: true));
      expect(find.text('30'), findsNWidgets(2)); // 30 Sep and 30 Oct
    });

    testWidgets('tapping an adjacent day shows its month', (tester) async {
      await pumpCalendar(tester,
          AwesomeCalenDart(initialDate: _oct2026, showAdjacentMonthDays: true));
      await tester.tap(find.text('1').last); // 1 November (last cell)
      await tester.pumpAndSettle();
      expect(find.text('November 2026'), findsOneWidget);
    });

    testWidgets('dayBuilder, events and custom header', (tester) async {
      await pumpCalendar(
          tester,
          AwesomeCalenDart(
            initialDate: _oct2026,
            events: [
              AwesomeEvent(date: DateTime(2026, 10, 3), color: Colors.green)
            ],
            eventMarkers: [DateTime(2026, 10, 4)],
            monthYearFormatter: (m, l) => 'M${m.month}/${m.year}',
            dayBuilder: (context, d) => Text('d${d.date.day}'),
          ));
      expect(find.text('M10/2026'), findsOneWidget);
      expect(find.text('d3'), findsOneWidget);
    });

    testWidgets('right-to-left locales mirror the layout', (tester) async {
      await pumpCalendar(tester,
          AwesomeCalenDart(initialDate: _oct2026, locale: const Locale('ar')));
      final dir =
          Directionality.of(tester.element(find.byType(AwesomeCalenDart)));
      // Directionality is set inside the calendar, below this element.
      final inner =
          Directionality.of(tester.element(find.byType(GridView).first));
      expect(inner, TextDirection.rtl);
      expect(dir, TextDirection.ltr);
    });

    testWidgets('theme changes apply at runtime', (tester) async {
      await pumpCalendar(tester, const AwesomeCalenDart());
      var material = tester.widget<Material>(find.byType(Material).at(1));
      expect(material.color, const LightTheme().backgroundColor);
      await pumpCalendar(tester, const AwesomeCalenDart(theme: DarkTheme()));
      material = tester.widget<Material>(find.byType(Material).at(1));
      expect(material.color, const DarkTheme().backgroundColor);
    });
  });

  test('theme copyWith overrides only given fields', () {
    final t = const DarkTheme().copyWith(buttonColor: Colors.red);
    expect(t.buttonColor, Colors.red);
    expect(t.backgroundColor, const DarkTheme().backgroundColor);
  });
}
