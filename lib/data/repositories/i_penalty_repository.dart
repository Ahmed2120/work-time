import 'package:work_time/data/models/penalty.dart';

abstract class IPenaltyRepository {
  Future<int> insert(Penalty penalty);
  Future<List<Penalty>> retrieve();
  Future<List<Penalty>> retrieveByUserId(int userId);
  Future<int> delete(int id);
  Future<void> deleteByUserId(int userId);
}
