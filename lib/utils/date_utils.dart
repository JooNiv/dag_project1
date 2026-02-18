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

dateTimeStringToDateTime(String dateTimeString) {
  final parts = dateTimeString.split("-");
  if (parts.length != 3) return null;
  final year = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final day = int.tryParse(parts[2]);
  if (year == null || month == null || day == null) return null;
  return DateTime(year, month, day);
}

getDayNameThisYear(int month, int day) {
  final date = DateTime(DateTime.now().year, month + 1, day);
  return weekdayIndexToName(date.weekday);
}

getDaysInAMonth(int month) {
  if (month == 1) {
    final year = DateTime.now().year;
    if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) {
      return 29;
    }
  }
  return daysInAMonthMatrix[month];
}

getIndexOfFirstDayInAMonth(int month) {
  final date = DateTime(DateTime.now().year, month + 1, 1);
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