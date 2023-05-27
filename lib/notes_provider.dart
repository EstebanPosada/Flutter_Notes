import 'package:flutter/widgets.dart';

import 'Note.dart';

class NotesProvider with ChangeNotifier {
  List<Note> _notes = [Note("nn1", false), Note("nn2", false)];
  List<Note> _rem = [Note("r9", true), Note("r8", true)];

  List<Note> get notes => _notes;

  List<Note> get rem => _rem;

  addNote(String note) {
    notes.add(Note(note, false));
    notifyListeners();
  }

  updateNote(Note note, int index) {
    notes[index] = note;
    notifyListeners();
  }

  addReminder(String note) {
    rem.add(Note(note, true));
    notifyListeners();
  }

  updateReminder(Note note, int index) {
    rem[index] = note;
    notifyListeners();
  }

  getNoteByIndex(int index, bool isReminder){
    if(isReminder) return rem[index]; else return notes[index];
  }
}
