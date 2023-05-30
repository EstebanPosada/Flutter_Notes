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

  updateNote(String note, int index) {
    notes[index] = Note(note, false);
    notifyListeners();
  }

  addReminder(String note) {
    rem.add(Note(note, true));
    notifyListeners();
  }

  updateReminder(String note, String date, int index) {
    Note oldNote = Note(note, true);
    oldNote.setDate(date);
    rem[index] = oldNote;
    notifyListeners();
  }

  Note getNoteByIndex(int index, bool isReminder) {
    if (index == null) return Note("", false);
    if (isReminder)
      return rem[index];
    else
      return notes[index];
  }

  remove(int index, bool isReminder) {
    if(isReminder) rem.removeAt(index); else notes.removeAt(index);
    notifyListeners();
  }
}
