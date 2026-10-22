// Internal, not exported by the package: the public API is documented in
// the exported files.
// ignore_for_file: public_member_api_docs

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
  final bool showWeekNumbers;
  final AwesomeWeekdayBuilder? weekdayBuilder;

  const AwesomeCalenDartWeekdays({
    super.key,
    required this.locale,
    required this.theme,
    required this.firstDayOfWeek,
    required this.full,
    this.showWeekNumbers = false,
    this.weekdayBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final names = AwesomeDateUtils.getWeekdayNames(locale,
        full: full, firstDayOfWeek: firstDayOfWeek);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (showWeekNumbers) const Expanded(child: SizedBox.shrink()),
          for (var i = 0; i < 7; i++)
            Expanded(
              child: weekdayBuilder != null
                  ? weekdayBuilder!(
                      context, (firstDayOfWeek - 1 + i) % 7 + 1, names[i])
                  : Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Text(
                            names[i],
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

/// The grid of days of one period: a month, two weeks or one week.
class AwesomeCalenDartDaysView extends StatelessWidget {
  /// The first cell of the grid (the first day of the first row).
  final DateTime periodStart;

  /// The number of weeks shown.
  final int rowCount;

  /// The displayed month in the month format (days of other months are dimmed
  /// or hidden), or null in the week formats.
  final DateTime? month;

  final Locale locale;
  final AwesomeTheme theme;
  final int firstDayOfWeek;
  final Set<int> weekendDays;
  final bool showAdjacentMonthDays;
  final bool showWeekNumbers;
  final bool highlightToday;
  final bool localeDigits;
  final double aspectRatio;
  final Set<DateTime> selectedDates;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final DateTime? focusedDate;
  final bool Function(DateTime date) isDisabled;
  final Map<DateTime, List<AwesomeEvent>> events;
  final Map<DateTime, AwesomeDayStyle> specialDates;
  final AwesomeDayBuilder? dayBuilder;
  final ValueChanged<DateTime> onDayTap;

  const AwesomeCalenDartDaysView({
    super.key,
    required this.periodStart,
    required this.rowCount,
    required this.month,
    required this.locale,
    required this.theme,
    required this.firstDayOfWeek,
    required this.weekendDays,
    required this.showAdjacentMonthDays,
    required this.showWeekNumbers,
    required this.highlightToday,
    required this.localeDigits,
    required this.aspectRatio,
    required this.selectedDates,
    required this.rangeStart,
    required this.rangeEnd,
    required this.focusedDate,
    required this.isDisabled,
    required this.events,
    required this.specialDates,
    required this.dayBuilder,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final today = AwesomeDateUtils.dateOnly(DateTime.now());
    final hasRange =
        rangeStart != null && rangeEnd != null && rangeStart != rangeEnd;
    // Thursday decides which ISO week a row belongs to.
    final thursdayColumn = (DateTime.thursday - firstDayOfWeek + 7) % 7;

    final children = <Widget>[];
    for (var row = 0; row < rowCount; row++) {
      DateTime dateAt(int col) => DateTime(
          periodStart.year, periodStart.month, periodStart.day + row * 7 + col);

      if (showWeekNumbers) {
        final week = AwesomeDateUtils.isoWeekNumber(dateAt(thursdayColumn));
        children.add(Center(
          child: Text(
            AwesomeDateUtils.formatNumber(week, locale,
                localeDigits: localeDigits),
            style: theme.weekNumberTextStyle,
          ),
        ));
      }

      for (var col = 0; col < 7; col++) {
        final date = dateAt(col);
        final outside = month != null && date.month != month!.month;
        if (outside && !showAdjacentMonthDays) {
          children.add(const SizedBox.shrink());
          continue;
        }

        final isRangeStart = rangeStart == date;
        final isRangeEnd = rangeEnd == date;
        final details = AwesomeDayDetails(
          date: date,
          isSelected:
              selectedDates.contains(date) || isRangeStart || isRangeEnd,
          isToday: date == today,
          isDisabled: isDisabled(date),
          isWeekend: weekendDays.contains(date.weekday),
          isFocused: focusedDate == date,
          isOutsideMonth: outside,
          isRangeStart: isRangeStart,
          isRangeEnd: isRangeEnd,
          isInRange:
              hasRange && date.isAfter(rangeStart!) && date.isBefore(rangeEnd!),
          events: events[date] ?? const [],
        );

        children.add(_DayCell(
          details: details,
          style: specialDates[date],
          theme: theme,
          locale: locale,
          highlightToday: highlightToday,
          localeDigits: localeDigits,
          hasRange: hasRange,
          dayBuilder: dayBuilder,
          onTap: () => onDayTap(date),
        ));
      }
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: showWeekNumbers ? 8 : 7,
      childAspectRatio: aspectRatio,
      padding: EdgeInsets.zero,
      children: children,
    );
  }
}

class _DayCell extends StatelessWidget {
  final AwesomeDayDetails details;
  final AwesomeDayStyle? style;
  final AwesomeTheme theme;
  final Locale locale;
  final bool highlightToday;
  final bool localeDigits;
  final bool hasRange;
  final AwesomeDayBuilder? dayBuilder;
  final VoidCallback onTap;

  const _DayCell({
    required this.details,
    required this.style,
    required this.theme,
    required this.locale,
    required this.highlightToday,
    required this.localeDigits,
    required this.hasRange,
    required this.dayBuilder,
    required this.onTap,
  });

  TextStyle get _textStyle {
    if (details.isSelected) return theme.selectedDayTextStyle;
    TextStyle base;
    if (details.isDisabled) {
      base = theme.disabledDayTextStyle;
    } else if (details.isInRange) {
      base = theme.rangeDayTextStyle;
    } else if (details.isOutsideMonth) {
      base = theme.adjacentMonthDayTextStyle;
    } else if (details.isWeekend) {
      base = theme.weekendDayTextStyle ?? theme.unselectedDayTextStyle;
    } else {
      base = theme.unselectedDayTextStyle;
    }
    return style?.textStyle == null ? base : base.merge(style!.textStyle);
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
    final day = AwesomeDateUtils.formatNumber(d.day, locale,
        localeDigits: localeDigits);
    final year = AwesomeDateUtils.formatNumber(d.year, locale,
        localeDigits: localeDigits);
    return '$day ${AwesomeDateUtils.monthName(d.month, locale)} $year'
        '${labels.isEmpty ? '' : ', $labels'}';
  }

  Border? get _border {
    if (details.isFocused) {
      return Border.all(color: theme.focusedDayBorderColor, width: 2);
    }
    if (highlightToday && details.isToday && !details.isSelected) {
      return Border.all(
          color: theme.todayBorderColor, width: theme.todayBorderWidth);
    }
    if (!details.isSelected && style?.borderColor != null) {
      return Border.all(color: style!.borderColor!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Widget content;
    if (dayBuilder != null) {
      content = dayBuilder!(context, details);
    } else {
      content = Stack(
        fit: StackFit.expand,
        children: [
          if (_rangeBand != null) _rangeBand!,
          Ink(
            decoration: BoxDecoration(
              color: details.isSelected
                  ? theme.selectedDateBackgroundColor
                  : style?.backgroundColor,
              border: _border,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AwesomeDateUtils.formatNumber(details.date.day, locale,
                          localeDigits: localeDigits),
                      style: _textStyle,
                    ),
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
          // Keyboard focus is handled by the grid as a whole.
          canRequestFocus: false,
          customBorder: const CircleBorder(),
          onTap: details.isDisabled ? null : onTap,
          child: content,
        ),
      ),
    );
  }
}
