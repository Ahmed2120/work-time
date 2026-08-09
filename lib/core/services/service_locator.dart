import 'package:get_it/get_it.dart';
import 'package:work_time/data/repositories/database_handler.dart';
import 'package:work_time/data/repositories/i_user_repository.dart';
import 'package:work_time/data/repositories/user_repository.dart';
import 'package:work_time/data/repositories/i_attendance_repository.dart';
import 'package:work_time/data/repositories/attendance_repository.dart';
import 'package:work_time/data/repositories/i_note_repository.dart';
import 'package:work_time/data/repositories/note_repository.dart';
import 'package:work_time/view_models/user_view_model.dart';
import 'package:work_time/view_models/attendance_view_model.dart';
import 'package:work_time/view_models/note_view_model.dart';
import 'package:work_time/view_models/theme_view_model.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Core Database Handler
  sl.registerLazySingleton<DatabaseHandler>(() => DatabaseHandler());

  // Repositories
  sl.registerLazySingleton<IUserRepository>(
    () => UserRepository(handler: sl<DatabaseHandler>()),
  );
  sl.registerLazySingleton<IAttendanceRepository>(
    () => AttendanceRepository(handler: sl<DatabaseHandler>()),
  );
  sl.registerLazySingleton<INoteRepository>(
    () => NoteRepository(handler: sl<DatabaseHandler>()),
  );

  // View Models
  sl.registerLazySingleton<ThemeViewModel>(
    () => ThemeViewModel(),
  );

  sl.registerFactory<UserViewModel>(
    () => UserViewModel(
      userRepository: sl<IUserRepository>(),
      attendanceRepository: sl<IAttendanceRepository>(),
    ),
  );
  sl.registerFactory<AttendanceViewModel>(
    () => AttendanceViewModel(
      repository: sl<IAttendanceRepository>(),
    ),
  );
  sl.registerFactory<NoteViewModel>(
    () => NoteViewModel(
      repository: sl<INoteRepository>(),
    ),
  );
}
