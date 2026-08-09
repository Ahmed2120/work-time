import 'package:work_time/data/models/note.dart';
import 'package:work_time/data/repositories/database_handler.dart';
import 'package:work_time/data/repositories/i_note_repository.dart';

class NoteRepository implements INoteRepository {
  final String _tableName = 'notes';
  final DatabaseHandler databaseHandler;

  NoteRepository({DatabaseHandler? handler}) 
      : databaseHandler = handler ?? DatabaseHandler();

  @override
  Future<int> insert(Note note) async {
    try {
      final db = await databaseHandler.initializeDB();
      return await db.insert(_tableName, note.toMap());
    } catch (e) {
      print("Error inserting note: $e");
      return 0;
    }
  }

  @override
  Future<List<Note>> retrieve() async {
    try {
      final db = await databaseHandler.initializeDB();
      final List<Map<String, Object?>> queryResults = await db.query(_tableName);
      return queryResults.map((e) => Note.fromMap(e)).toList();
    } catch (e) {
      print("Error retrieving notes: $e");
      return [];
    }
  }

  @override
  Future<int> update({required Note note}) async {
    try {
      final db = await databaseHandler.initializeDB();
      return await db.update(_tableName, note.toMap(), where: 'id = ?', whereArgs: [note.id!]);
    } catch (e) {
      print("Error updating note: $e");
      return 0;
    }
  }

  @override
  Future<void> delete(Note note) async {
    try {
      final db = await databaseHandler.initializeDB();
      await db.delete(_tableName, where: 'id = ?', whereArgs: [note.id]);
    } catch (e) {
      print("Error deleting note: $e");
    }
  }
}

