import 'package:airnote/components/loading.dart';
import 'package:airnote/components/entry-list-item.dart';
import 'package:airnote/models/entry.dart';
import 'package:airnote/view-models/base.dart';
import 'package:airnote/view-models/entry.dart';
import 'package:airnote/views/entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EntriesList extends StatefulWidget {
  @override
  State<EntriesList> createState() => _EntriesListState();
}

class _EntriesListState extends State<EntriesList> {
  EntryViewModel _entryViewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final _noteModelView = Provider.of<EntryViewModel>(context);
    if (this._entryViewModel == _noteModelView) {
      return;
    }
    this._entryViewModel = _noteModelView;
    Future.microtask(this._entryViewModel.getEntries);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Container(child: Consumer<EntryViewModel>(
          builder: (context, model, child) {
            List<Entry> entries = model.entries;
            if (model.getStatus() == ViewStatus.LOADING) {
              return AirnoteLoadingScreen();
            }
            if (entries == null) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                alignment: Alignment.center,
                child: Text("Ooops ! There was a problem getting the data..."),
              );
            }
            if (entries.length < 1) return NoEntryFound();
            return ListView.builder(
                itemCount: entries.length,
                itemBuilder: (BuildContext context, int index) {
                  final entry = entries[index];
                  return GestureDetector(
                      onTap: () => Navigator.of(context)
                          .pushNamed(EntryView.routeName, arguments: entry.id),
                      child: AirnoteEntryListItem(
                        entry: entry,
                      ));
                });
          },
        )),
      ),
    );
  }
}

class NoEntryFound extends StatelessWidget {
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
