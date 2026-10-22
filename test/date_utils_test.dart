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
}
