import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:work_time/db/attendanceReposetory.dart';

import '../db/noteRepository.dart';
import '../model/note.dart';

class NoteProvider with ChangeNotifier {

  List<Note> _notes = [];

  List<Note> get notes {
    return _notes;
  }

  Future<void> addNote(Note note) async {
    final noteRepository = NoteRepository();

    final int userId = await noteRepository.insert(note);
    note.id = userId;
    _notes.add(note);
    notifyListeners();
  }

  getNotes()async{
    final noteRepository = NoteRepository();
    var databasesPath = await getDatabasesPath();
    print(databasesPath+'الباص');
   // String path = join(databasesPath, 'cities.db');
    _notes=await noteRepository.retrieve();
    notifyListeners();
  }


  updateNote(Note note){
    final noteRepository = NoteRepository();
    noteRepository.update(note: note);
    getNotes();
    notifyListeners();
  }
  deleteNote(Note note){
    final noteRepository = NoteRepository();
    noteRepository.delete(note);
    getNotes();
    notifyListeners();
  }
}
