import 'dart:async';
import 'dart:io' as io;

import 'package:airnote/components/circular-button.dart';
import 'package:airnote/utils/colors.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class CreateEntry extends StatefulWidget {
  static const routeName = "create-entry";
  @override
  _CreateEntryState createState() => _CreateEntryState();
}

class _CreateEntryState extends State<CreateEntry> {
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _activateRecording();
    });
  }

  Future<void> _activateRecording() async {
    try {
      String path = "entry_${DateTime.now().millisecondsSinceEpoch.toString()}.wav";
      io.Directory dir = await getApplicationDocumentsDirectory();
      await dir.create(recursive: true);
      path = join(dir.path, path);
      _recorder = FlutterAudioRecorder(path, audioFormat: AudioFormat.WAV);
      await _recorder.initialized;
      var current = await _recorder.current(channel: 0);
      setState(() {
        _current = current;
        _currentStatus = current.status;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: ListView(
        children: <Widget>[
          Container(child: Text("Title")),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            color: AirnoteColors.backgroundColor,
            child: Text(
              _current.duration.toString(),
              style: TextStyle(
                  fontSize: 16,
                  height: 1.2,
                  color: AirnoteColors.text.withOpacity(0.8)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AirnoteCircularButton(
                icon: Icon(Icons.cancel),
                onTap: cancel,
              ),
              AirnoteCircularButton(
                icon: _buildIcon(_currentStatus),
                isLarge: true,
                onTap: (){
                  switch (_currentStatus) {
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
                },
              ),
              AirnoteCircularButton(
                icon: Icon(Icons.stop),
                onTap: _stop,
              ),
            ],
          ),
        ],
      ),
    ));
  }

  void _start() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        print(current.duration);
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void cancel() async {}

  _resume() async {
    await _recorder.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder.pause();
    setState(() {});
  }

  void _stop() async {
    Recording result = await _recorder.stop();
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    var localFileSystem = LocalFileSystem();
    File file = localFileSystem.file(result.path);
    print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current.status;
    });
  }

  Icon _buildIcon(RecordingStatus status) {
    Icon icon;
    switch (_currentStatus) {
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
}
