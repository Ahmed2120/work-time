import 'package:work_time/data/models/penalty.dart';
import 'package:work_time/data/repositories/database_handler.dart';
import 'package:work_time/data/repositories/i_penalty_repository.dart';

class PenaltyRepository implements IPenaltyRepository {
  final String _tableName = 'penalties';
  final DatabaseHandler databaseHandler;

  PenaltyRepository({DatabaseHandler? handler})
      : databaseHandler = handler ?? DatabaseHandler();

  @override
  Future<int> insert(Penalty penalty) async {
    try {
      final db = await databaseHandler.initializeDB();
      return await db.insert(_tableName, penalty.toMap());
    } catch (e) {
      print("Error inserting penalty: $e");
      return 0;
    }
  }

  @override
  Future<List<Penalty>> retrieve() async {
    try {
      final db = await databaseHandler.initializeDB();
      final List<Map<String, dynamic>> results = await db.query(
        _tableName,
        orderBy: 'date DESC, id DESC',
      );
      return results.map((e) => Penalty.fromMap(e)).toList();
    } catch (e) {
      print("Error retrieving penalties: $e");
      return [];
    }
  }

  @override
  Future<List<Penalty>> retrieveByUserId(int userId) async {
    try {
      final db = await databaseHandler.initializeDB();
      final List<Map<String, dynamic>> results = await db.query(
        _tableName,
        where: 'userId = ?',
        whereArgs: [userId],
        orderBy: 'date DESC, id DESC',
      );
      return results.map((e) => Penalty.fromMap(e)).toList();
    } catch (e) {
      print("Error retrieving penalties by userId: $e");
      return [];
    }
  }

  @override
  Future<int> delete(int id) async {
    try {
      final db = await databaseHandler.initializeDB();
      return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print("Error deleting penalty: $e");
      return 0;
    }
  }

  @override
  Future<void> deleteByUserId(int userId) async {
    try {
      final db = await databaseHandler.initializeDB();
      await db.delete(_tableName, where: 'userId = ?', whereArgs: [userId]);
    } catch (e) {
      print("Error deleting penalties by userId: $e");
    }
  }
}
