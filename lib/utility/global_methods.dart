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


}