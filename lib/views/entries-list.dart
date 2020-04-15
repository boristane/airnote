import 'package:airnote/components/header.dart';
import 'package:airnote/components/loading.dart';
import 'package:airnote/components/entry-list-item.dart';
import 'package:airnote/models/entry.dart';
import 'package:airnote/services/local-auth.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/view-models/base.dart';
import 'package:airnote/view-models/entry.dart';
import 'package:airnote/views/view-entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EntriesList extends StatefulWidget {
  @override
  State<EntriesList> createState() => _EntriesListState();
}

class _EntriesListState extends State<EntriesList> {
  EntryViewModel _entryViewModel;
  final LocalAuthService _localAuth = locator<LocalAuthService>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final _entryModelView = Provider.of<EntryViewModel>(context);
    if (this._entryViewModel == _entryModelView) {
      return;
    }
    this._entryViewModel = _entryModelView;
    Future.microtask(this._entryViewModel.getEntries);
  }

  _openEntry(Entry entry) async {
    if (entry.isLocked) {
      await _localAuth.authenticate();
      if (!_localAuth.isAuthenticated) {
        return;
      }
    }
    Navigator.of(context).pushNamed(EntryView.routeName, arguments: entry.id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(child: Consumer<EntryViewModel>(
        builder: (context, model, child) {
          List<Entry> entries = model.entries;
          if (entries == null) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              alignment: Alignment.center,
              child: Text("Ooops ! There was a problem getting the data..."),
            );
          }
          if (entries.length < 1) return NoEntryFound();
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  child: AirnoteHeader(
                      text: "Your Space",
                      subText:
                          "Reflect on your story",
                    ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                      itemCount: entries.length,
                      itemBuilder: (BuildContext context, int index) {
                        final entry = entries[index];
                        return GestureDetector(
                            onTap: () async {
                              await _openEntry(entry);
                            },
                            child: AirnoteEntryListItem(
                              entry: entry,
                            ));
                      }),
                ),
              ],
            ),
          );
        },
      )),
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
          child: Text("Press the + button to start recording"),
        )
      ],
    );
  }
}
