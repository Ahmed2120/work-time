import 'package:sqflite/sqflite.dart';
import 'package:work_time/data/models/work_place.dart';
import 'package:work_time/data/repositories/database_handler.dart';
import 'package:work_time/data/repositories/i_work_place_repository.dart';

class WorkPlaceRepository implements IWorkPlaceRepository {
  final String _table = 'work_places';
  final DatabaseHandler databaseHandler;

  WorkPlaceRepository({DatabaseHandler? handler})
      : databaseHandler = handler ?? DatabaseHandler();

  @override
  Future<void> seedFromAttendance() async {
    try {
      final db = await databaseHandler.initializeDB();
      await db.execute('''
        INSERT OR IGNORE INTO $_table (name)
        SELECT DISTINCT workPlace FROM attendance 
        WHERE workPlace IS NOT NULL 
          AND workPlace != '' 
          AND workPlace != 'لا يوجد' 
          AND workPlace != 'الورشة / الموقع'
      ''');
    } catch (e) {
      print('Error seeding work places: $e');
    }
  }

  @override
  Future<List<WorkPlace>> getAll() async {
    try {
      final db = await databaseHandler.initializeDB();
      final results = await db.query(_table, orderBy: 'id DESC');
      return results.map((e) => WorkPlace.fromMap(e)).toList();
    } catch (e) {
      print('Error getting work places: $e');
      return [];
    }
  }

  @override
  Future<int> insert(String name) async {
    try {
      final db = await databaseHandler.initializeDB();
      return await db.insert(
        _table,
        {'name': name},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } catch (e) {
      print('Error inserting work place: $e');
      return 0;
    }
  }

  @override
  Future<void> update(int id, String oldName, String newName) async {
    try {
      final db = await databaseHandler.initializeDB();
      await db.update(_table, {'name': newName}, where: 'id = ?', whereArgs: [id]);
      // Update historical attendance references so they reflect the new name
      await db.update('attendance', {'workPlace': newName}, where: 'workPlace = ?', whereArgs: [oldName]);
    } catch (e) {
      print('Error updating work place: $e');
    }
  }

  @override
  Future<void> delete(int id, String name) async {
    try {
      final db = await databaseHandler.initializeDB();
      await db.delete(_table, where: 'id = ?', whereArgs: [id]);
      // Clear or reset workplace in attendance table so it doesn't linger in old suggestions
      await db.update('attendance', {'workPlace': 'الورشة / الموقع'}, where: 'workPlace = ?', whereArgs: [name]);
    } catch (e) {
      print('Error deleting work place: $e');
    }
  }
}
