## 1.0.0

* An initial Calendar Widget.

## 1.0.1

* Small performance improvement.

## 1.0.2

* Better documentation

## 1.0.3

* Better documentation

## 1.0.4

* Better documentation

## 1.1.0

* More customization available

## 1.1.1

* Small performance improvement and dependency update

## 1.1.2

* Better documentation

## 1.2.0

* Events marker feature 

## 1.2.1

* Fix previous month bug + Add Polish locale
## 2.0.0

**Breaking changes**

* `LocaleType` is replaced by Flutter's `Locale` and is now powered by `intl`: every locale `intl` supports works (including right-to-left languages such as Arabic).
  Migrate `locale: LocaleType.fr` to `locale: const Locale('fr')`.
* `displayFullMonthName` is renamed `displayFullWeekdayNames` (it always controlled the weekday labels).
* `AwesomeTheme` fields are now `final` and its constructors are `const`. Use `copyWith` instead of assigning fields.

**New**

* Selection modes: single, multiple and range (`selectionMode`, `onDatesChanged`, `onRangeChanged`).
* `onDateSelected` and `onMonthChanged` callbacks.
* `AwesomeCalenDartController` to read and change the visible month and selection from code.
* `initialDate`, `minDate`, `maxDate`, `disabledDates`, `firstDayOfWeek`.
* Today highlight, adjacent month days, month and year pickers (tap the header), swipe to change month with animation.
* `AwesomeEvent` for colored markers with screen reader labels.
* Customization: `dayBuilder`, `monthYearFormatter`, `previousMonthIcon` / `nextMonthIcon`, `padding`, `dayAspectRatio`, `animationDuration` / `animationCurve`, `enableSwipe`, `enableMonthYearPicker`, and new `AwesomeTheme` fields.
* `AwesomeTheme.copyWith`, `==`, `hashCode` and `lerp`; `AwesomeTheme` is now a `ThemeExtension` (register it in `ThemeData.extensions`).
* Calendar formats: `calendarFormat` (month, two weeks, week) with an optional format button (`showFormatButton`, `onFormatChanged`).
* `showWeekNumbers` (ISO week numbers), `weekendDays` with `AwesomeTheme.weekendDayTextStyle`, and `specialDates` with `AwesomeDayStyle` for per-day styling.
* `selectableDayPredicate`, and `minRangeLength` / `maxRangeLength` for range selection.
* `showEventList` and `eventListBuilder` to list the selected day's events under the calendar.
* Numbers follow the locale's digits by default (Arabic-Indic for Arabic, Persian for `fa`, ...); set `useLocaleDigits: false` to always show 0-9.
* Keyboard navigation (arrow keys, Enter / Space, Page Up / Page Down) with a focus ring.
* `headerBuilder` and `weekdayBuilder`; `AwesomeDayDetails` gains `isWeekend` and `isFocused`.
* `AwesomeCalenDartController.focusedDate` and `jumpToDate`.
* Screen reader support and font scaling.

**Fixes**

* Days were not placed under the correct weekday.
* `theme`, `locale` and `displayFullWeekdayNames` changes were ignored after the first build.
* The nested grids could scroll inside scroll views.
