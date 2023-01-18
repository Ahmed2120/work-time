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
    _notes=await noteRepository.retrieve();
    notifyListeners();
  }
  List<Note> searchNote(txt){
  List<Note> notesListSearch = [];
  if (_notes.isNotEmpty) {
    for (var element in _notes) {
      if (element.title.contains(txt) || element.description.contains(txt)) {
        notesListSearch.add(element);
      }
    }
  }
  _notes = notesListSearch;
  notifyListeners();
  return _notes;
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

  int colorVal=-1;
  bool color=false;
  changeColor(bool val){
    color=val;
    if(color){
      colorVal=1;
    }else{
      colorVal=0;
    }
    notifyListeners();
  }
}
