# Awesome CalenDart

A highly customizable calendar widget for Flutter: single, multiple and range selection, month / two-week / week formats, date limits and rules, colored events with an agenda list, week numbers, month/year pickers, swipe and keyboard navigation, a controller, theming (including `ThemeExtension`), and 100+ languages (including right-to-left) via `intl`. Works on all platforms.

<p align="center">
    <img src="https://raw.githubusercontent.com/inesachour/awesome_calendart/master/images/overview.png" width="720" alt="Light and dark themes">
</p>

<table align="center">
  <tr>
    <td align="center"><img src="https://raw.githubusercontent.com/inesachour/awesome_calendart/master/images/range.png" width="240"><br><sub>Range selection, limits and disabled days</sub></td>
    <td align="center"><img src="https://raw.githubusercontent.com/inesachour/awesome_calendart/master/images/multiple.png" width="240"><br><sub>Multiple selection, Sunday first, adjacent days</sub></td>
    <td align="center"><img src="https://raw.githubusercontent.com/inesachour/awesome_calendart/master/images/weeknumbers.png" width="240"><br><sub>Week numbers, weekends and special dates</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="https://raw.githubusercontent.com/inesachour/awesome_calendart/master/images/week.png" width="240"><br><sub>Week format with the format button</sub></td>
    <td align="center"><img src="https://raw.githubusercontent.com/inesachour/awesome_calendart/master/images/agenda.png" width="240"><br><sub>Event list under the calendar</sub></td>
    <td align="center"><img src="https://raw.githubusercontent.com/inesachour/awesome_calendart/master/images/picker.png" width="240"><br><sub>Month and year picker</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="https://raw.githubusercontent.com/inesachour/awesome_calendart/master/images/arabic.png" width="240"><br><sub>Right-to-left locale (Arabic digits by default)</sub></td>
    <td align="center"><img src="https://raw.githubusercontent.com/inesachour/awesome_calendart/master/images/custom.png" width="240"><br><sub>Custom theme and <code>dayBuilder</code></sub></td>
    <td align="center"><img src="https://raw.githubusercontent.com/inesachour/awesome_calendart/master/images/darkmode.png" width="240"><br><sub>Dark theme with colored events</sub></td>
  </tr>
</table>

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

## Limits, rules and disabled days

```dart
AwesomeCalenDart(
  minDate: DateTime.now(),
  maxDate: DateTime(2027, 12, 31),
  disabledDates: [DateTime(2026, 12, 25)],
  selectableDayPredicate: (day) => day.weekday < DateTime.saturday, // weekdays only
)
```

Disabled days are greyed out and cannot be tapped; navigation and the pickers stop at `minDate` / `maxDate`. `selectableDayPredicate` handles rules a list of dates can't express.

### Range length

```dart
AwesomeCalenDart(
  selectionMode: AwesomeSelectionMode.range,
  minRangeLength: 2, // at least 2 days between start and end ("2 nights")
  maxRangeLength: 14,
)
```

While the end is being picked, days that would make the range too short or too long are disabled. To pick another start, tap an earlier day; with `minRangeLength > 0`, tapping the pending start again cancels it.

## Calendar format

```dart
AwesomeCalenDart(
  calendarFormat: AwesomeCalendarFormat.week, // month (default), twoWeeks, week
  showFormatButton: true,                     // header button cycling the formats
  onFormatChanged: (format) {},
)
```

Navigation, swipe, the keyboard and `minDate` / `maxDate` all work by week or two weeks in the shorter formats. The header shows the month of the visible week.

## Controller

Read or change the state from code:

```dart
final controller = AwesomeCalenDartController();

AwesomeCalenDart(controller: controller);

controller.jumpToMonth(DateTime(2027, 3));
controller.jumpToDate(DateTime(2027, 3, 14)); // the month, or the week in the week formats
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
  events: [                                          // colored, with a label
    AwesomeEvent(date: DateTime(2026, 10, 5), color: Colors.green, label: 'Dentist'),
    AwesomeEvent(date: DateTime(2026, 10, 5), color: Colors.amber),
  ],
  showEventList: true,                               // list the selected day's events below
)
```

Up to three markers are shown per day, and event labels are read by screen readers. `showEventList` draws a simple list of the labels; for your own design use `eventListBuilder`:

```dart
AwesomeCalenDart(
  events: myEvents,
  eventListBuilder: (context, date, events) => Column(
    children: [for (final e in events) ListTile(title: Text(e.label ?? ''))],
  ),
)
```

The builder is called with the selected day (the last tapped day in the multiple and range modes) and its events, possibly none.

## Week numbers, weekends and special days

```dart
AwesomeCalenDart(
  showWeekNumbers: true,                                   // ISO week numbers
  weekendDays: const [DateTime.friday, DateTime.saturday], // default: Saturday, Sunday
  theme: const LightTheme().copyWith(
    weekendDayTextStyle: const TextStyle(color: Colors.red),
  ),
  specialDates: {
    DateTime(2026, 12, 25): const AwesomeDayStyle(
      backgroundColor: Color(0x3300AA55),
      textStyle: TextStyle(fontWeight: FontWeight.bold),
    ),
  },
)
```

`AwesomeDayStyle` accepts `textStyle`, `backgroundColor` and `borderColor`. Selected days keep the selected style.

## Keyboard navigation

When the calendar has keyboard focus (Tab on web and desktop), the arrow keys move between days, Enter or Space select the focused day, and Page Up / Page Down change the period. A ring (`AwesomeTheme.focusedDayBorderColor`) shows the focused day. Turn it off with `enableKeyboardNavigation: false`.

## Customization

### All parameters

| Parameter | Default | Description |
|---|---|---|
| `theme` | `ThemeData` extension, else `LightTheme()` | Colors and text styles, see below |
| `controller` | — | Read / change the month and selection from code |
| `initialDate` | today | First visible month (and first selected date in `single` mode) |
| `selectionMode` | `single` | `single`, `multiple` or `range` |
| `calendarFormat` | `month` | `month`, `twoWeeks` or `week` |
| `showFormatButton` / `formatButtonTooltip` / `onFormatChanged` | `false` / "Change view" / — | Header button cycling the formats |
| `minDate` / `maxDate` / `disabledDates` | — | Selectable range and disabled days |
| `selectableDayPredicate` | — | Custom rule: return false to disable a day |
| `minRangeLength` / `maxRangeLength` | — | Allowed distance in days between a range's start and end |
| `locale` | `Locale('en')` | Language of month/weekday names; RTL languages mirror the layout |
| `useLocaleDigits` | `true` | Digits of the locale (Arabic-Indic for `ar`, Persian for `fa`, ...); `false` always shows 0-9 |
| `firstDayOfWeek` | `DateTime.monday` | `DateTime.monday` … `DateTime.sunday` |
| `weekendDays` | Saturday, Sunday | Days styled with `weekendDayTextStyle` |
| `displayFullWeekdayNames` | `false` | "Monday" instead of "Mon" |
| `showWeekNumbers` | `false` | ISO week number column |
| `highlightToday` | `true` | Ring around today |
| `showAdjacentMonthDays` | `false` | Fill empty cells with the previous/next month's days |
| `eventMarkers` / `events` | — | Dots under days (simple / colored with labels) |
| `specialDates` | — | Per-day `AwesomeDayStyle` |
| `showEventList` / `eventListBuilder` | `false` / — | Events of the selected day under the grid |
| `enableSwipe` | `true` | Swipe horizontally to change period |
| `enableKeyboardNavigation` | `true` | Arrow keys, Enter/Space, Page Up/Down |
| `enableMonthYearPicker` | `true` | Tap the header to open the month and year pickers |
| `elevation` / `borderRadius` | `5` / `20` | Card shape |
| `padding` | `h10, v8` | Space inside the card |
| `dayAspectRatio` | `1.5` | Width / height of a day cell (reduced automatically for large system fonts) |
| `animationDuration` / `animationCurve` | `250 ms` / `easeInOut` | Use `Duration.zero` to disable animations |
| `previousMonthIcon` / `nextMonthIcon` | arrows | Replace the navigation icons |
| `monthYearFormatter` | "October 2026" | Custom header title |
| `dayBuilder` / `headerBuilder` / `weekdayBuilder` | — | Draw the day cells, the header or the weekday labels yourself |
| `onDateSelected` / `onDatesChanged` / `onRangeChanged` / `onMonthChanged` | — | Callbacks, see [Selection](#selection) |

### Theme

```dart
AwesomeCalenDart(
  theme: const DarkTheme().copyWith(
    selectedDateBackgroundColor: Colors.teal,
    todayBorderColor: Colors.teal,
  ),
)
```

`LightTheme` and `DarkTheme` are ready-made; build your own with `AwesomeTheme(...)` or `copyWith`. Themes support `==`, `hashCode` and `lerp`.

`AwesomeTheme` is a `ThemeExtension`: register it once and every calendar without an explicit `theme` follows your app theme.

```dart
MaterialApp(
  theme: ThemeData(extensions: const [LightTheme()]),
  darkTheme: ThemeData.dark().copyWith(extensions: const [DarkTheme()]),
)
```

| Field | Description |
|---|---|
| `backgroundColor`, `buttonColor` | Card and navigation button colors |
| `yearAndMonthHeaderTextStyle`, `weekDaysTextStyle` | Header and weekday labels |
| `selectedDateBackgroundColor`, `selectedDayTextStyle` | Selected days (and range end points) |
| `unselectedDayTextStyle`, `weekendDayTextStyle`, `disabledDayTextStyle`, `adjacentMonthDayTextStyle` | Other days (`weekendDayTextStyle` is optional) |
| `weekNumberTextStyle` | Week numbers column |
| `focusedDayBorderColor` | Keyboard focus ring |
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

`AwesomeDayDetails` exposes `date`, `isSelected`, `isToday`, `isDisabled`, `isWeekend`, `isFocused`, `isOutsideMonth`, `isRangeStart`, `isRangeEnd`, `isInRange` and `events`.

### Custom header and weekday labels

```dart
AwesomeCalenDart(
  headerBuilder: (context, header) => Row(
    children: [
      IconButton(onPressed: header.canGoPrevious ? header.goToPrevious : null, icon: const Icon(Icons.chevron_left)),
      Expanded(child: TextButton(onPressed: header.openPicker, child: Text(header.title))),
      IconButton(onPressed: header.canGoNext ? header.goToNext : null, icon: const Icon(Icons.chevron_right)),
    ],
  ),
  weekdayBuilder: (context, weekday, label) => Center(child: Text(label[0])), // M T W T F S S
)
```

`AwesomeHeaderDetails` exposes `month`, `title`, `canGoPrevious`, `canGoNext`, `goToPrevious`, `goToNext`, `openPicker` and `changeFormat` (null when the corresponding feature is off). `weekday` is `DateTime.monday` … `DateTime.sunday`.

## Localization

Names come from `intl`, so any locale it supports works:

```dart
AwesomeCalenDart(locale: const Locale('fr'))   // also: de, es, it, pl, ar, ja, ...
```

Right-to-left languages (Arabic, Hebrew, Persian, Urdu, ...) mirror the layout, swipe direction, keyboard arrows and navigation arrows.

Numbers follow the locale by default, using the digits `intl` defines: Arabic-Indic for every Arabic locale (`ar`, `ar_EG`, ...), Persian for `fa`, Bengali for `bn`, Devanagari for `mr` / `ne`, and so on. Locales that use 0-9 (English, French, German, ...) are unaffected. To always show 0-9, even in those languages:

```dart
AwesomeCalenDart(locale: const Locale('ar'), useLocaleDigits: false)
```

## Accessibility

Each day is announced with its full date (and event labels), selected state and disabled state; navigation buttons have tooltips naming the target month; day cells scale with the system font size; the days can be reached and operated with the keyboard.

## Migrating from 1.x

* `locale: LocaleType.fr` → `locale: const Locale('fr')`
* `displayFullMonthName` → `displayFullWeekdayNames`
* `AwesomeTheme` fields are `final` (use `copyWith`).

See the [example](example/lib/main.dart) for every feature in action, and the [changelog](CHANGELOG.md).

## Contributing

The screenshots above are generated from the real widgets: run `flutter test tool/generate_screenshots_test.dart` to refresh the files in `images/`.
