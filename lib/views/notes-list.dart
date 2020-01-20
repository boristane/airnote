import 'package:airnote/components/loading.dart';
import 'package:airnote/components/note-list-item.dart';
import 'package:airnote/models/note.dart';
import 'package:airnote/view-models/base.dart';
import 'package:airnote/view-models/note.dart';
import 'package:airnote/views/note.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotesList extends StatefulWidget {
  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  NoteViewModel _noteViewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final _noteModelView = Provider.of<NoteViewModel>(context);
    if (this._noteViewModel == _noteModelView) {
      return;
    }
    this._noteViewModel = _noteModelView;
    Future.microtask(this._noteViewModel.getNotes);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Container(child: Consumer<NoteViewModel>(
          builder: (context, model, child) {
            List<Note> notes = model.notes;
            if (model.getStatus() == ViewStatus.LOADING) {
              return AirnoteLoadingScreen();
            }
            if (notes == null) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                alignment: Alignment.center,
                child: Text("Ooops ! There was a problem getting the data..."),
              );
            }
            if (notes.length < 1) return NoNoteFound();
            return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (BuildContext context, int index) {
                  final note = notes[index];
                  return GestureDetector(
                      onTap: () => Navigator.of(context)
                          .pushNamed(NoteView.routeName, arguments: note.id),
                      child: AirnoteNoteListItem(
                        note: note,
                      ));
                });
          },
        )),
      ),
    );
  }
}

class NoNoteFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 15.0),
          alignment: Alignment.center,
          child: Text(
            "Nothing yet to see...",
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Text("Add the + button to start recording"),
        )
      ],
    );
  }
}
