import 'dart:async';

import 'package:airnote/components/audio-recorder.dart';
import 'package:airnote/components/loading.dart';
import 'package:airnote/components/option-button.dart';
import 'package:airnote/components/title-input-field.dart';
import 'package:airnote/services/dialog.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/services/snackbar.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/utils/input-validator.dart';
import 'package:airnote/utils/messages.dart';
import 'package:airnote/utils/recorder-state.dart';
import 'package:airnote/utils/stopwatch.dart';
import 'package:airnote/view-models/base.dart';
import 'package:airnote/view-models/entry.dart';
import 'package:airnote/view-models/routine.dart';
import 'package:airnote/view-models/user.dart';
import 'package:airnote/views/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordEntry extends StatefulWidget {
  static const routeName = "record-entry";
  final maxDuration = 5 * 60 * 1000;
  @override
  _RecordEntryState createState() => _RecordEntryState();
}

class _RecordEntryState extends State<RecordEntry> {
  Map<String, String> _formData = {};
  final _addEntryFormKey = GlobalKey<FormState>();
  final _snackBarService = locator<SnackBarService>();
  final _dialogService = locator<DialogService>();
  bool _hasRoutine = true;
  bool _isRecorded = false;
  bool _isRecording = false;
  bool _isShowingText = false;
  int _currentRoutineItemIndex = -1;
  List<Timer> _timers = [];
  AirnoteStopwatch _stopWatch = AirnoteStopwatch();

  @override
  deactivate() async {
    _timers.forEach((timer) => timer?.cancel());
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final entryViewModel = Provider.of<EntryViewModel>(context);
    final routineViewModel = Provider.of<RoutineViewModel>(context);
    if (_hasRoutine && routineViewModel.prompts == null) {
      setState(() {
        _hasRoutine = false;
      });
    }
    final prompt = _hasRoutine
        ? AnimatedOpacity(
            opacity: _isShowingText ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: Container(
              height: 50,
              child: _currentRoutineItemIndex == -1
                  ? Text("")
                  : Text(
                      routineViewModel.prompts[_currentRoutineItemIndex].text,
                      style: TextStyle(color: AirnoteColors.text, fontSize: 15),
                    ),
            ),
          )
        : Container(
            height: 50,
          );
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
                              hint: "What\'s on your mind?",
                              validator: InputValidator.title,
                              onSaved: _onTitleSaved,
                            ),
                            prompt,
                            SizedBox(height: 45),
                            AudioRecorder(
                              durations: _hasRoutine
                                  ? routineViewModel.prompts.map<int>((item) {
                                      return item.duration;
                                    }).toList()
                                  : [widget.maxDuration],
                              onComplete: (recording) {
                                _formData["recording"] = recording.path;
                                _formData["duration"] = recording
                                    .duration.inMilliseconds
                                    .toString();
                                setState(() {
                                  _isRecorded = true;
                                });
                                _currentRoutineItemIndex = -1;
                                _isShowingText = false;
                              },
                              onStatusChanged: (status) {
                                if (status == RecorderState.recording) {
                                  _stopWatch.start();
                                }
                                if (status == RecorderState.paused) {
                                  _stopWatch.stop();
                                }
                                if (status == RecorderState.stopped) {
                                  _stopWatch.reset();
                                }
                                setState(() {
                                  _isRecording =
                                      status == RecorderState.paused ||
                                              status == RecorderState.recording
                                          ? true
                                          : false;
                                });
                              },
                              onStart: () {
                                _displayNextRoutineItem();
                              },
                              onLapComplete: () {
                                if (_currentRoutineItemIndex >=
                                    routineViewModel.prompts.length - 1) return;
                                _displayNextRoutineItem();
                              },
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
                      if (value) {
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
        child: entryViewModel.getStatus() == ViewStatus.LOADING
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
          if (entryViewModel.getStatus() == ViewStatus.LOADING) return;
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
    final userViewModel = Provider.of<UserViewModel>(context);
    final form = _addEntryFormKey.currentState;
    if (!(form.validate())) return;
    if (!_isRecorded) {
      _snackBarService.showSnackBar(
          icon: Icon(Icons.mic_none), text: "Please finish recording.");
      return;
    }
    form.save();
    final email = userViewModel.user.email;
    final encryptionKey = userViewModel.user.encryptionKey;
    final response =
        await entryViewModel.createEntry(_formData, email, encryptionKey);
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
          title: AirnoteMessage.areYouSure,
          content: AirnoteMessage.recordingExitDelete,
          onYes: () => result = true,
          onNo: () => result = false);
      return result;
    }
    return result;
  }

  _displayNextRoutineItem() {
    _isShowingText = false;
    final timer = new Timer(Duration(milliseconds: 500), () {
      _isShowingText = true;
      _currentRoutineItemIndex += 1;
    });
    _timers.add(timer);
  }
}
