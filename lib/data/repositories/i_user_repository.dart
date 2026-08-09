import 'package:work_time/data/models/user.dart';

abstract class IUserRepository {
  Future<int> insert(User user);
  Future<List<User>> retrieve({int trash = 0});
  Future<List<String>> retrieveSalaries();
  Future<int> update({required User user});
  Future<void> delete(User user);
}
