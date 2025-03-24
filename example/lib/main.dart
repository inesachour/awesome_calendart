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
      title: 'Flutter Demo',
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            padding: const EdgeInsets.all(5),
            child: AwesomeCalenDart(),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            padding: const EdgeInsets.all(5),
            child: AwesomeCalenDart(
              theme: DarkTheme(),
            ),
          ),
        ],
      ),
    );
  }
}
