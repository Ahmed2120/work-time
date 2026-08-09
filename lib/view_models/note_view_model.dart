import 'package:flutter/material.dart';
import 'package:work_time/core/services/service_locator.dart';
import 'package:work_time/data/models/note.dart';
import 'package:work_time/data/repositories/i_note_repository.dart';

class NoteViewModel with ChangeNotifier {
  final INoteRepository noteRepository;

  NoteViewModel({INoteRepository? repository})
      : noteRepository = repository ?? sl<INoteRepository>();

  List<Note> _notes = [];

  List<Note> get notes => _notes;

  Future<void> addNote(Note note) async {
    await noteRepository.insert(note);
    getNotes();
    notifyListeners();
  }

  Future<void> getNotes() async {
    _notes = await noteRepository.retrieve();
    _notes = _notes.reversed.toList();
    notifyListeners();
  }

  List<Note> searchNote(dynamic txt) {
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

  Future<void> updateNote(Note note) async {
    await noteRepository.update(note: note);
    getNotes();
    notifyListeners();
  }

  Future<void> deleteNote(Note note) async {
    await noteRepository.delete(note);
    getNotes();
    notifyListeners();
  }

  int colorVal = 0;
  bool color = false;

  void changeColor(bool val) {
    color = val;
    colorVal = color ? 1 : 0;
    notifyListeners();
  }

  void setColorVal(int val) {
    colorVal = val;
    color = val != 0;
    notifyListeners();
  }
}
