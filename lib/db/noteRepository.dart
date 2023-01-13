
import '../model/note.dart';
import 'DatabaseHandler.dart';

class NoteRepository{
  String table_name = 'notes';
  DatabaseHandler databaseHandler = DatabaseHandler();

  Future insert(Note note) async{
    int result = 0;
    final db = await databaseHandler.initializeDB();
    result = await db.insert(table_name, note.toMap());
    return result;
  }

  Future retrieve() async{
    final db = await databaseHandler.initializeDB();
    final List<Map<String, Object?>> queryResults = await db.query(table_name);
    return queryResults.map((e) => Note.fromMap(e)).toList();
  }
  Future update({required Note note}) async {
    int result = 0;
    final db = await databaseHandler.initializeDB();
    result = await db.update(table_name,note.toMap() ,where: 'id = ?', whereArgs: [note.id!]);
    return result;
  }

  Future delete(Note note) async{
    final db = await databaseHandler.initializeDB();
    db.delete(table_name, where: 'id = ?', whereArgs: [note.id]);
  }
}