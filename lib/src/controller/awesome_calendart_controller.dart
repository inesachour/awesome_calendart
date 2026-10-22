import 'package:awesome_calendart/src/utils/date_utils.dart';
import 'package:flutter/material.dart';

/// Reads and changes the state of an `AwesomeCalenDart` from code.
///
/// ```dart
/// final controller = AwesomeCalenDartController();
///
/// AwesomeCalenDart(controller: controller);
///
/// controller.jumpToMonth(DateTime(2027, 3));
/// controller.selectDate(DateTime(2027, 3, 14));
/// print(controller.selectedDate);
/// ```
///
/// The controller notifies its listeners whenever the visible month or the
/// selection changes. Dispose it when you no longer need it.
class AwesomeCalenDartController extends ChangeNotifier {
  /// Creates a controller showing the month of [initialMonth] (default: the
  /// current month). The selection starts empty.
  AwesomeCalenDartController({DateTime? initialMonth})
      : _focusedDate =
            AwesomeDateUtils.firstOfMonth(initialMonth ?? DateTime.now());

  DateTime _focusedDate;
  List<DateTime> _selectedDates = const [];
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  /// The first day of the month currently displayed.
  DateTime get visibleMonth => AwesomeDateUtils.firstOfMonth(_focusedDate);

  /// The day the calendar is centered on. In the month format this is a day of
  /// the visible month; in the week formats it is a day of the visible week.
  DateTime get focusedDate => _focusedDate;

  /// The selected dates in `single` and `multiple` modes (sorted).
  List<DateTime> get selectedDates => _selectedDates;

  /// The first selected date, or `null` when nothing is selected.
  DateTime? get selectedDate =>
      _selectedDates.isEmpty ? null : _selectedDates.first;

  /// The start of the selected range (`range` mode), or `null`.
  DateTime? get rangeStart => _rangeStart;

  /// The end of the selected range, or `null` while the user has only picked
  /// the start.
  DateTime? get rangeEnd => _rangeEnd;

  /// The selected range, or `null` unless both end points are picked.
  DateTimeRange? get selectedRange => (_rangeStart != null && _rangeEnd != null)
      ? DateTimeRange(start: _rangeStart!, end: _rangeEnd!)
      : null;

  /// Shows the month containing [date].
  void jumpToMonth(DateTime date) {
    final month = AwesomeDateUtils.firstOfMonth(date);
    if (month == _focusedDate) return;
    _focusedDate = month;
    notifyListeners();
  }

  /// Shows the period (month, two weeks or week, depending on the calendar's
  /// format) containing [date].
  void jumpToDate(DateTime date) {
    final day = AwesomeDateUtils.dateOnly(date);
    if (day == _focusedDate) return;
    _focusedDate = day;
    notifyListeners();
  }

  /// Shows the next month.
  void nextMonth() => jumpToMonth(AwesomeDateUtils.getNextMonth(visibleMonth));

  /// Shows the previous month.
  void previousMonth() =>
      jumpToMonth(AwesomeDateUtils.getPreviousMonth(visibleMonth));

  /// Selects only [date]. When [showMonth] is true (default) the calendar
  /// also jumps to the month of [date].
  void selectDate(DateTime date, {bool showMonth = true}) =>
      selectDates([date], showMonth: showMonth);

  /// Selects exactly [dates] (duplicates are removed). When [showMonth] is
  /// true (default) the calendar jumps to the month of the earliest date.
  void selectDates(Iterable<DateTime> dates, {bool showMonth = true}) {
    final unique = dates.map(AwesomeDateUtils.dateOnly).toSet().toList()
      ..sort();
    _selectedDates = List.unmodifiable(unique);
    _rangeStart = null;
    _rangeEnd = null;
    if (showMonth && unique.isNotEmpty) {
      _focusedDate = unique.first;
    }
    notifyListeners();
  }

  /// Selects the range from [start] to [end] (swapped if reversed). Pass no
  /// [end] to only set the start. When [showMonth] is true (default) the
  /// calendar jumps to the month of the start.
  void selectRange(DateTime start, [DateTime? end, bool showMonth = true]) {
    var s = AwesomeDateUtils.dateOnly(start);
    DateTime? e = end == null ? null : AwesomeDateUtils.dateOnly(end);
    if (e != null && e.isBefore(s)) {
      final t = s;
      s = e;
      e = t;
    }
    _selectedDates = const [];
    _rangeStart = s;
    _rangeEnd = e;
    if (showMonth) _focusedDate = s;
    notifyListeners();
  }

  /// Removes the selection.
  void clearSelection() {
    _selectedDates = const [];
    _rangeStart = null;
    _rangeEnd = null;
    notifyListeners();
  }
}
