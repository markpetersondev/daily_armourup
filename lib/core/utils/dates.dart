/// Calendar-day helpers.
///
/// Adding or subtracting `Duration(days: n)` counts 24-hour blocks, not
/// calendar days. On days when clocks change for daylight saving (23 or 25
/// hours long) that lands on the wrong date, e.g. "one day before 9 March"
/// gives 7 March in New York. These helpers work on the calendar instead.
library;

/// Midnight at the start of [d]'s calendar day.
DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Midnight on the calendar day [days] after [d] (negative goes back).
DateTime addDays(DateTime d, int days) =>
    DateTime(d.year, d.month, d.day + days);

/// Midnight on the Monday of [d]'s week.
DateTime startOfWeek(DateTime d) => addDays(d, -(d.weekday - 1));

/// 0 for 1 January, 1 for 2 January, and so on.
int dayOfYear(DateTime d) => DateTime.utc(d.year, d.month, d.day)
    .difference(DateTime.utc(d.year))
    .inDays;

/// Whether [a] and [b] fall on the same calendar day.
bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
