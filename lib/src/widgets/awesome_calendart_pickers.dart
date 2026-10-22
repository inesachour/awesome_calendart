import 'package:awesome_calendart/src/theme/theme.dart';
import 'package:awesome_calendart/src/utils/date_utils.dart';
import 'package:flutter/material.dart';

/// The row shown above every view: a title between two navigation buttons.
class AwesomeCalenDartHeader extends StatelessWidget {
  final String title;
  final AwesomeTheme theme;
  final VoidCallback? onTitleTap;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final String? previousTooltip;
  final String? nextTooltip;
  final Widget? previousIcon;
  final Widget? nextIcon;
  final Widget? trailing;

  const AwesomeCalenDartHeader({
    super.key,
    required this.title,
    required this.theme,
    this.onTitleTap,
    this.onPrevious,
    this.onNext,
    this.previousTooltip,
    this.nextTooltip,
    this.previousIcon,
    this.nextIcon,
    this.trailing,
  });

  Widget _icon(Widget? custom, IconData data, bool enabled) {
    final icon = custom ?? Icon(data, color: theme.buttonColor);
    return enabled ? icon : Opacity(opacity: 0.3, child: icon);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: previousTooltip,
          onPressed: onPrevious,
          icon: _icon(previousIcon, Icons.arrow_back_ios, onPrevious != null),
        ),
        Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onTitleTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: theme.yearAndMonthHeaderTextStyle,
              ),
            ),
          ),
        ),
        IconButton(
          tooltip: nextTooltip,
          onPressed: onNext,
          icon: _icon(nextIcon, Icons.arrow_forward_ios, onNext != null),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// A 3x4 grid of selectable labels, shared by the month and year pickers.
class _PickerGrid extends StatelessWidget {
  final List<String> labels;
  final int? selectedIndex;
  final bool Function(int index) isDisabled;
  final ValueChanged<int> onTap;
  final AwesomeTheme theme;

  const _PickerGrid({
    required this.labels,
    required this.selectedIndex,
    required this.isDisabled,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 2,
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: List.generate(labels.length, (i) {
        final selected = i == selectedIndex;
        final disabled = isDisabled(i);
        return Semantics(
          button: true,
          selected: selected,
          excludeSemantics: true,
          label: labels[i],
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                customBorder: const StadiumBorder(),
                onTap: disabled ? null : () => onTap(i),
                child: Ink(
                  decoration: ShapeDecoration(
                    shape: const StadiumBorder(),
                    color: selected ? theme.selectedDateBackgroundColor : null,
                  ),
                  child: Center(
                    child: Text(
                      labels[i],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: selected
                          ? theme.selectedDayTextStyle
                          : disabled
                              ? theme.disabledDayTextStyle
                              : theme.unselectedDayTextStyle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// Lets the user pick a month of [year].
class AwesomeCalenDartMonthPicker extends StatelessWidget {
  final int year;
  final Locale locale;
  final AwesomeTheme theme;
  final DateTime selectedMonth;
  final DateTime? minMonth;
  final DateTime? maxMonth;
  final ValueChanged<int> onYearChanged;
  final ValueChanged<int> onMonthSelected;
  final VoidCallback onYearTap;
  final Widget? previousIcon;
  final Widget? nextIcon;
  final bool localeDigits;

  const AwesomeCalenDartMonthPicker({
    super.key,
    required this.year,
    required this.locale,
    required this.theme,
    required this.selectedMonth,
    required this.onYearChanged,
    required this.onMonthSelected,
    required this.onYearTap,
    this.minMonth,
    this.maxMonth,
    this.previousIcon,
    this.nextIcon,
    this.localeDigits = false,
  });

  String _n(int v) =>
      AwesomeDateUtils.formatNumber(v, locale, localeDigits: localeDigits);

  @override
  Widget build(BuildContext context) {
    final canPrevious = minMonth == null || year - 1 >= minMonth!.year;
    final canNext = maxMonth == null || year + 1 <= maxMonth!.year;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AwesomeCalenDartHeader(
          title: _n(year),
          theme: theme,
          onTitleTap: onYearTap,
          onPrevious: canPrevious ? () => onYearChanged(year - 1) : null,
          onNext: canNext ? () => onYearChanged(year + 1) : null,
          previousTooltip: _n(year - 1),
          nextTooltip: _n(year + 1),
          previousIcon: previousIcon,
          nextIcon: nextIcon,
        ),
        _PickerGrid(
          theme: theme,
          labels: List.generate(
              12, (i) => AwesomeDateUtils.shortMonthName(i + 1, locale)),
          selectedIndex:
              selectedMonth.year == year ? selectedMonth.month - 1 : null,
          isDisabled: (i) {
            final month = DateTime(year, i + 1);
            return (minMonth != null && month.isBefore(minMonth!)) ||
                (maxMonth != null && month.isAfter(maxMonth!));
          },
          onTap: (i) => onMonthSelected(i + 1),
        ),
      ],
    );
  }
}

/// Lets the user pick a year from a page of 12 years starting at [startYear].
class AwesomeCalenDartYearPicker extends StatelessWidget {
  static const int pageSize = 12;

  final int startYear;
  final int selectedYear;
  final int? minYear;
  final int? maxYear;
  final AwesomeTheme theme;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onYearSelected;
  final Widget? previousIcon;
  final Widget? nextIcon;
  final Locale locale;
  final bool localeDigits;

  const AwesomeCalenDartYearPicker({
    super.key,
    required this.startYear,
    required this.selectedYear,
    required this.theme,
    required this.onPageChanged,
    required this.onYearSelected,
    this.minYear,
    this.maxYear,
    this.previousIcon,
    this.nextIcon,
    this.locale = const Locale('en'),
    this.localeDigits = false,
  });

  String _n(int v) =>
      AwesomeDateUtils.formatNumber(v, locale, localeDigits: localeDigits);

  @override
  Widget build(BuildContext context) {
    final endYear = startYear + pageSize - 1;
    final canPrevious = minYear == null || startYear - 1 >= minYear!;
    final canNext = maxYear == null || endYear + 1 <= maxYear!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AwesomeCalenDartHeader(
          title: '${_n(startYear)} - ${_n(endYear)}',
          theme: theme,
          onPrevious:
              canPrevious ? () => onPageChanged(startYear - pageSize) : null,
          onNext: canNext ? () => onPageChanged(startYear + pageSize) : null,
          previousIcon: previousIcon,
          nextIcon: nextIcon,
        ),
        _PickerGrid(
          theme: theme,
          labels: List.generate(pageSize, (i) => _n(startYear + i)),
          selectedIndex: selectedYear >= startYear && selectedYear <= endYear
              ? selectedYear - startYear
              : null,
          isDisabled: (i) {
            final y = startYear + i;
            return (minYear != null && y < minYear!) ||
                (maxYear != null && y > maxYear!);
          },
          onTap: (i) => onYearSelected(startYear + i),
        ),
      ],
    );
  }
}
