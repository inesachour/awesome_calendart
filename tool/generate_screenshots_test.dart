// Generates the README screenshots into `images/`.
//
//   flutter test tool/generate_screenshots_test.dart
//
// It renders the real widgets headlessly with Roboto and the Material icon
// font taken from the Flutter SDK (and Arial Unicode for Arabic, macOS only).
// It lives outside `test/` so it does not run with the regular test suite.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:awesome_calendart/awesome_calendart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _pixelRatio = 3.0;
final _month = DateTime(2026, 10, 15);

String get _fontsDir {
  final root = Platform.environment['FLUTTER_ROOT'] ??
      File(Platform.resolvedExecutable).parent.parent.parent.parent.path;
  return '$root/bin/cache/artifacts/material_fonts';
}

Future<void> _loadFont(String family, List<String> paths) async {
  final loader = FontLoader(family);
  for (final path in paths) {
    loader
        .addFont(File(path).readAsBytes().then((b) => ByteData.view(b.buffer)));
  }
  await loader.load();
}

Future<void> _shot(
  WidgetTester tester,
  String name,
  Widget child, {
  Color background = const Color(0xFFEEF1F4),
  double width = 360,
  String fontFamily = 'Roboto',
  Future<void> Function()? before,
}) async {
  final key = GlobalKey();
  tester.view.physicalSize = Size(width * _pixelRatio, 1400 * _pixelRatio);
  tester.view.devicePixelRatio = _pixelRatio;
  addTearDown(tester.view.reset);
  // Tests draw shadows as hard black outlines unless this is turned off.
  debugDisableShadows = false;

  await tester.pumpWidget(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(fontFamily: fontFamily),
    home: Scaffold(
      backgroundColor: background,
      body: Align(
        alignment: Alignment.topLeft,
        child: RepaintBoundary(
          key: key,
          child: Container(
            width: width,
            color: background,
            padding: const EdgeInsets.all(24),
            child: child,
          ),
        ),
      ),
    ),
  ));
  await tester.pumpAndSettle();
  await before?.call();
  await tester.pumpAndSettle();

  await tester.runAsync(() async {
    final boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: _pixelRatio);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    File('images/$name.png').writeAsBytesSync(bytes!.buffer.asUint8List());
  });
  debugDisableShadows = true;
}

void main() {
  setUpAll(() async {
    await _loadFont('Roboto', [
      '$_fontsDir/Roboto-Regular.ttf',
      '$_fontsDir/Roboto-Medium.ttf',
      '$_fontsDir/Roboto-Bold.ttf',
    ]);
    await _loadFont('MaterialIcons', ['$_fontsDir/MaterialIcons-Regular.otf']);
    const arabicFont = '/System/Library/Fonts/Supplemental/Arial Unicode.ttf';
    if (File(arabicFont).existsSync()) {
      await _loadFont('ArabicFont', [arabicFont]);
    }
  });

  final events = [
    AwesomeEvent(date: DateTime(2026, 10, 3), color: Colors.green),
    AwesomeEvent(date: DateTime(2026, 10, 8), color: Colors.blue),
    AwesomeEvent(date: DateTime(2026, 10, 8), color: Colors.amber),
    AwesomeEvent(date: DateTime(2026, 10, 21), color: Colors.purple),
    AwesomeEvent(date: DateTime(2026, 10, 27), color: Colors.green),
  ];

  testWidgets('overview', (tester) async {
    await _shot(
      tester,
      'overview',
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AwesomeCalenDart(
                initialDate: _month, events: events, elevation: 3),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: AwesomeCalenDart(
              initialDate: _month,
              theme: const DarkTheme(),
              events: events,
              elevation: 3,
            ),
          ),
        ],
      ),
      width: 800,
    );
  });

  testWidgets('lightmode', (tester) async {
    await _shot(tester, 'lightmode',
        AwesomeCalenDart(initialDate: _month, events: events));
  });

  testWidgets('darkmode', (tester) async {
    await _shot(
      tester,
      'darkmode',
      AwesomeCalenDart(
        initialDate: _month,
        theme: const DarkTheme(),
        events: events,
      ),
      background: const Color(0xFF1F1F1F),
    );
  });

  testWidgets('range', (tester) async {
    final controller = AwesomeCalenDartController(initialMonth: _month)
      ..selectRange(DateTime(2026, 10, 12), DateTime(2026, 10, 18));
    await _shot(
      tester,
      'range',
      AwesomeCalenDart(
        controller: controller,
        selectionMode: AwesomeSelectionMode.range,
        disabledDates: [DateTime(2026, 10, 7)],
        minDate: DateTime(2026, 10, 5),
      ),
    );
  });

  testWidgets('multiple', (tester) async {
    final controller = AwesomeCalenDartController(initialMonth: _month)
      ..selectDates([
        DateTime(2026, 10, 6),
        DateTime(2026, 10, 13),
        DateTime(2026, 10, 20),
        DateTime(2026, 10, 27),
      ]);
    await _shot(
      tester,
      'multiple',
      AwesomeCalenDart(
        controller: controller,
        selectionMode: AwesomeSelectionMode.multiple,
        firstDayOfWeek: DateTime.sunday,
        showAdjacentMonthDays: true,
        theme: const LightTheme().copyWith(
          selectedDateBackgroundColor: Colors.indigo,
          todayBorderColor: Colors.indigo,
          buttonColor: Colors.indigo,
        ),
      ),
    );
  });

  testWidgets('picker', (tester) async {
    await _shot(
      tester,
      'picker',
      AwesomeCalenDart(initialDate: _month),
      before: () async {
        await tester.tap(find.text('October 2026'));
      },
    );
  });

  testWidgets('arabic', (tester) async {
    await _shot(
      tester,
      'arabic',
      AwesomeCalenDart(initialDate: _month, locale: const Locale('ar')),
      fontFamily: 'ArabicFont',
    );
  });

  testWidgets('custom', (tester) async {
    await _shot(
      tester,
      'custom',
      AwesomeCalenDart(
        initialDate: _month,
        borderRadius: 8,
        theme: const LightTheme().copyWith(
          selectedDateBackgroundColor: Colors.teal,
          buttonColor: Colors.teal,
          yearAndMonthHeaderTextStyle: const TextStyle(
              color: Colors.teal, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        displayFullWeekdayNames: false,
        dayBuilder: (context, day) => Center(
          child: Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: day.isSelected ? Colors.teal : null,
              borderRadius: BorderRadius.circular(8),
              border: day.isToday && !day.isSelected
                  ? Border.all(color: Colors.teal)
                  : null,
            ),
            child: Text(
              '${day.date.day}',
              style: TextStyle(
                color: day.isSelected
                    ? Colors.white
                    : day.date.weekday >= DateTime.saturday
                        ? Colors.redAccent
                        : const Color(0xFF4A5660),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  });
}
