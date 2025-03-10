import 'package:intl/intl.dart';

class AwesomeDateUtils {
  static String getMonthAndYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  static DateTime getNextMonth(DateTime date) {
    if (date.month != 12) {
      return DateTime(date.year, date.month + 1, 1);
    } else {
      return DateTime(date.year + 1, 1, 1);
    }
  }

  static getPreviousMonth(DateTime date) {
    if (date.month != 1) {
      return DateTime(date.year, date.month - 1, 1);
    } else {
      return DateTime(date.year - 1, 12, 1);
    }
  }
}
