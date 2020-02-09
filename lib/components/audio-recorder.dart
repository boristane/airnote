import 'dart:async';
import 'dart:io' as io;

import 'package:airnote/components/option-button.dart';
import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart' as pt;

class AudioRecorder extends StatefulWidget {
  final void Function(Recording) onComplete;
  AudioRecorder({Key key, this.onComplete}) : super(key: key);
  @override
  _AudioRecorderState createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  FlutterAudioRecorder _recorder;
  Recording _currentRecording;
  RecordingStatus _currentRecorderStatus = RecordingStatus.Unset;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _activateRecording();
    });
  }

  Future<void> _activateRecording() async {
    try {
      String path =
          "entry_${DateTime.now().millisecondsSinceEpoch.toString()}.wav";
      io.Directory dir = await getApplicationDocumentsDirectory();
      await dir.create(recursive: true);
      path = pt.join(dir.path, path);
      _recorder = FlutterAudioRecorder(path, audioFormat: AudioFormat.WAV);
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
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AirnoteOptionButton(
                icon: Icon(Icons.cancel),
                onTap: cancel,
              ),
              AirnoteOptionButton(
                icon: _buildIcon(_currentRecorderStatus),
                isLarge: true,
                onTap: _handleMainButtonTap,
              ),
              AirnoteOptionButton(
                icon: Icon(Icons.stop),
                onTap: _stop,
              ),
            ],
          ),
          SizedBox(height: 45),
          _RecordingTime(recording: _currentRecording,),
        ],
      ),
    );
  }

  void _start() async {
    try {
      await _recorder.start();
      Recording recording = await _recorder.current(channel: 0);
      setState(() {
        _currentRecording = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentRecorderStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        Recording current = await _recorder.current(channel: 0);
        _changeStatus(current);
      });
      new Timer.periodic(Duration(milliseconds: 5000), (Timer t) async {
        print(_currentRecording.metering.averagePower);
      });
    } catch (e) {
      print(e);
    }
  }

  void cancel() async {}

  void _resume() async {
    await _recorder.resume();
    setState(() {});
  }

  void _pause() async {
    await _recorder.pause();
    setState(() {});
  }

  void _stop() async {
    Recording result = await _recorder.stop();
    _changeStatus(result);
    widget.onComplete(result);
  }

  _handleMainButtonTap() {
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
          _activateRecording();
          break;
        }
      default:
        break;
    }
  }

  Icon _buildIcon(RecordingStatus status) {
    Icon icon;
    switch (_currentRecorderStatus) {
      case RecordingStatus.Initialized:
        {
          icon = Icon(Icons.mic);
          break;
        }
      case RecordingStatus.Recording:
        {
          icon = Icon(Icons.pause);
          break;
        }
      case RecordingStatus.Paused:
        {
          icon = Icon(Icons.mic);
          break;
        }
      case RecordingStatus.Stopped:
        {
          icon = Icon(Icons.mic_off);
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
    return Text(_getTimeString(),
    style: TextStyle(fontFamily: "Raleway", fontSize: 60, color: AirnoteColors.grey),);
  }
}
