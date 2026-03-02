weekdayIndexToName(int index) {
  
  switch (index) {
    case 1:
      return "Monday";
    case 2:
      return "Tuesday";
    case 3:
      return "Wednesday";
    case 4:
      return "Thursday";
    case 5:
      return "Friday";
    case 6:
      return "Saturday";
    case 7:
      return "Sunday";
    default:
      return "Invalid day index";
  }
}

String formatDateKey(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

String buildDateKey(int year, int month, int day) {
  return formatDateKey(DateTime(year, month, day));
}

String todayDateKey() => formatDateKey(DateTime.now());

DateTime? parseDateKey(String key) {
  final parsed = DateTime.tryParse(key);
  if (parsed != null) {
    return DateTime(parsed.year, parsed.month, parsed.day);
  }

  final parts = key.split("-");
  if (parts.length != 3) return null;

  final year = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final day = int.tryParse(parts[2]);

  if (year == null || month == null || day == null) return null;
  return DateTime(year, month, day);
}

DateTime? dateTimeStringToDateTime(String dateTimeString) {
  return parseDateKey(dateTimeString);
}

String getDayNameThisYear(int month, int day, {int? year}) {
  final y = year ?? DateTime.now().year;
  final date = DateTime(y, month + 1, day);
  return weekdayIndexToName(date.weekday);
}

int getDaysInAMonth(int month, {int? year}) {
  final y = year ?? DateTime.now().year;
  return DateTime(y, month + 2, 0).day;
}

int getIndexOfFirstDayInAMonth(int month, {int? year}) {
  final y = year ?? DateTime.now().year;
  final date = DateTime(y, month + 1, 1);
  return date.weekday;
}

const daysInAMonthMatrix = [
  31,
  28,
  31,
  30,
  31,
  30,
  31,
  31,
  30,
  31,
  30,
  31,
  31,
  29,
  31,
  30,
  31,
  30,
  31,
  31,
  30,
  31,
  30,
  31
];

const monthNames = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];