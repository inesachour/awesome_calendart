import 'package:awesome_calendart/awesome_calendart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Awesome CalenDart',
      home: Calendar(),
    );
  }
}

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final controller = AwesomeCalenDartController();
  String rangeText = 'Pick a range';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget section(String title, Widget calendar) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          calendar,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            section('Default', const AwesomeCalenDart()),
            section(
              'Dark, Sunday first, adjacent days, colored events',
              AwesomeCalenDart(
                theme: const DarkTheme(),
                firstDayOfWeek: DateTime.sunday,
                showAdjacentMonthDays: true,
                events: [
                  AwesomeEvent(date: now, color: Colors.greenAccent),
                  AwesomeEvent(date: now, color: Colors.amber),
                  AwesomeEvent(
                      date: now.add(const Duration(days: 3)),
                      color: Colors.lightBlueAccent),
                ],
              ),
            ),
            section(
              'Range selection (French, from today)',
              Column(
                children: [
                  AwesomeCalenDart(
                    locale: const Locale('fr'),
                    selectionMode: AwesomeSelectionMode.range,
                    minDate: now,
                    onRangeChanged: (start, end) => setState(() {
                      rangeText = end == null
                          ? 'From ${start.toIso8601String().substring(0, 10)}…'
                          : '${start.toIso8601String().substring(0, 10)} → '
                              '${end.toIso8601String().substring(0, 10)}';
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(rangeText),
                  ),
                ],
              ),
            ),
            section(
              'Multiple selection (Arabic, right to left)',
              const AwesomeCalenDart(
                locale: Locale('ar'),
                selectionMode: AwesomeSelectionMode.multiple,
              ),
            ),
            section(
              'Controller',
              Column(
                children: [
                  AwesomeCalenDart(controller: controller),
                  Wrap(
                    spacing: 8,
                    children: [
                      TextButton(
                        onPressed: () => controller.selectDate(DateTime.now()),
                        child: const Text('Today'),
                      ),
                      TextButton(
                        onPressed: () =>
                            controller.jumpToMonth(DateTime(now.year + 1, 1)),
                        child: const Text('Next January'),
                      ),
                      TextButton(
                        onPressed: controller.clearSelection,
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            section(
              'Custom day builder and styling',
              AwesomeCalenDart(
                theme: const LightTheme().copyWith(
                  selectedDateBackgroundColor: Colors.teal,
                  todayBorderColor: Colors.teal,
                  buttonColor: Colors.teal,
                ),
                borderRadius: 8,
                dayBuilder: (context, day) => Center(
                  child: Text(
                    '${day.date.day}',
                    style: TextStyle(
                      fontWeight:
                          day.isToday ? FontWeight.bold : FontWeight.normal,
                      color: day.isSelected
                          ? Colors.teal
                          : day.date.weekday >= DateTime.saturday
                              ? Colors.redAccent
                              : null,
                      decoration:
                          day.isSelected ? TextDecoration.underline : null,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
