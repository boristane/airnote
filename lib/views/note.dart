import 'package:airnote/components/loading.dart';
import 'package:airnote/view-models/base.dart';
import 'package:airnote/view-models/note.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoteView extends StatefulWidget {
  static const routeName = 'view-entry';
  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  NoteViewModel _noteViewModel;

  @override
  void didChangeDependencies() async {
    final noteViewModel = Provider.of<NoteViewModel>(context);
    super.didChangeDependencies();
    if (this._noteViewModel == noteViewModel) {
      return;
    }
    this._noteViewModel = noteViewModel;
    final id = ModalRoute.of(context).settings.arguments;
    await this._noteViewModel.getCurrentNote(id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Consumer<NoteViewModel>(
          builder: (context, model, child) {
            if (model.getStatus() == ViewStatus.LOADING)
              return AirnoteLoadingScreen();
            final note = model.currentNote;
            return Text("${note.toJson()}");
          },
        ),
      ),
    );
  }
}
