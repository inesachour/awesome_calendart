import 'package:awesome_calendart/src/controller/awesome_calendart_controller.dart';
import 'package:awesome_calendart/src/models/awesome_event.dart';
import 'package:awesome_calendart/src/models/day_details.dart';
import 'package:awesome_calendart/src/models/selection_mode.dart';
import 'package:awesome_calendart/src/theme/theme.dart';
import 'package:awesome_calendart/src/utils/date_utils.dart';
import 'package:awesome_calendart/src/widgets/awesome_calendart_days_view.dart';
import 'package:awesome_calendart/src/widgets/awesome_calendart_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A customizable calendar widget.
///
/// ```dart
/// AwesomeCalenDart(
///   locale: const Locale('fr'),
///   selectionMode: AwesomeSelectionMode.range,
///   minDate: DateTime.now(),
///   onRangeChanged: (start, end) => print('$start -> $end'),
/// )
/// ```
///
/// Everything is optional. The calendar can be styled with [theme], laid out
/// with [padding], [dayAspectRatio] and [elevation], and fully redrawn with
/// [dayBuilder], [headerBuilder] and [weekdayBuilder]. Use a [controller] to
/// read or change the selection and the visible month from code.
class AwesomeCalenDart extends StatefulWidget {
  /// The elevation of the calendar card (default 5).
  final double elevation;

  /// The border radius of the calendar card (default 20).
  final double borderRadius;

  /// The space between the card edge and its content
  /// (default `EdgeInsets.symmetric(horizontal: 10, vertical: 8)`).
  final EdgeInsetsGeometry padding;

  /// The language of month and weekday names (default `Locale('en')`).
  ///
  /// Every locale supported by `intl` works (for example `Locale('ar')`).
  /// Right-to-left languages mirror the layout automatically.
  final Locale locale;

  /// Whether numbers (days, years, week numbers) use the digits of [locale]
  /// (default true). The digits come from `intl`: Persian digits for `fa`,
  /// Bengali digits for `bn`, Arabic-Indic digits for every Arabic locale, and
  /// so on. Locales that use 0-9, such as English or French, are not affected.
  /// Set it to false to always show 0-9.
  final bool useLocaleDigits;

  /// Whether weekday labels use their full name ("Monday") instead of the
  /// short one ("Mon") (default false).
  final bool displayFullWeekdayNames;

  /// The colors and text styles. When omitted, the [AwesomeTheme] registered in
  /// the app's `ThemeData.extensions` is used, and otherwise [LightTheme].
  final AwesomeTheme? theme;

  /// Reads and changes the visible month and the selection from code.
  ///
  /// When omitted, the calendar manages its own state. The calendar never
  /// disposes a controller you pass in.
  final AwesomeCalenDartController? controller;

  /// The month to show first, and in [AwesomeSelectionMode.single] the date
  /// that is selected first (default: today). Ignored when a [controller] is
  /// passed in: use `controller.jumpToMonth` / `selectDate` instead.
  final DateTime? initialDate;

  /// How dates are selected (default [AwesomeSelectionMode.single]).
  final AwesomeSelectionMode selectionMode;

  /// How much of the calendar is visible: a month (default), two weeks or one
  /// week. Changing it later updates the calendar.
  final AwesomeCalendarFormat calendarFormat;

  /// Whether a button in the header lets the user cycle through the
  /// [AwesomeCalendarFormat]s (default false).
  final bool showFormatButton;

  /// The tooltip of the format button (default "Change view"). Pass your own
  /// translation.
  final String formatButtonTooltip;

  /// Called when the user changes the format with the format button.
  final ValueChanged<AwesomeCalendarFormat>? onFormatChanged;

  /// The earliest selectable date. Earlier days are disabled.
  final DateTime? minDate;

  /// The latest selectable date. Later days are disabled.
  final DateTime? maxDate;

  /// Individual dates that cannot be selected.
  final List<DateTime>? disabledDates;

  /// Disables every day for which this returns false, in addition to
  /// [minDate], [maxDate] and [disabledDates]. For example, to allow weekdays
  /// only: `(d) => d.weekday < DateTime.saturday`.
  final bool Function(DateTime date)? selectableDayPredicate;

  /// In [AwesomeSelectionMode.range], the minimum distance in days between the
  /// start and the end (for example 2 nights means the end is at least two
  /// days after the start). While the end is being picked, days that would make
  /// the range too short are disabled. If this is greater than 0, tapping the
  /// start again cancels the pending range.
  final int? minRangeLength;

  /// In [AwesomeSelectionMode.range], the maximum distance in days between the
  /// start and the end. Days that would make the range too long are disabled
  /// while the end is being picked. To pick another start, tap an earlier day.
  final int? maxRangeLength;

  /// The first day of the week, as [DateTime.monday] ... [DateTime.sunday]
  /// (default [DateTime.monday]).
  final int firstDayOfWeek;

  /// The days styled with `AwesomeTheme.weekendDayTextStyle`, as
  /// [DateTime.monday] ... [DateTime.sunday]
  /// (default Saturday and Sunday).
  final List<int> weekendDays;

  /// Whether a column with the ISO week number is shown before each week
  /// (default false).
  final bool showWeekNumbers;

  /// Whether today gets a ring around it (default true).
  final bool highlightToday;

  /// Whether the last days of the previous month and the first days of the
  /// next month fill the empty cells of the grid (default false). Tapping one
  /// selects it and shows its month. Only used in the month format.
  final bool showAdjacentMonthDays;

  /// Dates with a simple marker (dot), to highlight events or reminders. For
  /// colors or descriptions use [events] instead.
  final List<DateTime>? eventMarkers;

  /// Events with their own marker color and screen reader label. Up to three
  /// markers are drawn per day.
  final List<AwesomeEvent>? events;

  /// Overrides the look of particular days (holidays, availability, ...).
  /// Selected days keep the selected style. Keys ignore the time of day.
  final Map<DateTime, AwesomeDayStyle>? specialDates;

  /// Whether the events of the selected day are listed under the calendar
  /// (default false). The default list shows the label of each event; use
  /// [eventListBuilder] to draw your own. In the multiple and range modes the
  /// list follows the last tapped day.
  final bool showEventList;

  /// Draws the list of events under the calendar. Called with the selected day
  /// and its events (possibly none). Implies [showEventList].
  final AwesomeEventListBuilder? eventListBuilder;

  /// Whether swiping horizontally changes the period (default true).
  final bool enableSwipe;

  /// Whether the arrow keys move between days, Enter or Space select the day
  /// and Page Up / Page Down change the period, when the calendar has keyboard
  /// focus (default true).
  final bool enableKeyboardNavigation;

  /// Whether tapping the header opens the month and year pickers
  /// (default true).
  final bool enableMonthYearPicker;

  /// The duration of the slide and view change animations. Use
  /// [Duration.zero] to disable animations (default 250 ms).
  final Duration animationDuration;

  /// The curve of the animations (default [Curves.easeInOut]).
  final Curve animationCurve;

  /// The width / height ratio of a day cell (default 1.5). It is reduced
  /// automatically when the user increases the system font size.
  final double dayAspectRatio;

  /// Replaces the previous button icon.
  final Widget? previousMonthIcon;

  /// Replaces the next button icon.
  final Widget? nextMonthIcon;

  /// Formats the header title, for example
  /// `(month, locale) => 'M${month.month}'`. Defaults to "October 2026".
  final String Function(DateTime month, Locale locale)? monthYearFormatter;

  /// Draws the content of every day cell yourself. Tapping, disabling and
  /// accessibility are still handled by the calendar.
  final AwesomeDayBuilder? dayBuilder;

  /// Draws the whole header (title and buttons) yourself. Use the callbacks of
  /// [AwesomeHeaderDetails] to navigate.
  final AwesomeHeaderBuilder? headerBuilder;

  /// Draws each weekday label yourself.
  final AwesomeWeekdayBuilder? weekdayBuilder;

  /// Called with the tapped date, in every selection mode.
  final ValueChanged<DateTime>? onDateSelected;

  /// Called with all selected dates in [AwesomeSelectionMode.multiple].
  final ValueChanged<List<DateTime>>? onDatesChanged;

  /// Called in [AwesomeSelectionMode.range] each time the range changes. [end]
  /// is null while only the start has been picked.
  final void Function(DateTime start, DateTime? end)? onRangeChanged;

  /// Called with the first day of the month when the visible month changes.
  /// In the week formats it follows the month of the visible week.
  final ValueChanged<DateTime>? onMonthChanged;

  const AwesomeCalenDart({
    super.key,
    this.elevation = 5,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    this.locale = const Locale('en'),
    this.useLocaleDigits = true,
    this.displayFullWeekdayNames = false,
    this.theme,
    this.controller,
    this.initialDate,
    this.selectionMode = AwesomeSelectionMode.single,
    this.calendarFormat = AwesomeCalendarFormat.month,
    this.showFormatButton = false,
    this.formatButtonTooltip = 'Change view',
    this.onFormatChanged,
    this.minDate,
    this.maxDate,
    this.disabledDates,
    this.selectableDayPredicate,
    this.minRangeLength,
    this.maxRangeLength,
    this.firstDayOfWeek = DateTime.monday,
    this.weekendDays = const [DateTime.saturday, DateTime.sunday],
    this.showWeekNumbers = false,
    this.highlightToday = true,
    this.showAdjacentMonthDays = false,
    this.eventMarkers,
    this.events,
    this.specialDates,
    this.showEventList = false,
    this.eventListBuilder,
    this.enableSwipe = true,
    this.enableKeyboardNavigation = true,
    this.enableMonthYearPicker = true,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOut,
    this.dayAspectRatio = 1.5,
    this.previousMonthIcon,
    this.nextMonthIcon,
    this.monthYearFormatter,
    this.dayBuilder,
    this.headerBuilder,
    this.weekdayBuilder,
    this.onDateSelected,
    this.onDatesChanged,
    this.onRangeChanged,
    this.onMonthChanged,
  })  : assert(firstDayOfWeek >= DateTime.monday &&
            firstDayOfWeek <= DateTime.sunday),
        assert(minRangeLength == null || minRangeLength >= 0),
        assert(maxRangeLength == null ||
            minRangeLength == null ||
            maxRangeLength >= minRangeLength);

  @override
  State<AwesomeCalenDart> createState() => _AwesomeCalenDartState();
}

enum _CalendarView { days, months, years }

class _AwesomeCalenDartState extends State<AwesomeCalenDart> {
  late AwesomeCalenDartController _controller;
  late bool _ownsController;
  late AwesomeCalendarFormat _format;
  late DateTime _shownKey;
  late DateTime _lastMonth;
  late Map<DateTime, List<AwesomeEvent>> _events;
  late Map<DateTime, AwesomeDayStyle> _special;
  late Set<DateTime> _disabled;
  final FocusNode _gridFocus = FocusNode(debugLabel: 'AwesomeCalenDart days');

  _CalendarView _view = _CalendarView.days;
  bool _forward = true;
  int _pickerYear = 0;
  int _yearsPageStart = 0;
  DateTime? _agendaDate;
  DateTime? _keyboardDate;

  AwesomeTheme get _theme =>
      widget.theme ??
      Theme.of(context).extension<AwesomeTheme>() ??
      const LightTheme();
  Locale get _locale => widget.locale;
  bool get _rtl => AwesomeDateUtils.isRtl(_locale);
  DateTime? get _min => widget.minDate == null
      ? null
      : AwesomeDateUtils.dateOnly(widget.minDate!);
  DateTime? get _max => widget.maxDate == null
      ? null
      : AwesomeDateUtils.dateOnly(widget.maxDate!);

  // --- lifecycle ---------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _format = widget.calendarFormat;
    _rebuildCaches();
    _attachController();
    _gridFocus.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(covariant AwesomeCalenDart oldWidget) {
    super.didUpdateWidget(oldWidget);
    _rebuildCaches();
    if (oldWidget.calendarFormat != widget.calendarFormat) {
      _format = widget.calendarFormat;
    }
    if (oldWidget.controller != widget.controller) {
      _detachController();
      _attachController();
    } else {
      _shownKey = _periodStart(_controller.focusedDate);
    }
  }

  @override
  void dispose() {
    _gridFocus.removeListener(_onFocusChanged);
    _gridFocus.dispose();
    _detachController();
    super.dispose();
  }

  void _onFocusChanged() => setState(() {});

  void _rebuildCaches() {
    _disabled = {
      for (final d in widget.disabledDates ?? const <DateTime>[])
        AwesomeDateUtils.dateOnly(d)
    };
    _special = {
      for (final e in (widget.specialDates ?? const {}).entries)
        AwesomeDateUtils.dateOnly(e.key): e.value
    };
    _events = {};
    for (final d in widget.eventMarkers ?? const <DateTime>[]) {
      _events
          .putIfAbsent(AwesomeDateUtils.dateOnly(d), () => [])
          .add(AwesomeEvent(date: d));
    }
    for (final e in widget.events ?? const <AwesomeEvent>[]) {
      _events.putIfAbsent(AwesomeDateUtils.dateOnly(e.date), () => []).add(e);
    }
  }

  void _attachController() {
    final given = widget.controller;
    if (given != null) {
      _controller = given;
      _ownsController = false;
    } else {
      _controller =
          AwesomeCalenDartController(initialMonth: widget.initialDate);
      _ownsController = true;
      if (widget.initialDate != null) {
        _controller.jumpToDate(widget.initialDate!);
      }
      if (widget.selectionMode == AwesomeSelectionMode.single) {
        final initial =
            AwesomeDateUtils.dateOnly(widget.initialDate ?? DateTime.now());
        if (!_isDisabled(initial)) {
          _controller.selectDate(initial, showMonth: false);
        }
      }
    }
    _shownKey = _periodStart(_controller.focusedDate);
    _lastMonth = _titleMonth(_shownKey);
    _controller.addListener(_onControllerChanged);
  }

  void _detachController() {
    _controller.removeListener(_onControllerChanged);
    if (_ownsController) _controller.dispose();
  }

  void _onControllerChanged() {
    final key = _periodStart(_controller.focusedDate);
    final changed = key != _shownKey;
    setState(() {
      if (changed) {
        _forward = key.isAfter(_shownKey);
        _shownKey = key;
      }
    });
    final month = _titleMonth(key);
    if (month != _lastMonth) {
      _lastMonth = month;
      widget.onMonthChanged?.call(month);
    }
  }

  // --- periods -----------------------------------------------------------

  int get _periodDays => _format == AwesomeCalendarFormat.week ? 7 : 14;

  /// The first day of the period (month or weeks) containing [focused].
  DateTime _periodStart(DateTime focused) {
    if (_format == AwesomeCalendarFormat.month) {
      return AwesomeDateUtils.firstOfMonth(focused);
    }
    return AwesomeDateUtils.startOfWeek(focused, widget.firstDayOfWeek);
  }

  DateTime _periodEnd(DateTime start) {
    if (_format == AwesomeCalendarFormat.month) {
      return DateTime(start.year, start.month + 1, 0);
    }
    return DateTime(start.year, start.month, start.day + _periodDays - 1);
  }

  DateTime _shifted(DateTime start, int direction) {
    if (_format == AwesomeCalendarFormat.month) {
      return DateTime(start.year, start.month + direction, 1);
    }
    return DateTime(
        start.year, start.month, start.day + direction * _periodDays);
  }

  /// The first day of the month the header talks about.
  DateTime _titleMonth(DateTime key) {
    if (_format == AwesomeCalendarFormat.month) return key;
    return AwesomeDateUtils.firstOfMonth(
        DateTime(key.year, key.month, key.day + 3));
  }

  bool get _canGoPrevious {
    final min = _min;
    if (min == null) return true;
    final previousEnd =
        DateTime(_shownKey.year, _shownKey.month, _shownKey.day - 1);
    return !previousEnd.isBefore(min);
  }

  bool get _canGoNext {
    final max = _max;
    return max == null || !_shifted(_shownKey, 1).isAfter(max);
  }

  void _go(int direction) {
    if (direction < 0 ? !_canGoPrevious : !_canGoNext) return;
    final target = _shifted(_shownKey, direction);
    if (_format == AwesomeCalendarFormat.month) {
      _controller.jumpToMonth(target);
    } else {
      _controller.jumpToDate(target);
    }
  }

  void _cycleFormat() {
    final next = AwesomeCalendarFormat
        .values[(_format.index + 1) % AwesomeCalendarFormat.values.length];
    setState(() {
      _format = next;
      _shownKey = _periodStart(_controller.focusedDate);
      _lastMonth = _titleMonth(_shownKey);
    });
    widget.onFormatChanged?.call(next);
  }

  // --- rules and selection -----------------------------------------------

  bool _isDisabled(DateTime date) {
    final min = _min, max = _max;
    if (min != null && date.isBefore(min)) return true;
    if (max != null && date.isAfter(max)) return true;
    if (_disabled.contains(date)) return true;
    return widget.selectableDayPredicate?.call(date) == false;
  }

  static int _daysBetween(DateTime a, DateTime b) =>
      DateTime.utc(b.year, b.month, b.day)
          .difference(DateTime.utc(a.year, a.month, a.day))
          .inDays;

  /// [_isDisabled] plus the range length limits while the end is being picked.
  bool _isDayDisabled(DateTime date) {
    if (_isDisabled(date)) return true;
    if (widget.selectionMode == AwesomeSelectionMode.range) {
      final start = _controller.rangeStart;
      if (start != null &&
          _controller.rangeEnd == null &&
          date != start &&
          !date.isBefore(start)) {
        final length = _daysBetween(start, date);
        final min = widget.minRangeLength, max = widget.maxRangeLength;
        if ((min != null && length < min) || (max != null && length > max)) {
          return true;
        }
      }
    }
    return false;
  }

  void _onDayTap(DateTime date) {
    _keyboardDate = date;
    _agendaDate = date;
    switch (widget.selectionMode) {
      case AwesomeSelectionMode.single:
        _controller.selectDate(date, showMonth: false);
      case AwesomeSelectionMode.multiple:
        final dates = _controller.selectedDates.toList();
        dates.contains(date) ? dates.remove(date) : dates.add(date);
        _controller.selectDates(dates, showMonth: false);
        widget.onDatesChanged?.call(_controller.selectedDates);
      case AwesomeSelectionMode.range:
        final start = _controller.rangeStart;
        final end = _controller.rangeEnd;
        if (start != null &&
            end == null &&
            date == start &&
            (widget.minRangeLength ?? 0) > 0) {
          _controller.clearSelection();
        } else {
          if (start == null || end != null || date.isBefore(start)) {
            _controller.selectRange(date, null, false);
          } else {
            _controller.selectRange(start, date, false);
          }
          widget.onRangeChanged
              ?.call(_controller.rangeStart!, _controller.rangeEnd);
        }
    }
    final key = _periodStart(date);
    if (key != _shownKey) _controller.jumpToDate(date);
    setState(() {});
    widget.onDateSelected?.call(date);
  }

  // --- gestures and keyboard ---------------------------------------------

  void _onSwipe(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity.abs() < 200) return;
    final toPrevious = _rtl ? velocity < 0 : velocity > 0;
    _go(toPrevious ? -1 : 1);
  }

  bool _inPeriod(DateTime d) =>
      !d.isBefore(_shownKey) && !d.isAfter(_periodEnd(_shownKey));

  DateTime get _effectiveKeyboardDate {
    final kept = _keyboardDate;
    if (kept != null && _inPeriod(kept)) return kept;
    final selected =
        _controller.selectedDate ?? _controller.rangeStart ?? _agendaDate;
    if (selected != null && _inPeriod(selected)) return selected;
    final today = AwesomeDateUtils.dateOnly(DateTime.now());
    return _inPeriod(today) ? today : _shownKey;
  }

  void _moveKeyboard(int days) {
    final base = _effectiveKeyboardDate;
    final next = DateTime(base.year, base.month, base.day + days);
    final min = _min, max = _max;
    if ((min != null && next.isBefore(min)) ||
        (max != null && next.isAfter(max))) {
      return;
    }
    setState(() => _keyboardDate = next);
    if (!_inPeriod(next)) _controller.jumpToDate(next);
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (!widget.enableKeyboardNavigation || event is KeyUpEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowLeft) {
      _moveKeyboard(_rtl ? 1 : -1);
    } else if (key == LogicalKeyboardKey.arrowRight) {
      _moveKeyboard(_rtl ? -1 : 1);
    } else if (key == LogicalKeyboardKey.arrowUp) {
      _moveKeyboard(-7);
    } else if (key == LogicalKeyboardKey.arrowDown) {
      _moveKeyboard(7);
    } else if (key == LogicalKeyboardKey.pageUp) {
      _keyboardDate = null;
      _go(-1);
    } else if (key == LogicalKeyboardKey.pageDown) {
      _keyboardDate = null;
      _go(1);
    } else if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter ||
        key == LogicalKeyboardKey.space) {
      final date = _effectiveKeyboardDate;
      if (!_isDayDisabled(date)) _onDayTap(date);
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  // --- pickers -----------------------------------------------------------

  void _openMonthPicker() => setState(() {
        _pickerYear = _titleMonth(_shownKey).year;
        _view = _CalendarView.months;
      });

  void _openYearPicker() => setState(() {
        _yearsPageStart =
            _pickerYear - (_pickerYear % AwesomeCalenDartYearPicker.pageSize);
        _view = _CalendarView.years;
      });

  // --- building ----------------------------------------------------------

  IconData get _formatIcon => switch (_format) {
        AwesomeCalendarFormat.month => Icons.calendar_view_month,
        AwesomeCalendarFormat.twoWeeks => Icons.calendar_view_week,
        AwesomeCalendarFormat.week => Icons.calendar_view_day,
      };

  Widget _buildHeader(AwesomeTheme theme, DateTime titleMonth) {
    final title = widget.monthYearFormatter?.call(titleMonth, _locale) ??
        AwesomeDateUtils.getMonthAndYear(titleMonth, _locale,
            localeDigits: widget.useLocaleDigits);
    final openPicker = widget.enableMonthYearPicker ? _openMonthPicker : null;

    if (widget.headerBuilder != null) {
      return widget.headerBuilder!(
        context,
        AwesomeHeaderDetails(
          month: titleMonth,
          title: title,
          canGoPrevious: _canGoPrevious,
          canGoNext: _canGoNext,
          goToPrevious: () => _go(-1),
          goToNext: () => _go(1),
          openPicker: openPicker,
          changeFormat: widget.showFormatButton ? _cycleFormat : null,
        ),
      );
    }

    final previousMonth = AwesomeDateUtils.getPreviousMonth(titleMonth);
    final nextMonth = AwesomeDateUtils.getNextMonth(titleMonth);
    return AwesomeCalenDartHeader(
      title: title,
      theme: theme,
      onTitleTap: openPicker,
      onPrevious: _canGoPrevious ? () => _go(-1) : null,
      onNext: _canGoNext ? () => _go(1) : null,
      previousTooltip: AwesomeDateUtils.monthName(previousMonth.month, _locale),
      nextTooltip: AwesomeDateUtils.monthName(nextMonth.month, _locale),
      previousIcon: widget.previousMonthIcon,
      nextIcon: widget.nextMonthIcon,
      trailing: widget.showFormatButton
          ? IconButton(
              tooltip: widget.formatButtonTooltip,
              onPressed: _cycleFormat,
              icon: Icon(_formatIcon, color: theme.buttonColor),
            )
          : null,
    );
  }

  Widget? _buildEventList(AwesomeTheme theme) {
    if (!widget.showEventList && widget.eventListBuilder == null) return null;
    final date = widget.selectionMode == AwesomeSelectionMode.single
        ? _controller.selectedDate
        : _agendaDate;
    if (date == null) return null;
    final events = _events[date] ?? const <AwesomeEvent>[];

    if (widget.eventListBuilder != null) {
      return widget.eventListBuilder!(context, date, events);
    }
    final labeled = events.where((e) => e.label != null).toList();
    if (labeled.isEmpty) return null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(height: 16, color: theme.rangeBackgroundColor),
          for (final event in labeled)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color:
                          event.color ?? theme.eventMarkerColorOnUnselectedDay,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child:
                        Text(event.label!, style: theme.unselectedDayTextStyle),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDays() {
    final theme = _theme;
    final titleMonth = _titleMonth(_shownKey);
    final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
    final aspectRatio = widget.dayAspectRatio / textScale.clamp(1.0, 2.0);
    final direction = (_forward ? 1.0 : -1.0) * (_rtl ? -1.0 : 1.0);
    final isMonth = _format == AwesomeCalendarFormat.month;

    final int rowCount;
    if (isMonth) {
      final offset = AwesomeDateUtils.getFirstWeekdayOffset(
          _shownKey, widget.firstDayOfWeek);
      rowCount =
          ((offset + AwesomeDateUtils.getDaysInMonth(_shownKey)) / 7).ceil();
    } else {
      rowCount = _periodDays ~/ 7;
    }
    final periodStart = isMonth
        ? DateTime(
            _shownKey.year,
            _shownKey.month,
            1 -
                AwesomeDateUtils.getFirstWeekdayOffset(
                    _shownKey, widget.firstDayOfWeek))
        : _shownKey;

    final gridKey = ValueKey('${_format.index}-$_shownKey');
    final grid = AwesomeCalenDartDaysView(
      key: gridKey,
      periodStart: periodStart,
      rowCount: rowCount,
      month: isMonth ? _shownKey : null,
      locale: _locale,
      theme: theme,
      firstDayOfWeek: widget.firstDayOfWeek,
      weekendDays: widget.weekendDays.toSet(),
      showAdjacentMonthDays: widget.showAdjacentMonthDays,
      showWeekNumbers: widget.showWeekNumbers,
      highlightToday: widget.highlightToday,
      localeDigits: widget.useLocaleDigits,
      aspectRatio: aspectRatio,
      selectedDates: _controller.selectedDates.toSet(),
      rangeStart: _controller.rangeStart,
      rangeEnd: _controller.rangeEnd,
      focusedDate: _gridFocus.hasFocus && widget.enableKeyboardNavigation
          ? _effectiveKeyboardDate
          : null,
      isDisabled: _isDayDisabled,
      events: _events,
      specialDates: _special,
      dayBuilder: widget.dayBuilder,
      onDayTap: _onDayTap,
    );
    final eventList = _buildEventList(theme);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(theme, titleMonth),
        AwesomeCalenDartWeekdays(
          locale: _locale,
          theme: theme,
          firstDayOfWeek: widget.firstDayOfWeek,
          full: widget.displayFullWeekdayNames,
          showWeekNumbers: widget.showWeekNumbers,
          weekdayBuilder: widget.weekdayBuilder,
        ),
        Focus(
          focusNode: _gridFocus,
          canRequestFocus: widget.enableKeyboardNavigation,
          onKeyEvent: _onKey,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragEnd: widget.enableSwipe ? _onSwipe : null,
            child: ClipRect(
              child: AnimatedSwitcher(
                duration: widget.animationDuration,
                switchInCurve: widget.animationCurve,
                switchOutCurve: widget.animationCurve,
                layoutBuilder: (current, previous) => Stack(
                  alignment: Alignment.topCenter,
                  children: [...previous, if (current != null) current],
                ),
                transitionBuilder: (child, animation) {
                  final incoming = child.key == gridKey;
                  final begin = Offset(incoming ? direction : -direction, 0);
                  return SlideTransition(
                    position: Tween<Offset>(begin: begin, end: Offset.zero)
                        .animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: grid,
              ),
            ),
          ),
        ),
        if (eventList != null) eventList,
      ],
    );
  }

  Widget _buildMonthPicker() {
    final min = _min, max = _max;
    return AwesomeCalenDartMonthPicker(
      year: _pickerYear,
      locale: _locale,
      localeDigits: widget.useLocaleDigits,
      theme: _theme,
      selectedMonth: _titleMonth(_shownKey),
      minMonth: min == null ? null : AwesomeDateUtils.firstOfMonth(min),
      maxMonth: max == null ? null : AwesomeDateUtils.firstOfMonth(max),
      previousIcon: widget.previousMonthIcon,
      nextIcon: widget.nextMonthIcon,
      onYearChanged: (year) => setState(() => _pickerYear = year),
      onYearTap: _openYearPicker,
      onMonthSelected: (month) {
        _controller.jumpToMonth(DateTime(_pickerYear, month));
        setState(() => _view = _CalendarView.days);
      },
    );
  }

  Widget _buildYearPicker() {
    return AwesomeCalenDartYearPicker(
      startYear: _yearsPageStart,
      selectedYear: _pickerYear,
      locale: _locale,
      localeDigits: widget.useLocaleDigits,
      theme: _theme,
      minYear: _min?.year,
      maxYear: _max?.year,
      previousIcon: widget.previousMonthIcon,
      nextIcon: widget.nextMonthIcon,
      onPageChanged: (start) => setState(() => _yearsPageStart = start),
      onYearSelected: (year) => setState(() {
        _pickerYear = year;
        _view = _CalendarView.months;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final body = switch (_view) {
      _CalendarView.days => _buildDays(),
      _CalendarView.months => _buildMonthPicker(),
      _CalendarView.years => _buildYearPicker(),
    };

    return Directionality(
      textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
      child: Material(
        elevation: widget.elevation,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        color: _theme.backgroundColor,
        child: Padding(
          padding: widget.padding,
          child: AnimatedSize(
            duration: widget.animationDuration,
            curve: widget.animationCurve,
            alignment: Alignment.topCenter,
            child: AnimatedSwitcher(
              duration: widget.animationDuration,
              layoutBuilder: (current, previous) => Stack(
                alignment: Alignment.topCenter,
                children: [...previous, if (current != null) current],
              ),
              child: KeyedSubtree(key: ValueKey(_view), child: body),
            ),
          ),
        ),
      ),
    );
  }
}
