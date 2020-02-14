import 'dart:async';

import 'package:airnote/components/audio-recorder.dart';
import 'package:airnote/components/option-button.dart';
import 'package:airnote/components/title-input-field.dart';
import 'package:airnote/services/dialog.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/services/snackbar.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/utils/input-validator.dart';
import 'package:airnote/utils/recorder-state.dart';
import 'package:airnote/view-models/base.dart';
import 'package:airnote/view-models/entry.dart';
import 'package:airnote/view-models/routine.dart';
import 'package:airnote/view-models/user.dart';
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
  RoutineViewModel _routineViewModel;
  final _addEntryFormKey = GlobalKey<FormState>();
  final _snackBarService = locator<SnackBarService>();
  final _dialogService = locator<DialogService>();
  bool _isRecorded = false;
  bool _isRecording = false;
  bool _isShowingText = false;
  bool _timerStarted = false;
  String _text = "";
  List<Timer> _timers = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final _routineViewModel = Provider.of<RoutineViewModel>(context);
    if (this._routineViewModel == _routineViewModel) {
      return;
    }
    this._routineViewModel = _routineViewModel;
    Future.microtask(this._routineViewModel.getRoutine);
  }

  @override
  deactivate() async {
    _timers.forEach((timer) => timer?.cancel());
    super.deactivate();
  }

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
                            AnimatedOpacity(
                              opacity: _isShowingText ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 500),
                              child: Container(
                                height: 50,
                                child: Text(_text, style: TextStyle(color: AirnoteColors.secondary),),
                              ),
                            ),
                            AudioRecorder(onComplete: (recording) {
                              _formData["recording"] = recording.path;
                              _formData["duration"] =
                                  recording.duration.inMilliseconds.toString();
                              setState(() {
                                _isRecorded = true;
                              });
                            }, onStatusChanged: (status) {
                              if (status == RecorderState.recording &&
                                  _timerStarted == false) {
                                setState(() {
                                  _timerStarted = true;
                                });
                                _displayRoutine();
                              }
                              setState(() {
                                _isRecording = status == RecorderState.paused ||
                                        status == RecorderState.recording
                                    ? true
                                    : false;
                              });
                            }),
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
          title: "Are you sure?",
          content: "You will lose your recording.",
          onYes: () => result = true,
          onNo: () => result = false);
      return result;
    }
    return result;
  }

  //TODO this is a heap of garbage
  _displayRoutine() {
    final routine = this._routineViewModel.routine;
    int delay = routine[0].duration;
    setState(() {
      _text = routine[0].prompt;
    });
    final firstOpacityTimer = new Timer(Duration(milliseconds: 2000), () {
        setState(() {
          _isShowingText = true;
        });
      });
      _timers.add(firstOpacityTimer);
    for (var i = 1; i < routine.length; i++) {
      final timer = new Timer(Duration(milliseconds: delay), () {
        setState(() {
          _text = routine[i].prompt;
        });
      });
      final opacityTimerStart = new Timer(Duration(milliseconds: delay - 1000), () {
        setState(() {
          _isShowingText = false;
        });
      });
      final opacityTimerEnd = new Timer(Duration(milliseconds: delay + 1000), () {
        setState(() {
          _isShowingText = true;
        });
      });
      delay += routine[i].duration;
      _timers.add(timer);
      _timers.add(opacityTimerStart);
      _timers.add(opacityTimerEnd);
    }
  }
}
