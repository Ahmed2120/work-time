import 'package:work_time/data/models/note.dart';

abstract class INoteRepository {
  Future<int> insert(Note note);
  Future<List<Note>> retrieve();
  Future<int> update({required Note note});
  Future<void> delete(Note note);
}
