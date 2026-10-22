import 'package:awesome_calendart/awesome_calendart.dart';
import 'package:awesome_calendart/src/widgets/awesome_calendart_days_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

final _oct2026 = DateTime(2026, 10, 15); // a Thursday

Future<void> pumpCalendar(WidgetTester tester, AwesomeCalenDart calendar,
    {ThemeData? theme}) {
  return tester.pumpWidget(MaterialApp(
    theme: theme,
    home: Scaffold(body: SingleChildScrollView(child: calendar)),
  ));
}

void main() {
  group('week numbers', () {
    testWidgets('are shown per row when enabled', (tester) async {
      await pumpCalendar(tester,
          AwesomeCalenDart(initialDate: _oct2026, showWeekNumbers: true));
      // 1 Oct 2026 is in ISO week 40; rows are weeks 40..44.
      for (final w in ['40', '41', '42', '43', '44']) {
        expect(find.text(w), findsWidgets);
      }
      expect(find.text('45'), findsNothing);
    });

    testWidgets('are hidden by default', (tester) async {
      await pumpCalendar(tester, AwesomeCalenDart(initialDate: _oct2026));
      expect(find.text('44'), findsNothing);
    });
  });

  group('weekends and special dates', () {
    testWidgets('weekendDays drives AwesomeDayDetails.isWeekend',
        (tester) async {
      final weekends = <int>{};
      await pumpCalendar(
          tester,
          AwesomeCalenDart(
            initialDate: _oct2026,
            weekendDays: const [DateTime.friday, DateTime.saturday],
            dayBuilder: (context, d) {
              if (d.isWeekend) weekends.add(d.date.weekday);
              return Text('${d.date.day}');
            },
          ));
      expect(weekends, {DateTime.friday, DateTime.saturday});
    });

    testWidgets('weekendDayTextStyle is applied to weekend days',
        (tester) async {
      await pumpCalendar(
          tester,
          AwesomeCalenDart(
            initialDate: _oct2026,
            theme: const LightTheme().copyWith(
                weekendDayTextStyle: const TextStyle(color: Colors.red)),
          ));
      final saturday = tester.widget<Text>(find.text('3')); // Sat 3 Oct
      expect(saturday.style?.color, Colors.red);
      final monday = tester.widget<Text>(find.text('5'));
      expect(
          monday.style?.color, const LightTheme().unselectedDayTextStyle.color);
    });

    testWidgets('specialDates override the look of a day', (tester) async {
      await pumpCalendar(
          tester,
          AwesomeCalenDart(
            initialDate: _oct2026,
            specialDates: {
              DateTime(2026, 10, 9, 18): const AwesomeDayStyle(
                backgroundColor: Colors.green,
                textStyle: TextStyle(fontWeight: FontWeight.w900),
              ),
            },
          ));
      expect(tester.widget<Text>(find.text('9')).style?.fontWeight,
          FontWeight.w900);
      expect(
        find.byWidgetPredicate((w) =>
            w is Ink &&
            w.decoration is BoxDecoration &&
            (w.decoration as BoxDecoration).color == Colors.green),
        findsOneWidget,
      );
    });
  });

  group('rules', () {
    testWidgets('selectableDayPredicate disables days', (tester) async {
      final picked = <DateTime>[];
      await pumpCalendar(
          tester,
          AwesomeCalenDart(
            initialDate: _oct2026,
            selectableDayPredicate: (d) => d.weekday < DateTime.saturday,
            onDateSelected: picked.add,
          ));
      await tester.tap(find.text('10')); // Saturday
      await tester.tap(find.text('12')); // Monday
      expect(picked, [DateTime(2026, 10, 12)]);
    });

    testWidgets('range length limits and cancelling the pending start',
        (tester) async {
      final controller = AwesomeCalenDartController(initialMonth: _oct2026);
      final calls = <(DateTime, DateTime?)>[];
      await pumpCalendar(
          tester,
          AwesomeCalenDart(
            controller: controller,
            selectionMode: AwesomeSelectionMode.range,
            minRangeLength: 2,
            maxRangeLength: 4,
            onRangeChanged: (s, e) => calls.add((s, e)),
          ));
      Future<void> tap(String day) async {
        await tester.tap(find.text(day));
        await tester.pump();
      }

      await tap('10'); // start
      await tap('11'); // too short: ignored
      await tap('15'); // too long: ignored
      await tap('13'); // 3 days: ok
      expect(calls, [
        (DateTime(2026, 10, 10), null),
        (DateTime(2026, 10, 10), DateTime(2026, 10, 13)),
      ]);

      await tap('20'); // new range
      await tap('20'); // tapping the start cancels it
      expect(controller.rangeStart, isNull);
      expect(calls.length, 3);
    });
  });

  group('calendar format', () {
    testWidgets('week shows seven days and moves by a week', (tester) async {
      await pumpCalendar(
          tester,
          AwesomeCalenDart(
            initialDate: _oct2026,
            calendarFormat: AwesomeCalendarFormat.week,
          ));
      expect(find.text('12'), findsOneWidget); // Monday
      expect(find.text('18'), findsOneWidget); // Sunday
      expect(find.text('11'), findsNothing);
      expect(find.text('19'), findsNothing);
      await tester.tap(find.byIcon(Icons.arrow_forward_ios));
      await tester.pumpAndSettle();
      expect(find.text('19'), findsOneWidget);
      expect(find.text('25'), findsOneWidget);
      expect(find.text('12'), findsNothing);
    });

    testWidgets('two weeks shows fourteen days', (tester) async {
      await pumpCalendar(
          tester,
          AwesomeCalenDart(
            initialDate: _oct2026,
            calendarFormat: AwesomeCalendarFormat.twoWeeks,
          ));
      expect(find.text('12'), findsOneWidget);
      expect(find.text('25'), findsOneWidget);
      expect(find.text('26'), findsNothing);
    });

    testWidgets('the format button cycles the format', (tester) async {
      final formats = <AwesomeCalendarFormat>[];
      await pumpCalendar(
          tester,
          AwesomeCalenDart(
            initialDate: _oct2026,
            showFormatButton: true,
            onFormatChanged: formats.add,
          ));
      await tester.tap(find.byTooltip('Change view'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Change view'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Change view'));
      await tester.pumpAndSettle();
      expect(formats, [
        AwesomeCalendarFormat.twoWeeks,
        AwesomeCalendarFormat.week,
        AwesomeCalendarFormat.month,
      ]);
      expect(find.text('1'), findsWidgets); // back to the whole month
      expect(find.text('31'), findsOneWidget);
    });

    testWidgets('week navigation stops at minDate', (tester) async {
      await pumpCalendar(
          tester,
          AwesomeCalenDart(
            initialDate: _oct2026,
            calendarFormat: AwesomeCalendarFormat.week,
            minDate: DateTime(2026, 10, 12),
          ));
      final previous = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.arrow_back_ios));
      expect(previous.onPressed, isNull);
    });
  });

  group('event list', () {
    testWidgets('shows the labels of the selected day', (tester) async {
      await pumpCalendar(
          tester,
          AwesomeCalenDart(
            initialDate: _oct2026,
            showEventList: true,
            events: [
              AwesomeEvent(date: DateTime(2026, 10, 15), label: 'Dentist'),
              AwesomeEvent(date: DateTime(2026, 10, 20), label: 'Gym'),
            ],
          ));
      expect(find.text('Dentist'), findsOneWidget);
      expect(find.text('Gym'), findsNothing);
      await tester.tap(find.text('20'));
      await tester.pumpAndSettle();
      expect(find.text('Gym'), findsOneWidget);
      expect(find.text('Dentist'), findsNothing);
    });

    testWidgets('eventListBuilder receives the day and its events',
        (tester) async {
      DateTime? seenDate;
      int? seenCount;
      await pumpCalendar(
          tester,
          AwesomeCalenDart(
            initialDate: _oct2026,
            events: [AwesomeEvent(date: _oct2026)],
            eventListBuilder: (context, date, events) {
              seenDate = date;
              seenCount = events.length;
              return const Text('agenda');
            },
          ));
      expect(find.text('agenda'), findsOneWidget);
      expect(seenDate, DateTime(2026, 10, 15));
      expect(seenCount, 1);
    });
  });

  group('keyboard', () {
    Future<void> focusGrid(WidgetTester tester) async {
      Focus.of(tester.element(find.byType(AwesomeCalenDartDaysView)))
          .requestFocus();
      await tester.pump();
    }

    testWidgets('arrows move, Enter selects, across months', (tester) async {
      final picked = <DateTime>[];
      await pumpCalendar(tester,
          AwesomeCalenDart(initialDate: _oct2026, onDateSelected: picked.add));
      await focusGrid(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(picked, [DateTime(2026, 10, 17)]);

      for (var i = 0; i < 3; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown); // 7 Nov
      }
      await tester.pumpAndSettle();
      expect(find.text('November 2026'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.pageDown);
      await tester.pumpAndSettle();
      expect(find.text('December 2026'), findsOneWidget);
    });

    testWidgets('can be turned off', (tester) async {
      final picked = <DateTime>[];
      await pumpCalendar(
          tester,
          AwesomeCalenDart(
            initialDate: _oct2026,
            enableKeyboardNavigation: false,
            onDateSelected: picked.add,
          ));
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(picked, isEmpty);
    });
  });

  group('builders', () {
    testWidgets('headerBuilder and weekdayBuilder replace the defaults',
        (tester) async {
      await pumpCalendar(
          tester,
          AwesomeCalenDart(
            initialDate: _oct2026,
            headerBuilder: (context, header) => TextButton(
              onPressed: header.goToNext,
              child: Text('H:${header.title}'),
            ),
            weekdayBuilder: (context, weekday, label) => Text('W$weekday'),
          ));
      expect(find.text('H:October 2026'), findsOneWidget);
      for (var i = 1; i <= 7; i++) {
        expect(find.text('W$i'), findsOneWidget);
      }
      expect(find.text('Mon'), findsNothing);
      await tester.tap(find.text('H:October 2026'));
      await tester.pumpAndSettle();
      expect(find.text('H:November 2026'), findsOneWidget);
    });
  });

  group('digits', () {
    testWidgets('follow the locale by default (Arabic-Indic for ar)',
        (tester) async {
      await pumpCalendar(tester,
          AwesomeCalenDart(initialDate: _oct2026, locale: const Locale('ar')));
      expect(find.text('\u0661\u0665'), findsOneWidget); // 15
      expect(find.text('15'), findsNothing);
    });

    testWidgets('useLocaleDigits: false keeps 0-9', (tester) async {
      await pumpCalendar(
          tester,
          AwesomeCalenDart(
            initialDate: _oct2026,
            locale: const Locale('ar'),
            useLocaleDigits: false,
          ));
      expect(find.text('15'), findsOneWidget);
    });

    testWidgets('English is unaffected', (tester) async {
      await pumpCalendar(tester, AwesomeCalenDart(initialDate: _oct2026));
      expect(find.text('15'), findsOneWidget);
    });
  });

  group('theme', () {
    testWidgets('is read from ThemeData.extensions', (tester) async {
      await pumpCalendar(tester, const AwesomeCalenDart(),
          theme: ThemeData(extensions: const [DarkTheme()]));
      final material = tester.widget<Material>(find.byType(Material).at(1));
      expect(material.color, const DarkTheme().backgroundColor);
    });

    testWidgets('an explicit theme wins over the extension', (tester) async {
      await pumpCalendar(tester, const AwesomeCalenDart(theme: LightTheme()),
          theme: ThemeData(extensions: const [DarkTheme()]));
      final material = tester.widget<Material>(find.byType(Material).at(1));
      expect(material.color, const LightTheme().backgroundColor);
    });

    test('equality, hashCode and lerp', () {
      expect(const LightTheme(), const AwesomeTheme());
      expect(const LightTheme().hashCode, const AwesomeTheme().hashCode);
      expect(const LightTheme() == const DarkTheme(), isFalse);
      expect(const LightTheme().copyWith(buttonColor: Colors.red),
          isNot(const LightTheme()));
      final mid = const LightTheme().lerp(const DarkTheme(), 0.5);
      expect(
          mid.buttonColor,
          Color.lerp(const LightTheme().buttonColor,
              const DarkTheme().buttonColor, 0.5));
      expect(const LightTheme().lerp(null, 0.5), const LightTheme());
    });
  });
}
