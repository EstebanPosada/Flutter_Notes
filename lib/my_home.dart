import 'package:flutter/material.dart';
import 'package:note_app/Note.dart';
import 'package:note_app/edit_note.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> notes = ["n1", "n2"];
  List<String> rem = ["r9", "r8"];
  List<String> dates = ["d1", "d2"];

  // List<Note> rem = [Note("r1", true), Note("r2", true)];
  int selectedIndex = 0;

  Future<void> createNote() async {
    Map note = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditNote()));
    if (note != null) {
      setState(() {
        if (note["is_reminder"])
          rem.add(note["value"]);
        else
          notes.add(note["value"]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          buildListView(notes, false),
          buildListView(rem, true),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.notes), label: "Notas"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: "Recordatorios")
        ],
      ),
    );
  }

  ListView buildListView(List data, bool isReminder) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(data[index]),
                ],
              ),
            ),
            onTap: () async {
              final note = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditNote(
                            note: data[index],
                            isReminder: isReminder,
                          )));
              if (note != null) {
                setState(() {
                  print("Note st:$note");
                  if (isReminder) {
                    if (note["is_reminder"])
                      rem[index] = note["value"];
                    else {
                      rem.removeAt(index);
                      notes.add(note["value"]);
                    }
                  } else {
                    if (note["is_reminder"]) {
                      notes.removeAt(index);
                      rem.add(note["value"]);
                    } else
                      notes[index] = note["value"];
                  }
                });
              }
            },
          );
        });
  }
}
