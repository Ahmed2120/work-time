import 'package:work_time/data/models/work_place.dart';

abstract class IWorkPlaceRepository {
  Future<List<WorkPlace>> getAll();
  Future<int> insert(String name);
  Future<void> update(int id, String oldName, String newName);
  Future<void> delete(int id, String name);
  Future<void> seedFromAttendance();
}
