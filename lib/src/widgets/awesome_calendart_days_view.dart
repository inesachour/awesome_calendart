import 'package:awesome_calendart/src/models/awesome_event.dart';
import 'package:awesome_calendart/src/models/day_details.dart';
import 'package:awesome_calendart/src/theme/theme.dart';
import 'package:awesome_calendart/src/utils/date_utils.dart';
import 'package:flutter/material.dart';

/// The weekday labels row (Mon, Tue, ...).
class AwesomeCalenDartWeekdays extends StatelessWidget {
  final Locale locale;
  final AwesomeTheme theme;
  final int firstDayOfWeek;
  final bool full;

  const AwesomeCalenDartWeekdays({
    super.key,
    required this.locale,
    required this.theme,
    required this.firstDayOfWeek,
    required this.full,
  });

  @override
  Widget build(BuildContext context) {
    final names = AwesomeDateUtils.getWeekdayNames(locale,
        full: full, firstDayOfWeek: firstDayOfWeek);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          for (final name in names)
            Expanded(
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      name,
                      maxLines: 1,
                      style: theme.weekDaysTextStyle,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// The grid of days of one month.
class AwesomeCalenDartDaysView extends StatelessWidget {
  final DateTime month;
  final Locale locale;
  final AwesomeTheme theme;
  final int firstDayOfWeek;
  final bool showAdjacentMonthDays;
  final bool highlightToday;
  final double aspectRatio;
  final Set<DateTime> selectedDates;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final bool Function(DateTime date) isDisabled;
  final Map<DateTime, List<AwesomeEvent>> events;
  final AwesomeDayBuilder? dayBuilder;
  final ValueChanged<DateTime> onDayTap;

  const AwesomeCalenDartDaysView({
    super.key,
    required this.month,
    required this.locale,
    required this.theme,
    required this.firstDayOfWeek,
    required this.showAdjacentMonthDays,
    required this.highlightToday,
    required this.aspectRatio,
    required this.selectedDates,
    required this.rangeStart,
    required this.rangeEnd,
    required this.isDisabled,
    required this.events,
    required this.dayBuilder,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final offset =
        AwesomeDateUtils.getFirstWeekdayOffset(month, firstDayOfWeek);
    final daysInMonth = AwesomeDateUtils.getDaysInMonth(month);
    final cells = showAdjacentMonthDays
        ? ((offset + daysInMonth) / 7).ceil() * 7
        : offset + daysInMonth;
    final today = AwesomeDateUtils.dateOnly(DateTime.now());
    final hasRange =
        rangeStart != null && rangeEnd != null && rangeStart != rangeEnd;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      childAspectRatio: aspectRatio,
      padding: EdgeInsets.zero,
      children: List<Widget>.generate(cells, (cell) {
        // DateTime normalizes days outside 1..N into the adjacent months.
        final date = DateTime(month.year, month.month, 1 - offset + cell);
        final outside = date.month != month.month;
        if (outside && !showAdjacentMonthDays) return const SizedBox.shrink();

        final isRangeStart = rangeStart == date;
        final isRangeEnd = rangeEnd == date;
        final details = AwesomeDayDetails(
          date: date,
          isSelected:
              selectedDates.contains(date) || isRangeStart || isRangeEnd,
          isToday: date == today,
          isDisabled: isDisabled(date),
          isOutsideMonth: outside,
          isRangeStart: isRangeStart,
          isRangeEnd: isRangeEnd,
          isInRange:
              hasRange && date.isAfter(rangeStart!) && date.isBefore(rangeEnd!),
          events: events[date] ?? const [],
        );

        return _DayCell(
          details: details,
          theme: theme,
          locale: locale,
          highlightToday: highlightToday,
          hasRange: hasRange,
          dayBuilder: dayBuilder,
          onTap: () => onDayTap(date),
        );
      }),
    );
  }
}

class _DayCell extends StatelessWidget {
  final AwesomeDayDetails details;
  final AwesomeTheme theme;
  final Locale locale;
  final bool highlightToday;
  final bool hasRange;
  final AwesomeDayBuilder? dayBuilder;
  final VoidCallback onTap;

  const _DayCell({
    required this.details,
    required this.theme,
    required this.locale,
    required this.highlightToday,
    required this.hasRange,
    required this.dayBuilder,
    required this.onTap,
  });

  TextStyle get _textStyle {
    if (details.isSelected) return theme.selectedDayTextStyle;
    if (details.isDisabled) return theme.disabledDayTextStyle;
    if (details.isInRange) return theme.rangeDayTextStyle;
    if (details.isOutsideMonth) return theme.adjacentMonthDayTextStyle;
    return theme.unselectedDayTextStyle;
  }

  /// The strip behind the days of a selected range.
  Widget? get _rangeBand {
    final band = ColoredBox(color: theme.rangeBackgroundColor);
    if (details.isInRange) return band;
    if (hasRange && details.isRangeStart) {
      return Align(
        alignment: AlignmentDirectional.centerEnd,
        child: FractionallySizedBox(
            widthFactor: 0.5, heightFactor: 1, child: band),
      );
    }
    if (hasRange && details.isRangeEnd) {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: FractionallySizedBox(
            widthFactor: 0.5, heightFactor: 1, child: band),
      );
    }
    return null;
  }

  Widget _markers() {
    final shown = details.events.take(3).toList();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final event in shown)
          Container(
            width: theme.eventMarkerSize,
            height: theme.eventMarkerSize,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: event.color ??
                  (details.isSelected
                      ? theme.eventMarkerColorOnSelectedDay
                      : theme.eventMarkerColorOnUnselectedDay),
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }

  String get _semanticLabel {
    final d = details.date;
    final labels =
        details.events.map((e) => e.label).whereType<String>().join(', ');
    return '${d.day} ${AwesomeDateUtils.monthName(d.month, locale)} ${d.year}'
        '${labels.isEmpty ? '' : ', $labels'}';
  }

  @override
  Widget build(BuildContext context) {
    final Widget content;
    if (dayBuilder != null) {
      content = dayBuilder!(context, details);
    } else {
      final showToday =
          highlightToday && details.isToday && !details.isSelected;
      content = Stack(
        fit: StackFit.expand,
        children: [
          if (_rangeBand != null) _rangeBand!,
          Ink(
            decoration: BoxDecoration(
              color:
                  details.isSelected ? theme.selectedDateBackgroundColor : null,
              border: showToday
                  ? Border.all(
                      color: theme.todayBorderColor,
                      width: theme.todayBorderWidth)
                  : null,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${details.date.day}', style: _textStyle),
                    if (details.events.isNotEmpty) _markers(),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Semantics(
      button: true,
      selected: details.isSelected,
      enabled: !details.isDisabled,
      label: _semanticLabel,
      excludeSemantics: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: details.isDisabled ? null : onTap,
          child: content,
        ),
      ),
    );
  }
}
