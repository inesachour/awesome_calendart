# CalenDart Flutter Package

## Overview
The "Awesome CalenDart" Flutter package offer a calendar widget designed to enhance your Flutter applications with a stylish and functional calendar display. </br>
The package provides the AwesomeCalenDart class, which can be easily integrated into your Flutter projects.

* Light Mode:
<p align="center" width="100%">
    <img src="https://raw.githubusercontent.com/inesachour/awesome_calendart/master/images/lightmode.jpg" height="300">
</p>

* Dark Mode:
<p align="center" width="100%">
    <img src="https://raw.githubusercontent.com/inesachour/awesome_calendart/master/images/darkmode.jpg" height="300">
</p>

## Usage
### Import the package

```dart
import 'package:awesome_calendart/awesome_calendart.dart';
```

### Instantiate the AwesomeCalenDart widget

```dart
AwesomeCalenDart(
    final double elevation = 5; // Elevation of the calendar, determines the shadow depth
    final double borderRadius = 20.0; // Border radius for rounded corners of the calendar
    final LocaleType locale = LocaleType.en; // Locale type to determine the language
    final bool displayFullMonthName = false;  // Determines whether to display the full month name (e.g., "January" vs "Jan")
    final TextStyle? yearAndMonthTextStyle; // Custom text style for the year and month header
    final TextStyle? weeksDaysTextStyle; // Custom text style for the week days (e.g., Sun, Mon, Tue, etc.)
    final TextStyle? selectedDaysTextStyle; // Custom text style for selected days in the calendar
    final TextStyle? unselectedDaysTextStyle; // Custom text style for unselected days in the calendar
    final AwesomeTheme? theme; // Theme for customizing the appearance of the calendar,
    final List<DateTime>? eventMarkers; //list of dates with markers to highlight events, reminders, or special occasions.
),
```

## LocaleType
The following table lists the currently supported locales for the calendar:

| Locale Code | Language         |
|-------------|------------------|
| en          | English          |
| fr          | French           |
| es          | Spanish          |
| de          | German           |
| it          | Italian          |
| pl          | Polish           |

To use a locale, set it as follows:
```dart
    locale: LocaleType.en
```

## AwesomeTheme
Themes can customize the calendar.

```dart
class AwesomeTheme {
    Color backgroundColor;
    Color buttonColor;
    TextStyle yearAndMonthHeaderTextStyle;
    TextStyle weekDaysTextStyle;
    Color selectedDateBackgroundColor;
    TextStyle selectedDayTextStyle;
    TextStyle unselectedDayTextStyle;
    Color eventMarkerColorOnUnselectedDay;
    Color eventMarkerColorOnSelectedDay;
}
```

We offer two custom themes: light mode and dark mode.
To use the light theme, set it as follows:
```dart
  theme: LightTheme(),
```

To use the dark theme, set it as follows:
```dart
  theme: DarkTheme(),
```
