import 'package:flutter/material.dart';
import 'package:note_app/Note.dart';
import 'package:note_app/edit_note.dart';
import 'package:note_app/notes_provider.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // List<Note> notes = [Note("n1", false), Note("n2", false)];
  // List<Note> rem = [Note("r9", true), Note("r8", true)];
  int selectedIndex = 0;

  Future<void> createNote(provider) async {
    Map note = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (mContext) => EditNote(notesProvider: provider)));
    print("Note?");
    print(note);
    if (note != null) {
      setState(() {
        Note newNote = Note(note["value"], note["is_reminder"]);
        newNote.setDate(note["date"]);
        // if (newNote.isReminder)
        //   rem.add(newNote);
        // else
        //   notes.add(newNote);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Consumer<NotesProvider>(
        builder: (itemContext, notesProvider, child) {
          return IndexedStack(
            index: selectedIndex,
            children: [
              buildListView(notesProvider.notes),
              buildListView(notesProvider.rem),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createNote(context.read<NotesProvider>()),
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

  ListView buildListView(List<Note> data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(data[index].text),
                  Text(data[index].date),
                ],
              ),
            ),
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (mContext) => EditNote(
                            index: index,
                            isReminder: data[index].isReminder,
                            notesProvider: context.read<NotesProvider>(),
                          )));
            },
          );
        });
  }
}
