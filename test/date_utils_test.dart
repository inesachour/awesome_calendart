import 'package:awesome_calendart/src/utils/date_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('first weekday offset is Monday-based', () {
    expect(AwesomeDateUtils.getFirstWeekdayOffset(DateTime(2026, 10)), 3);
    expect(AwesomeDateUtils.getFirstWeekdayOffset(DateTime(2026, 6)), 0);
    expect(AwesomeDateUtils.getFirstWeekdayOffset(DateTime(2026, 2)), 6);
  });

  test('previous/next month wrap the year', () {
    expect(AwesomeDateUtils.getPreviousMonth(DateTime(2026, 1, 15)),
        DateTime(2025, 12));
    expect(AwesomeDateUtils.getNextMonth(DateTime(2026, 12, 15)),
        DateTime(2027, 1));
  });
}
