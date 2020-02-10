import 'package:airnote/components/audio-recorder.dart';
import 'package:airnote/components/option-button.dart';
import 'package:airnote/components/title-input-field.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/services/snackbar.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/utils/input-validator.dart';
import 'package:airnote/view-models/base.dart';
import 'package:airnote/view-models/entry.dart';
import 'package:airnote/views/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateEntry extends StatefulWidget {
  static const routeName = "create-entry";
  @override
  _CreateEntryState createState() => _CreateEntryState();
}

class _CreateEntryState extends State<CreateEntry> {
  Map<String, String> _formData = {};
  final _addEntryFormKey = GlobalKey<FormState>();
  final _snackBarService = locator<SnackBarService>();

  @override
  Widget build(BuildContext context) {
    final _entryViewModel = Provider.of<EntryViewModel>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Stack(
            children: <Widget>[
              ListView(
                children: <Widget>[
                  Theme(
                    data: ThemeData(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      inputDecorationTheme:
                          InputDecorationTheme(border: InputBorder.none),
                    ),
                    child: Form(
                      key: _addEntryFormKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 45),
                          TitleInputField(
                            hint: "What\'s up?",
                            validator: InputValidator.title,
                            onSaved: _onTitleSaved,
                          ),
                          SizedBox(height: 100),
                          AudioRecorder(
                            onComplete: (recording) {
                              _formData["recording"] = recording.path;
                            },
                          ),
                          // TextFormField(
                          //   keyboardType: TextInputType.multiline,
                          //   maxLines: null,
                          //   cursorColor: Color(0xFF3C4858),
                          //   decoration: InputDecoration.collapsed(
                          //       hintText:
                          //           'Tell me about it, I don\'t snitch 🤐..'),
                          //   validator: InputValidator.content,
                          //   onSaved: (value) => _formData['content'] = value,
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              AirnoteOptionButton(
                icon: Icon(Icons.arrow_downward),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AirnoteColors.primary,
        child: _entryViewModel.getStatus() == ViewStatus.LOADING
            ? SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AirnoteColors.white),
                ),
              )
            : Icon(
                Icons.check,
              ),
        onPressed: () {
          if (_entryViewModel.getStatus() == ViewStatus.LOADING) return;
          final form = _addEntryFormKey.currentState;
          if (form.validate()) {
            form.save();
            _handleAddEntry();
          }
        },
      ),
    );
  }

  _handleAddEntry() async {
    final entryViewModel = Provider.of<EntryViewModel>(context);
    final form = _addEntryFormKey.currentState;
    if (!(form.validate())) return;
    if (_formData["recording"] == null) {
      _snackBarService.showSnackBar(icon: Icon(Icons.mic_none), text: "Please finish recording.");
      return;
    };
    form.save();
    final response = await entryViewModel.createEntry(_formData);
    if (response) {
      Navigator.of(context).pushNamed(Home.routeName);
    }
  }

  _onTitleSaved(String value) {
    _formData['title'] = value;
  }
}
