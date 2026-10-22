import 'package:awesome_calendart/src/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('first weekday offset follows the first day of the week', () {
    final oct2026 = DateTime(2026, 10); // a Thursday
    expect(AwesomeDateUtils.getFirstWeekdayOffset(oct2026), 3);
    expect(AwesomeDateUtils.getFirstWeekdayOffset(oct2026, DateTime.sunday), 4);
    expect(
        AwesomeDateUtils.getFirstWeekdayOffset(oct2026, DateTime.thursday), 0);
    expect(AwesomeDateUtils.getFirstWeekdayOffset(DateTime(2026, 2)), 6);
  });

  test('previous/next month wrap the year', () {
    expect(AwesomeDateUtils.getPreviousMonth(DateTime(2026, 1, 15)),
        DateTime(2025, 12));
    expect(AwesomeDateUtils.getNextMonth(DateTime(2026, 12, 15)),
        DateTime(2027, 1));
  });

  test('weekday names start at the requested day', () {
    const en = Locale('en');
    expect(AwesomeDateUtils.getWeekdayNames(en, full: false).first, 'Mon');
    expect(
        AwesomeDateUtils.getWeekdayNames(en,
                full: true, firstDayOfWeek: DateTime.sunday)
            .first,
        'Sunday');
    expect(AwesomeDateUtils.getWeekdayNames(en, full: false).length, 7);
  });

  test('names are localized and capitalized, with fallbacks', () {
    expect(AwesomeDateUtils.monthName(1, const Locale('fr')), 'Janvier');
    expect(AwesomeDateUtils.monthName(3, const Locale('pl')), 'Marzec');
    // Unknown country falls back to the language, unknown language to English.
    expect(AwesomeDateUtils.monthName(1, const Locale('fr', 'ZZ')), 'Janvier');
    expect(AwesomeDateUtils.monthName(1, const Locale('xx')), 'January');
    expect(AwesomeDateUtils.isRtl(const Locale('ar')), isTrue);
    expect(AwesomeDateUtils.isRtl(const Locale('en')), isFalse);
  });

  test('ISO week numbers', () {
    expect(AwesomeDateUtils.isoWeekNumber(DateTime(2026, 1, 1)), 1);
    expect(AwesomeDateUtils.isoWeekNumber(DateTime(2026, 10, 15)), 42);
    expect(AwesomeDateUtils.isoWeekNumber(DateTime(2026, 12, 31)), 53);
    expect(AwesomeDateUtils.isoWeekNumber(DateTime(2021, 1, 3)), 53);
    expect(AwesomeDateUtils.isoWeekNumber(DateTime(2024, 12, 30)), 1);
  });

  test('start of week', () {
    final thu = DateTime(2026, 10, 15);
    expect(AwesomeDateUtils.startOfWeek(thu, DateTime.monday),
        DateTime(2026, 10, 12));
    expect(AwesomeDateUtils.startOfWeek(thu, DateTime.sunday),
        DateTime(2026, 10, 11));
    expect(AwesomeDateUtils.startOfWeek(thu, DateTime.thursday), thu);
  });

  test('locale digits follow intl, and can be turned off', () {
    const egypt = Locale('ar', 'EG');
    expect(AwesomeDateUtils.formatNumber(2026, egypt, localeDigits: false),
        '2026');
    expect(AwesomeDateUtils.formatNumber(2026, egypt, localeDigits: true),
        '\u0662\u0660\u0662\u0666');
    // Every Arabic locale gets Arabic-Indic digits, even the generic `ar`.
    for (final ar in [const Locale('ar'), const Locale('ar', 'TN')]) {
      expect(AwesomeDateUtils.formatNumber(2026, ar, localeDigits: true),
          '\u0662\u0660\u0662\u0666');
      expect(
          AwesomeDateUtils.formatNumber(2026, ar, localeDigits: false), '2026');
    }
    expect(
        AwesomeDateUtils.formatNumber(2026, const Locale('fa'),
            localeDigits: true),
        '\u06f2\u06f0\u06f2\u06f6');
    expect(
        AwesomeDateUtils.formatNumber(2026, const Locale('en'),
            localeDigits: true),
        '2026');
    expect(
        AwesomeDateUtils.formatNumber(7, const Locale('xx'),
            localeDigits: true),
        '7');
  });
}
