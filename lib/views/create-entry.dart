import 'package:airnote/components/audio-recorder.dart';
import 'package:airnote/components/option-button.dart';
import 'package:airnote/components/title-input-field.dart';
import 'package:airnote/services/dialog.dart';
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
  final _dialogService = locator<DialogService>();
  bool _isRecorded = false;
  bool _isRecording = false;

  @override
  Widget build(BuildContext context) {
    final _entryViewModel = Provider.of<EntryViewModel>(context);
    return Scaffold(
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: SafeArea(
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
                                setState(() {
                                  _isRecorded = true;
                                });
                              },
                              onStatusChanged: (status) {
                                setState(() {
                                  _isRecording = status;
                                });
                              }
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                AirnoteOptionButton(
                  icon: Icon(Icons.arrow_downward),
                  onTap: () {
                    _onWillPop().then((value) {
                      if(value) {

                      Navigator.of(context).pop();
                      }
                    });
                  },
                ),
              ],
            ),
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
    if (!_isRecorded) {
      _snackBarService.showSnackBar(
          icon: Icon(Icons.mic_none), text: "Please finish recording.");
      return;
    }
    form.save();
    final response = await entryViewModel.createEntry(_formData);
    if (response) {
      Navigator.of(context).pushNamed(Home.routeName);
    }
  }

  _onTitleSaved(String value) {
    _formData['title'] = value;
  }

  Future<bool> _onWillPop() async {
    bool result = true;
    if (_isRecorded || _isRecording) {
      await _dialogService.showQuestionDialog(
        title: "Are you sure?",
        content: "You will lose your recording.",
        onYes: () => result = true,
        onNo: () => result = false);
      return result;
    }
    return result;
  }
}
