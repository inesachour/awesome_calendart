import 'package:awesome_calendart/src/controller/awesome_calendart_controller.dart';
import 'package:awesome_calendart/src/models/awesome_event.dart';
import 'package:awesome_calendart/src/models/day_details.dart';
import 'package:awesome_calendart/src/models/selection_mode.dart';
import 'package:awesome_calendart/src/theme/theme.dart';
import 'package:awesome_calendart/src/utils/date_utils.dart';
import 'package:awesome_calendart/src/widgets/awesome_calendart_days_view.dart';
import 'package:awesome_calendart/src/widgets/awesome_calendart_pickers.dart';
import 'package:flutter/material.dart';

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
/// with [padding], [dayAspectRatio] and [elevation], and fully redrawn per day
/// with [dayBuilder]. Use a [controller] to read or change the selection and
/// the visible month from code.
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

  /// Whether weekday labels use their full name ("Monday") instead of the
  /// short one ("Mon") (default false).
  final bool displayFullWeekdayNames;

  /// The colors and text styles (default [LightTheme]).
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

  /// The earliest selectable date. Earlier days are disabled.
  final DateTime? minDate;

  /// The latest selectable date. Later days are disabled.
  final DateTime? maxDate;

  /// Individual dates that cannot be selected.
  final List<DateTime>? disabledDates;

  /// The first day of the week, as [DateTime.monday] ... [DateTime.sunday]
  /// (default [DateTime.monday]).
  final int firstDayOfWeek;

  /// Whether today gets a ring around it (default true).
  final bool highlightToday;

  /// Whether the last days of the previous month and the first days of the
  /// next month fill the empty cells of the grid (default false). Tapping one
  /// selects it and shows its month.
  final bool showAdjacentMonthDays;

  /// Dates with a simple marker (dot), to highlight events or reminders. For
  /// colors or descriptions use [events] instead.
  final List<DateTime>? eventMarkers;

  /// Events with their own marker color and screen reader label. Up to three
  /// markers are drawn per day.
  final List<AwesomeEvent>? events;

  /// Whether swiping horizontally changes the month (default true).
  final bool enableSwipe;

  /// Whether tapping the header opens the month and year pickers
  /// (default true).
  final bool enableMonthYearPicker;

  /// The duration of the month slide and view change animations. Use
  /// [Duration.zero] to disable animations (default 250 ms).
  final Duration animationDuration;

  /// The curve of the animations (default [Curves.easeInOut]).
  final Curve animationCurve;

  /// The width / height ratio of a day cell (default 1.5). It is reduced
  /// automatically when the user increases the system font size.
  final double dayAspectRatio;

  /// Replaces the previous-month button icon.
  final Widget? previousMonthIcon;

  /// Replaces the next-month button icon.
  final Widget? nextMonthIcon;

  /// Formats the header title, for example `(month, locale) => 'M${month.month}'`.
  /// Defaults to "October 2026".
  final String Function(DateTime month, Locale locale)? monthYearFormatter;

  /// Draws the content of every day cell yourself. Tapping, disabling and
  /// accessibility are still handled by the calendar.
  final AwesomeDayBuilder? dayBuilder;

  /// Called with the tapped date, in every selection mode.
  final ValueChanged<DateTime>? onDateSelected;

  /// Called with all selected dates in [AwesomeSelectionMode.multiple].
  final ValueChanged<List<DateTime>>? onDatesChanged;

  /// Called in [AwesomeSelectionMode.range] each time the range changes. [end]
  /// is null while only the start has been picked.
  final void Function(DateTime start, DateTime? end)? onRangeChanged;

  /// Called with the first day of the month when the visible month changes.
  final ValueChanged<DateTime>? onMonthChanged;

  const AwesomeCalenDart({
    super.key,
    this.elevation = 5,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    this.locale = const Locale('en'),
    this.displayFullWeekdayNames = false,
    this.theme,
    this.controller,
    this.initialDate,
    this.selectionMode = AwesomeSelectionMode.single,
    this.minDate,
    this.maxDate,
    this.disabledDates,
    this.firstDayOfWeek = DateTime.monday,
    this.highlightToday = true,
    this.showAdjacentMonthDays = false,
    this.eventMarkers,
    this.events,
    this.enableSwipe = true,
    this.enableMonthYearPicker = true,
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeInOut,
    this.dayAspectRatio = 1.5,
    this.previousMonthIcon,
    this.nextMonthIcon,
    this.monthYearFormatter,
    this.dayBuilder,
    this.onDateSelected,
    this.onDatesChanged,
    this.onRangeChanged,
    this.onMonthChanged,
  });

  @override
  State<AwesomeCalenDart> createState() => _AwesomeCalenDartState();
}

enum _CalendarView { days, months, years }

class _AwesomeCalenDartState extends State<AwesomeCalenDart> {
  late AwesomeCalenDartController _controller;
  late bool _ownsController;
  late DateTime _shownMonth;
  late Map<DateTime, List<AwesomeEvent>> _events;
  late Set<DateTime> _disabled;

  _CalendarView _view = _CalendarView.days;
  bool _forward = true;
  int _pickerYear = 0;
  int _yearsPageStart = 0;

  AwesomeTheme get _theme => widget.theme ?? const LightTheme();
  Locale get _locale => widget.locale;
  DateTime? get _min => widget.minDate == null
      ? null
      : AwesomeDateUtils.dateOnly(widget.minDate!);
  DateTime? get _max => widget.maxDate == null
      ? null
      : AwesomeDateUtils.dateOnly(widget.maxDate!);

  @override
  void initState() {
    super.initState();
    _rebuildCaches();
    _attachController();
  }

  @override
  void didUpdateWidget(covariant AwesomeCalenDart oldWidget) {
    super.didUpdateWidget(oldWidget);
    _rebuildCaches();
    if (oldWidget.controller != widget.controller) {
      _detachController();
      _attachController();
    }
  }

  @override
  void dispose() {
    _detachController();
    super.dispose();
  }

  void _rebuildCaches() {
    _disabled = {
      for (final d in widget.disabledDates ?? const <DateTime>[])
        AwesomeDateUtils.dateOnly(d)
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
      if (widget.selectionMode == AwesomeSelectionMode.single) {
        final initial =
            AwesomeDateUtils.dateOnly(widget.initialDate ?? DateTime.now());
        if (!_isDisabled(initial)) {
          _controller.selectDate(initial, showMonth: false);
        }
      }
    }
    _shownMonth = _controller.visibleMonth;
    _controller.addListener(_onControllerChanged);
  }

  void _detachController() {
    _controller.removeListener(_onControllerChanged);
    if (_ownsController) _controller.dispose();
  }

  void _onControllerChanged() {
    final month = _controller.visibleMonth;
    final changed = month != _shownMonth;
    setState(() {
      if (changed) {
        _forward = month.isAfter(_shownMonth);
        _shownMonth = month;
      }
    });
    if (changed) widget.onMonthChanged?.call(month);
  }

  bool _isDisabled(DateTime date) {
    final min = _min, max = _max;
    if (min != null && date.isBefore(min)) return true;
    if (max != null && date.isAfter(max)) return true;
    return _disabled.contains(date);
  }

  bool get _canGoPrevious {
    final min = _min;
    return min == null ||
        !AwesomeDateUtils.getPreviousMonth(_shownMonth)
            .isBefore(AwesomeDateUtils.firstOfMonth(min));
  }

  bool get _canGoNext {
    final max = _max;
    return max == null ||
        !AwesomeDateUtils.getNextMonth(_shownMonth).isAfter(max);
  }

  void _onDayTap(DateTime date) {
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
        if (start == null || end != null) {
          _controller.selectRange(date, null, false);
        } else if (date.isBefore(start)) {
          _controller.selectRange(date, null, false);
        } else {
          _controller.selectRange(start, date, false);
        }
        widget.onRangeChanged
            ?.call(_controller.rangeStart!, _controller.rangeEnd);
    }
    if (!AwesomeDateUtils.isSameMonth(date, _shownMonth)) {
      _controller.jumpToMonth(date);
    }
    widget.onDateSelected?.call(date);
  }

  void _onSwipe(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity.abs() < 200) return;
    final rtl = AwesomeDateUtils.isRtl(_locale);
    final toPrevious = rtl ? velocity < 0 : velocity > 0;
    if (toPrevious) {
      if (_canGoPrevious) _controller.previousMonth();
    } else {
      if (_canGoNext) _controller.nextMonth();
    }
  }

  void _openMonthPicker() => setState(() {
        _pickerYear = _shownMonth.year;
        _view = _CalendarView.months;
      });

  void _openYearPicker() => setState(() {
        _yearsPageStart =
            _pickerYear - (_pickerYear % AwesomeCalenDartYearPicker.pageSize);
        _view = _CalendarView.years;
      });

  Widget _buildDays() {
    final theme = _theme;
    final months =
        List.generate(12, (i) => AwesomeDateUtils.monthName(i + 1, _locale));
    final title = widget.monthYearFormatter?.call(_shownMonth, _locale) ??
        AwesomeDateUtils.getMonthAndYear(_shownMonth, _locale);
    final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
    final aspectRatio = widget.dayAspectRatio / textScale.clamp(1.0, 2.0);
    final rtl = AwesomeDateUtils.isRtl(_locale);
    final direction = (_forward ? 1.0 : -1.0) * (rtl ? -1.0 : 1.0);
    final monthKey = ValueKey(_shownMonth);

    final grid = AwesomeCalenDartDaysView(
      key: monthKey,
      month: _shownMonth,
      locale: _locale,
      theme: theme,
      firstDayOfWeek: widget.firstDayOfWeek,
      showAdjacentMonthDays: widget.showAdjacentMonthDays,
      highlightToday: widget.highlightToday,
      aspectRatio: aspectRatio,
      selectedDates: _controller.selectedDates.toSet(),
      rangeStart: _controller.rangeStart,
      rangeEnd: _controller.rangeEnd,
      isDisabled: _isDisabled,
      events: _events,
      dayBuilder: widget.dayBuilder,
      onDayTap: _onDayTap,
    );

    return Column(
      children: [
        AwesomeCalenDartHeader(
          title: title,
          theme: theme,
          onTitleTap: widget.enableMonthYearPicker ? _openMonthPicker : null,
          onPrevious: _canGoPrevious ? _controller.previousMonth : null,
          onNext: _canGoNext ? _controller.nextMonth : null,
          previousTooltip:
              months[AwesomeDateUtils.getPreviousMonth(_shownMonth).month - 1],
          nextTooltip:
              months[AwesomeDateUtils.getNextMonth(_shownMonth).month - 1],
          previousIcon: widget.previousMonthIcon,
          nextIcon: widget.nextMonthIcon,
        ),
        AwesomeCalenDartWeekdays(
          locale: _locale,
          theme: theme,
          firstDayOfWeek: widget.firstDayOfWeek,
          full: widget.displayFullWeekdayNames,
        ),
        GestureDetector(
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
                final incoming = child.key == monthKey;
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
      ],
    );
  }

  Widget _buildMonthPicker() {
    final min = _min, max = _max;
    return AwesomeCalenDartMonthPicker(
      year: _pickerYear,
      locale: _locale,
      theme: _theme,
      selectedMonth: _shownMonth,
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
      textDirection: AwesomeDateUtils.isRtl(_locale)
          ? TextDirection.rtl
          : TextDirection.ltr,
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
