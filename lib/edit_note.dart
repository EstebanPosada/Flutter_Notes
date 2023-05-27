import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/notes_provider.dart';

class EditNote extends StatefulWidget {
  String note;
  bool isReminder;
  String date;
  NotesProvider notesProvider;

  EditNote(
      {this.note, this.isReminder = false, this.date = '', this.notesProvider})
      : super();

  @override
  State<StatefulWidget> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  Switch switchRem;

  TextEditingController textController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {



    textController.text = widget.note ?? '';
    dateController.text = widget.date ?? '';

    switchRem = Switch(
        value: widget.isReminder,
        onChanged: (value) {
          setState(() {
            widget.note = textController.text;
            widget.isReminder = value;
            widget.date = dateController.text;
          });
        });

    Future<void> _selectDate(BuildContext context) async {
      DateTime dt = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2023),
          lastDate: DateTime(2200));
      if (dt != null) {
        dateController.text = DateFormat.yMMMd().format(dt);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Ingrese nota"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: textController,
                decoration: InputDecoration(hintText: "Ingrese nota"),
              ),
              Row(
                children: [Text("Es recordatorio"), switchRem],
              ),
              Visibility(
                visible: widget.isReminder,
                child: TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.calendar_today), labelText: "Date"),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    final note = textController.text;
                    final date = dateController.text;
                    if ((widget.isReminder && date.isEmpty) || (!widget.isReminder && note.isEmpty)) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Seleccione fecha del recordatorio')));
                    } else {
                      if (widget.isReminder)
                        widget.notesProvider.addReminder(note);
                      else
                        widget.notesProvider.addNote(note);
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Guardar"))
            ],
          ),
        ),
      ),
    );
  }
}
