import 'package:upgrader/upgrader.dart';

class AppConstants{
  static final upgrader = Upgrader(

      durationUntilAlertAgain: const Duration(seconds: 5),
  );
}