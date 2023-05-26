import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditNote extends StatefulWidget {
  String note;
  bool isReminder;
  String date;

  EditNote({this.note, this.isReminder = false, this.date = ''}) : super();

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
    textController.text = widget.date ?? '';

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
                    if (widget.isReminder && date.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Seleccione fecha del recordatorio')));
                    } else {
                      Navigator.pop(context, {
                        "value": note,
                        "is_reminder": widget.isReminder,
                        "date": date
                      });
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
