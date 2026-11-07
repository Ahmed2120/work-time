import 'package:intl/intl.dart';

class GlobalMethods{

  static String getDayName(DateTime dateTime, [String? locale]) {
    final enName = DateFormat('EEEE', 'en').format(dateTime);
    if (locale == 'en') {
      return enName;
    }
    const Map<String, String> day = {
      "Saturday": "السبت",
      "Sunday": "الاحد",
      "Monday": "الاثنين",
      "Tuesday": "الثلاثاء",
      "Wednesday": "الاربعاء",
      "Thursday": "الخميس",
      "Friday": "الجمعة",
    };
    return day[enName] ?? enName;
  }

  static String getDateFormat(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month<10?'0${dateTime.month}':dateTime.month}-${dateTime.day<10?'0${dateTime.day}':dateTime.day}';
  }

  static String getTimeFormat(DateTime dateTime, [String? locale]) {
    final minute = dateTime.minute < 10 ? '0${dateTime.minute}' : '${dateTime.minute}';
    final isAm = dateTime.hour < 12;
    final hour = isAm ? (dateTime.hour == 0 ? 12 : dateTime.hour) : (dateTime.hour == 12 ? 12 : dateTime.hour - 12);
    final period = locale == 'en' ? (isAm ? 'AM' : 'PM') : (isAm ? 'صباحاً' : 'مساءً');
    return '$hour:$minute $period';
  }

  /// Returns the Friday that closes the Saturday→Friday week containing [dateTime].
  /// Week runs: Saturday (start) → Friday (end).
  static DateTime getWeekEnd(DateTime dateTime) {
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    // daysUntilFriday: how many days until the next Friday (0 if already Friday)
    final int daysUntilFriday = (DateTime.friday - date.weekday + 7) % 7;
    return date.add(Duration(days: daysUntilFriday));
  }

  /// Legacy alias kept for compatibility — delegates to getWeekEnd.
  static DateTime getWeekDay(DateTime dateTime) => getWeekEnd(dateTime);
}

extension DateTimeExtension on DateTime {
  DateTime next(int day) {
    return add(
      Duration(
        days: (day - weekday) % DateTime.daysPerWeek,
      ),
    );
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month
        && day == other.day;
  }
}





