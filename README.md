# Awesome CalenDart

A highly customizable calendar widget for Flutter: single, multiple and range selection, date limits, colored event markers, month/year pickers, swipe navigation, controller, theming, and 100+ languages (including right-to-left) via `intl`. Works on all platforms.

* Light Mode:
<p align="center" width="100%">
    <img src="https://raw.githubusercontent.com/inesachour/awesome_calendart/master/images/lightmode.jpg" height="300">
</p>

* Dark Mode:
<p align="center" width="100%">
    <img src="https://raw.githubusercontent.com/inesachour/awesome_calendart/master/images/darkmode.jpg" height="300">
</p>

## Getting started

```yaml
dependencies:
  awesome_calendart: ^2.0.0
```

```dart
import 'package:awesome_calendart/awesome_calendart.dart';

AwesomeCalenDart(
  onDateSelected: (date) => print(date),
)
```

Every parameter is optional.

## Selection

```dart
AwesomeCalenDart(
  selectionMode: AwesomeSelectionMode.range, // single (default), multiple, range
  onRangeChanged: (start, end) {},           // end is null until the 2nd tap
)
```

| Mode       | Behavior                                      | Callbacks                              |
|------------|-----------------------------------------------|----------------------------------------|
| `single`   | Tapping a day selects it (today by default).  | `onDateSelected`                       |
| `multiple` | Tapping a day toggles it.                     | `onDateSelected`, `onDatesChanged`     |
| `range`    | 1st tap sets the start, 2nd the end, 3rd restarts. | `onDateSelected`, `onRangeChanged` |

`onMonthChanged(DateTime firstDayOfMonth)` fires whenever the visible month changes, whatever the selection mode.

## Limits and disabled days

```dart
AwesomeCalenDart(
  minDate: DateTime.now(),
  maxDate: DateTime(2027, 12, 31),
  disabledDates: [DateTime(2026, 12, 25)],
)
```

Disabled days are greyed out and cannot be tapped; month navigation and the pickers stop at `minDate` / `maxDate`. A selected range may still contain disabled days.

## Controller

Read or change the state from code:

```dart
final controller = AwesomeCalenDartController();

AwesomeCalenDart(controller: controller);

controller.jumpToMonth(DateTime(2027, 3));
controller.selectDate(DateTime(2027, 3, 14));
controller.selectRange(DateTime(2027, 3, 1), DateTime(2027, 3, 7));
print(controller.selectedDate);   // also: selectedDates, selectedRange, visibleMonth
controller.clearSelection();
```

It is a `ChangeNotifier`: listen to it, and `dispose()` it when done. The calendar never disposes a controller you pass in. Without a controller, `initialDate` sets the first visible month (and, in `single` mode, the first selected date).

## Events

```dart
AwesomeCalenDart(
  eventMarkers: [DateTime(2026, 10, 3)],             // simple dots
  events: [                                          // colored, with a label for screen readers
    AwesomeEvent(date: DateTime(2026, 10, 5), color: Colors.green, label: 'Dentist'),
    AwesomeEvent(date: DateTime(2026, 10, 5), color: Colors.amber),
  ],
)
```

Up to three markers are shown per day.

## Customization

### All parameters

| Parameter | Default | Description |
|---|---|---|
| `theme` | `LightTheme()` | Colors and text styles, see below |
| `locale` | `Locale('en')` | Language of month/weekday names; RTL languages mirror the layout |
| `firstDayOfWeek` | `DateTime.monday` | `DateTime.monday` … `DateTime.sunday` |
| `displayFullWeekdayNames` | `false` | "Monday" instead of "Mon" |
| `highlightToday` | `true` | Ring around today |
| `showAdjacentMonthDays` | `false` | Fill empty cells with the previous/next month's days |
| `enableSwipe` | `true` | Swipe horizontally to change month |
| `enableMonthYearPicker` | `true` | Tap the header to open the month and year pickers |
| `elevation` / `borderRadius` | `5` / `20` | Card shape |
| `padding` | `h10, v8` | Space inside the card |
| `dayAspectRatio` | `1.5` | Width / height of a day cell (reduced automatically for large system fonts) |
| `animationDuration` / `animationCurve` | `250 ms` / `easeInOut` | Use `Duration.zero` to disable animations |
| `previousMonthIcon` / `nextMonthIcon` | arrows | Replace the navigation icons |
| `monthYearFormatter` | "October 2026" | Custom header title |
| `dayBuilder` | — | Draw every day yourself |

### Theme

```dart
AwesomeCalenDart(
  theme: const DarkTheme().copyWith(
    selectedDateBackgroundColor: Colors.teal,
    todayBorderColor: Colors.teal,
  ),
)
```

`LightTheme` and `DarkTheme` are ready-made; build your own with `AwesomeTheme(...)` or `copyWith`.

| Field | Description |
|---|---|
| `backgroundColor`, `buttonColor` | Card and navigation button colors |
| `yearAndMonthHeaderTextStyle`, `weekDaysTextStyle` | Header and weekday labels |
| `selectedDateBackgroundColor`, `selectedDayTextStyle` | Selected days (and range end points) |
| `unselectedDayTextStyle`, `disabledDayTextStyle`, `adjacentMonthDayTextStyle` | Other days |
| `rangeBackgroundColor`, `rangeDayTextStyle` | Days inside a selected range |
| `todayBorderColor`, `todayBorderWidth` | Today ring |
| `eventMarkerColorOnSelectedDay`, `eventMarkerColorOnUnselectedDay`, `eventMarkerSize` | Event dots |

### Custom day cells

`dayBuilder` replaces the content of each cell. Tapping, disabled state and accessibility are still handled for you:

```dart
AwesomeCalenDart(
  dayBuilder: (context, day) => Center(
    child: Text(
      '${day.date.day}',
      style: TextStyle(
        color: day.isSelected ? Colors.teal : null,
        fontWeight: day.isToday ? FontWeight.bold : null,
      ),
    ),
  ),
)
```

`AwesomeDayDetails` exposes `date`, `isSelected`, `isToday`, `isDisabled`, `isOutsideMonth`, `isRangeStart`, `isRangeEnd`, `isInRange` and `events`.

## Localization

Names come from `intl`, so any locale it supports works:

```dart
AwesomeCalenDart(locale: const Locale('fr'))   // also: de, es, it, pl, ar, ja, ...
```

Right-to-left languages (Arabic, Hebrew, Persian, Urdu, ...) mirror the layout, swipe direction and navigation arrows.

## Accessibility

Each day is announced with its full date (and event labels), selected state and disabled state; navigation buttons have tooltips naming the target month; day cells scale with the system font size.

## Migrating from 1.x

* `locale: LocaleType.fr` → `locale: const Locale('fr')`
* `displayFullMonthName` → `displayFullWeekdayNames`
* `AwesomeTheme` fields are `final` (use `copyWith`).

See the [example](example/lib/main.dart) for every feature in action, and the [changelog](CHANGELOG.md).
