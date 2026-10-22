import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart' show dateTimeSymbolMap;
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart' show Bidi, toBeginningOfSentenceCase;

/// Date helpers and locale-aware names used by the calendar.
class AwesomeDateUtils {
  static Map<String, DateSymbols>? _symbols;

  /// The `intl` symbols for [locale], falling back from
  /// `language_COUNTRY` to `language`, and finally to English.
  static DateSymbols symbolsFor(Locale locale) {
    final map = _symbols ??= dateTimeSymbolMap();
    final candidates = [
      locale.toString(),
      if (locale.countryCode != null)
        '${locale.languageCode}_${locale.countryCode}',
      locale.languageCode,
    ];
    for (final key in candidates) {
      final found = map[key];
      if (found != null) return found;
    }
    return map['en']!;
  }

  /// Whether [locale] is written right to left.
  static bool isRtl(Locale locale) => Bidi.isRtlLanguage(locale.languageCode);

  static String _cap(String s, Locale locale) =>
      toBeginningOfSentenceCase(s, locale.toString()) ?? s;

  /// Removes the date only: the time part is dropped.
  static DateTime dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  /// The first day of the month of [date].
  static DateTime firstOfMonth(DateTime date) =>
      DateTime(date.year, date.month, 1);

  /// Whether two dates are in the same month of the same year.
  static bool isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  static String getMonthAndYear(DateTime date, Locale locale) {
    return "${monthName(date.month, locale)} ${date.year}";
  }

  static DateTime getNextMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 1);
  }

  static DateTime getPreviousMonth(DateTime date) {
    return DateTime(date.year, date.month - 1, 1);
  }

  static int getDaysInMonth(DateTime date) {
    return DateUtils.getDaysInMonth(date.year, date.month);
  }

  /// Number of cells before the 1st of the month, when weeks start on
  /// [firstDayOfWeek] (a [DateTime.monday]..[DateTime.sunday] constant).
  static int getFirstWeekdayOffset(DateTime month,
      [int firstDayOfWeek = DateTime.monday]) {
    final weekday = DateTime(month.year, month.month, 1).weekday;
    return (weekday - firstDayOfWeek + 7) % 7;
  }

  /// Weekday labels in display order, starting at [firstDayOfWeek].
  static List<String> getWeekdayNames(
    Locale locale, {
    required bool full,
    int firstDayOfWeek = DateTime.monday,
  }) {
    final s = symbolsFor(locale);
    // intl lists weekdays starting on Sunday.
    final names = full ? s.STANDALONEWEEKDAYS : s.STANDALONESHORTWEEKDAYS;
    return List.generate(
        7, (i) => _cap(names[(firstDayOfWeek + i) % 7], locale));
  }

  /// The name of [month] (1-12).
  static String monthName(int month, Locale locale) =>
      _cap(symbolsFor(locale).STANDALONEMONTHS[month - 1], locale);

  /// The short name of [month] (1-12).
  static String shortMonthName(int month, Locale locale) =>
      _cap(symbolsFor(locale).STANDALONESHORTMONTHS[month - 1], locale);
}
