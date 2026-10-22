// Compiles and runs the code examples of README.md, so they cannot rot.
//
// The examples are copied verbatim. When you change one in README.md, change
// it here too: the last test fails when the two drift apart.
// ignore_for_file: avoid_print, prefer_const_constructors
import 'dart:io';

import 'package:awesome_calendart/awesome_calendart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Values the examples refer to.
final bookedDates = <DateTime>[DateTime.now().add(const Duration(days: 3))];
final myEvents = <AwesomeEvent>[
  AwesomeEvent(date: DateTime.now(), label: 'Stand-up', color: Colors.blue),
];
final controller = AwesomeCalenDartController();

/// Examples that are a single widget: they are also pumped.
final widgetExamples = <Widget Function()>[
  () => AwesomeCalenDart(
        selectionMode: AwesomeSelectionMode.range,
        minDate: DateTime.now(),
        maxDate: DateTime.now().add(const Duration(days: 365)),
        minRangeLength: 2,
        maxRangeLength: 14,
        disabledDates: bookedDates, // a List<DateTime>
        showAdjacentMonthDays: true,
        onRangeChanged: (start, end) {
          if (end != null) print('Book from $start to $end');
        },
      ),
  () => AwesomeCalenDart(
        initialDate: DateTime(1995, 6, 15),
        maxDate: DateTime.now(),
        highlightToday: false,
        onDateSelected: (birthday) => print(birthday),
      ),
  () => AwesomeCalenDart(
        selectionMode:
            AwesomeSelectionMode.range, // single (default), multiple, range
        onRangeChanged: (start, end) {}, // end is null until the 2nd tap
      ),
  () => AwesomeCalenDart(
        minDate: DateTime.now(),
        maxDate: DateTime(2027, 12, 31),
        disabledDates: [DateTime(2026, 12, 25)],
        selectableDayPredicate: (day) =>
            day.weekday < DateTime.saturday, // weekdays only
      ),
  () => AwesomeCalenDart(
        selectionMode: AwesomeSelectionMode.range,
        minRangeLength: 2, // at least 2 days between start and end ("2 nights")
        maxRangeLength: 14,
      ),
  () => AwesomeCalenDart(
        calendarFormat:
            AwesomeCalendarFormat.week, // month (default), twoWeeks, week
        showFormatButton: true, // header button cycling the formats
        onFormatChanged: (format) {},
      ),
  () => AwesomeCalenDart(
        eventMarkers: [DateTime(2026, 10, 3)], // simple dots
        events: [
          // colored, with a label
          AwesomeEvent(
              date: DateTime(2026, 10, 5),
              color: Colors.green,
              label: 'Dentist'),
          AwesomeEvent(date: DateTime(2026, 10, 5), color: Colors.amber),
        ],
        showEventList: true, // list the selected day's events below
      ),
  () => AwesomeCalenDart(
        events: myEvents,
        eventListBuilder: (context, date, events) => Column(
          children: [
            for (final e in events) ListTile(title: Text(e.label ?? ''))
          ],
        ),
      ),
  () => AwesomeCalenDart(
        showWeekNumbers: true, // ISO week numbers
        weekendDays: const [
          DateTime.friday,
          DateTime.saturday
        ], // default: Saturday, Sunday
        theme: const LightTheme().copyWith(
          weekendDayTextStyle: const TextStyle(color: Colors.red),
        ),
        specialDates: {
          DateTime(2026, 12, 25): const AwesomeDayStyle(
            backgroundColor: Color(0x3300AA55),
            textStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        },
      ),
  () => AwesomeCalenDart(
        theme: const DarkTheme().copyWith(
          selectedDateBackgroundColor: Colors.teal,
          todayBorderColor: Colors.teal,
        ),
      ),
  () => AwesomeCalenDart(
        dayBuilder: (context, day) => Center(
          child: Text(
            '${day.date.day}',
            style: TextStyle(
              color: day.isSelected ? Colors.teal : null,
              fontWeight: day.isToday ? FontWeight.bold : null,
            ),
          ),
        ),
      ),
  () => AwesomeCalenDart(
        headerBuilder: (context, header) => Row(
          children: [
            IconButton(
                onPressed: header.canGoPrevious ? header.goToPrevious : null,
                icon: const Icon(Icons.chevron_left)),
            Expanded(
                child: TextButton(
                    onPressed: header.openPicker, child: Text(header.title))),
            IconButton(
                onPressed: header.canGoNext ? header.goToNext : null,
                icon: const Icon(Icons.chevron_right)),
          ],
        ),
        weekdayBuilder: (context, weekday, label) =>
            Center(child: Text(label[0])), // M T W T F S S
      ),
  () =>
      // Any locale supported by intl works: de, es, it, pl, ar, ja, ...
      AwesomeCalenDart(locale: const Locale('fr')),
  () => AwesomeCalenDart(locale: const Locale('ar'), useLocaleDigits: false),
];

/// Examples that are statements, or an app: they only have to compile.
final compileOnlyExamples = <void Function()>[
  () => MaterialApp(
        theme: ThemeData(extensions: const [LightTheme()]),
        darkTheme: ThemeData.dark().copyWith(extensions: const [DarkTheme()]),
      ),
  () {
    final controller = AwesomeCalenDartController();

    Column(
      children: [
        AwesomeCalenDart(
          controller: controller,
          events: myEvents, // a List<AwesomeEvent>
          eventListBuilder: (context, date, dayEvents) => Column(
            children: [
              for (final event in dayEvents)
                ListTile(
                  leading: Icon(Icons.circle, color: event.color, size: 12),
                  title: Text(event.label ?? 'Event'),
                ),
            ],
          ),
        ),
        TextButton(
          onPressed: () => controller.selectDate(DateTime.now()),
          child: const Text('Today'),
        ),
      ],
    );
  },
  () {
    final controller = AwesomeCalenDartController();

    AwesomeCalenDart(controller: controller);

    controller.jumpToMonth(DateTime(2027, 3));
    controller.jumpToDate(
        DateTime(2027, 3, 14)); // the month, or the week in the week formats
    controller.selectDate(DateTime(2027, 3, 14));
    controller.selectRange(DateTime(2027, 3, 1), DateTime(2027, 3, 7));
    print(controller
        .selectedDate); // also: selectedDates, selectedRange, visibleMonth
    controller.clearSelection();
  },
];

String _squash(String text) => text.replaceAll(RegExp(r'\s'), '');

void main() {
  testWidgets('README widget examples build without errors', (tester) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    for (final example in widgetExamples) {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: example())),
      ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(AwesomeCalenDart), findsOneWidget);
    }
  });

  test('every example in README.md is in this file', () {
    final readme = File('README.md').readAsStringSync();
    final here =
        _squash(File('test/readme_snippets_test.dart').readAsStringSync());
    final blocks = RegExp(r'```dart\n(.*?)```', dotAll: true)
        .allMatches(readme)
        .map((m) => m.group(1)!)
        .where((code) => !code.startsWith('import '));

    expect(blocks, isNotEmpty);
    for (final code in blocks) {
      expect(here.contains(_squash(code)), isTrue,
          reason: 'README example is missing from this file:\n$code');
    }
  });
}
