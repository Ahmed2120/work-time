import 'package:intl/intl.dart';

class GlobalMethods{

  static String getDayName(DateTime dateTime) {
    var enName = DateFormat('EEEE').format(dateTime);
    Map<String, String> day = {
      "Saturday": "السبت",
      "Sunday": "الاحد",
      "Monday": "الاثنين",
      "Tuesday": "الثلاثاء",
      "Wednesday": "الاربعاء",
      "Thursday": "الخميس",
      "Friday": "الجمعة",
    };
    return day[enName]!;
  }

  static String getDateFormat(DateTime dateTime) {

    return '${dateTime.year}-${dateTime.month<10?'0${dateTime.month}':dateTime.month}-${dateTime.day<10?'0${dateTime.day}':dateTime.day}';
  }

  static String getTimeFormat(DateTime dateTime) {

    String minute = dateTime.minute < 10 ? '0${dateTime.minute}' : '${dateTime.minute}';
    String time = dateTime.hour < 12 ? '${dateTime.hour}:$minute صباحاً' : '${dateTime.hour-12}:$minute مساءً';
    return time ;
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
    return this.add(
      Duration(
        days: (day - this.weekday) % DateTime.daysPerWeek,
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





