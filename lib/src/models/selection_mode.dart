/// How the user can select dates in `AwesomeCalenDart`.
enum AwesomeSelectionMode {
  /// One date at a time. Tapping a day replaces the selection.
  single,

  /// Any number of dates. Tapping a day toggles it.
  multiple,

  /// A continuous range. The first tap sets the start, the second tap sets the
  /// end; tapping again starts a new range.
  range,
}
