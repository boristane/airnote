import 'dart:async';
import 'dart:io' as io;

import 'package:airnote/components/option-button.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/services/snackbar.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/utils/recorder-state.dart';
import 'package:airnote/view-models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart' as pt;
import 'package:provider/provider.dart';

class AudioRecorder extends StatefulWidget {
  final void Function(Recording) onComplete;
  final void Function(RecorderState) onStatusChanged;
  AudioRecorder({Key key, this.onComplete, this.onStatusChanged})
      : super(key: key);
  @override
  _AudioRecorderState createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  FlutterAudioRecorder _recorder;
  Recording _currentRecording;
  RecordingStatus _currentRecorderStatus = RecordingStatus.Unset;
  bool _hasPermission = false;
  final _snackBarService = locator<SnackBarService>();
  Timer _timer;
  Timer _silenceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initRecording();
    });
  }

  Future<void> _initRecording() async {
    try {
      bool hasPermission = await FlutterAudioRecorder.hasPermissions;
      setState(() {
        _hasPermission = true;
      });
      if (!_hasPermission) {
        _askForPermission();
        return;
      }
      final _userViewModel = Provider.of<UserViewModel>(context);
      String path =
          "${_userViewModel.user.uuid}_entry_${DateTime.now().millisecondsSinceEpoch.toString()}.aac";
      io.Directory dir = await getTemporaryDirectory();
      path = pt.join(dir.path, path);
      _recorder = FlutterAudioRecorder(path, audioFormat: AudioFormat.AAC);
      await _recorder.initialized;
      Recording current = await _recorder.current(channel: 0);
      setState(() {
        _currentRecording = current;
        _currentRecorderStatus = current.status;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color =
        _hasPermission ? AirnoteColors.primary : AirnoteColors.inactive;
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AirnoteOptionButton(
                icon: _buildIcon(),
                isLarge: true,
                onTap: _handleMainButtonTap,
              ),
              AirnoteOptionButton(
                icon: Icon(Icons.stop, color: color),
                onTap: _stop,
              ),
            ],
          ),
          SizedBox(height: 45),
          _RecordingTime(
            recording: _currentRecording,
          ),
        ],
      ),
    );
  }

  @override
  void deactivate() async {
    _timer.cancel();
    _silenceTimer.cancel();
    super.deactivate();
  }

  void _start() async {
    try {
      await _recorder.start();
      Recording recording = await _recorder.current(channel: 0);
      setState(() {
        _currentRecording = recording;
      });

      const tick = const Duration(milliseconds: 50);
      _timer = new Timer.periodic(tick, (Timer t) async {
        if (_currentRecorderStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        Recording current = await _recorder.current(channel: 0);
        _changeStatus(current);
      });
      _silenceTimer =
          new Timer.periodic(Duration(milliseconds: 5000), (Timer t) async {
        print(_currentRecording.metering.averagePower);
      });
    } catch (e) {
      print(e);
    }
  }

  void _resume() async {
    await _recorder.resume();
    setState(() {});
  }

  void _pause() async {
    await _recorder.pause();
    setState(() {});
  }

  void _stop() async {
    if (!_hasPermission) {
      _askForPermission();
      return;
    }
    Recording result = await _recorder.stop();
    _changeStatus(result);
    widget.onComplete(result);
  }

  _handleMainButtonTap() {
    if (!_hasPermission) {
      _askForPermission();
      return;
    }
    switch (_currentRecorderStatus) {
      case RecordingStatus.Initialized:
        {
          _start();
          break;
        }
      case RecordingStatus.Recording:
        {
          _pause();
          break;
        }
      case RecordingStatus.Paused:
        {
          _resume();
          break;
        }
      case RecordingStatus.Stopped:
        {
          _initRecording();
          break;
        }
      default:
        break;
    }
  }

  Icon _buildIcon() {
    Icon icon;
    Color color =
        _hasPermission ? AirnoteColors.primary : AirnoteColors.inactive;
    switch (_currentRecorderStatus) {
      case RecordingStatus.Initialized:
        {
          icon = Icon(
            Icons.mic,
            color: color,
          );
          break;
        }
      case RecordingStatus.Recording:
        {
          icon = Icon(
            Icons.pause,
            color: color,
          );
          break;
        }
      case RecordingStatus.Paused:
        {
          icon = Icon(
            Icons.mic,
            color: color,
          );
          break;
        }
      case RecordingStatus.Stopped:
        {
          icon = Icon(
            Icons.mic_off,
            color: color,
          );
          break;
        }
      default:
        break;
    }
    return icon;
  }

  _changeStatus(Recording current) {
    setState(() {
      _currentRecording = current;
      _currentRecorderStatus = _currentRecording.status;
    });
    if (_currentRecorderStatus == RecordingStatus.Paused) {
      widget.onStatusChanged(RecorderState.paused);
    } else if (_currentRecorderStatus == RecordingStatus.Recording) {
      widget.onStatusChanged(RecorderState.recording);
    } else if (_currentRecorderStatus == RecordingStatus.Stopped) {
      widget.onStatusChanged(RecorderState.stopped);
    } else {
      widget.onStatusChanged(RecorderState.none);
    }
  }

  _askForPermission() {
    _snackBarService.showSnackBar(
        text: "Please allow me to use your microphone",
        icon: Icon(Icons.mic_off));
  }
}

class _RecordingTime extends StatelessWidget {
  final Recording recording;
  _RecordingTime({Key key, this.recording}) : super(key: key);
  _getTimeString() {
    final string = recording == null
        ? "00:00"
        : recording.duration.toString().substring(2, 7);
    return string;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _getTimeString(),
      style: TextStyle(
          fontFamily: "Raleway", fontSize: 60, color: AirnoteColors.grey),
    );
  }
}
