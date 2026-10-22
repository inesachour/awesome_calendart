// Internal, not exported by the package: the public API is documented in
// the exported files.
// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart' show dateTimeSymbolMap;
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart'
    show Bidi, NumberFormat, toBeginningOfSentenceCase;

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

  static String getMonthAndYear(DateTime date, Locale locale,
      {bool localeDigits = false}) {
    return "${monthName(date.month, locale)} "
        "${formatNumber(date.year, locale, localeDigits: localeDigits)}";
  }

  /// Formats [value] with the digits of [locale] when [localeDigits] is true,
  /// and with 0-9 otherwise.
  ///
  /// The digits are the ones `intl` defines for the locale (Persian for `fa`,
  /// Bengali for `bn`, ...). Arabic is the exception: `intl` uses 0-9 for the
  /// generic `ar`, but every Arabic locale shows Arabic-Indic digits here.
  static String formatNumber(int value, Locale locale,
      {required bool localeDigits}) {
    if (!localeDigits) return '$value';
    final candidates = [
      locale.toString(),
      if (locale.countryCode != null)
        '${locale.languageCode}_${locale.countryCode}',
      locale.languageCode,
    ];
    for (final key in candidates) {
      if (NumberFormat.localeExists(key)) {
        // intl's generic `ar` has Western digits; ar_EG has Arabic-Indic ones.
        final resolved = key == 'ar' ? 'ar_EG' : key;
        return NumberFormat('###0', resolved).format(value);
      }
    }
    return '$value';
  }

  /// The first day of the week containing [date], when weeks start on
  /// [firstDayOfWeek].
  static DateTime startOfWeek(DateTime date, int firstDayOfWeek) {
    final offset = (date.weekday - firstDayOfWeek + 7) % 7;
    return DateTime(date.year, date.month, date.day - offset);
  }

  /// The ISO 8601 week number (1-53) of [date].
  static int isoWeekNumber(DateTime date) {
    // The week belongs to the year of its Thursday.
    final thursday = DateTime.utc(date.year, date.month, date.day)
        .add(Duration(days: DateTime.thursday - date.weekday));
    final firstThursday = DateTime.utc(thursday.year, 1, 1).add(Duration(
        days: (DateTime.thursday -
                DateTime.utc(thursday.year, 1, 1).weekday +
                7) %
            7));
    return 1 + thursday.difference(firstThursday).inDays ~/ 7;
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
