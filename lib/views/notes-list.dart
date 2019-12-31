import 'package:airnote/models/note.dart';
import 'package:airnote/view-models/note.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotesList extends StatefulWidget {
  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  List<Note> _notes;
  NoteViewModel noteViewModel;

  _getNotes() async {
    final noteModelView = Provider.of<NoteViewModel>(context);
    final notes = await noteModelView.getNotes();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final _noteModelView = Provider.of<NoteViewModel>(context);
    if (this.noteViewModel == _noteModelView) {
      return;
    }
    this.noteViewModel = _noteModelView;
    Future.microtask(this.noteViewModel.getNotes);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Container(child: Consumer<NoteViewModel>(
          builder: (context, model, child) {
            List<Note> notes = model.notes;
            if (notes.length < 1) return Text("No note");
            return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text(notes[index].title);
                });
          },
        )),
      ),
    );
  }
}
