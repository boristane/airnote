import 'dart:async';
import 'dart:io' as io;

import 'package:airnote/components/player-button.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/services/snackbar.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/utils/messages.dart';
import 'package:airnote/utils/recorder-state.dart';
import 'package:airnote/view-models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart' as pt;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class AudioRecorder extends StatefulWidget {
  final void Function(Recording) onComplete;
  final void Function(RecorderState) onStatusChanged;
  final void Function() onLapComplete;
  final void Function() onStart;
  final List<int> durations;
  AudioRecorder(
      {Key key,
      this.onComplete,
      this.onStatusChanged,
      this.durations,
      this.onLapComplete,
      this.onStart})
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
  Stopwatch _stopwatch = new Stopwatch();
  bool _isInitialised = false;
  int _currentLap = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initRecording();
    });
  }

  Future<void> _initRecording() async {
    try {
      PermissionStatus hasPermission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.microphone);
      if (hasPermission != PermissionStatus.granted) {
        await _askForPermission();
      }
      hasPermission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.microphone);
      setState(() {
        _hasPermission =
            hasPermission == PermissionStatus.granted ? true : false;
      });
      if (!_hasPermission) {
        return;
      }
      final _userViewModel = Provider.of<UserViewModel>(context);
      String path =
          "entry_${_userViewModel.user.uuid}_${DateTime.now().millisecondsSinceEpoch.toString()}.aac";
      io.Directory dir = await getTemporaryDirectory();
      path = pt.join(dir.path, path);
      _recorder = FlutterAudioRecorder(path, audioFormat: AudioFormat.AAC);
      await _recorder.initialized;
      _stopwatch.reset();
      Recording current = await _recorder.current(channel: 0);
      setState(() {
        _currentRecording = current;
        _currentRecorderStatus = current.status;
        _isInitialised = true;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color =
        _hasPermission ? AirnoteColors.primary : AirnoteColors.inactive;
    final totalDuration = widget.durations.reduce((a, b) => a + b).toDouble();
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SleekCircularSlider(
                  innerWidget: (_) => Container(),
                  initialValue: _stopwatch.elapsedMilliseconds
                      .clamp(0, totalDuration)
                      .toDouble(),
                  min: 0,
                  max: totalDuration,
                  appearance: CircularSliderAppearance(
                      customWidths: CustomSliderWidths(
                          trackWidth: 1, progressBarWidth: 2, handlerSize: 3),
                      customColors: CustomSliderColors(
                          trackColor: AirnoteColors.lightBlue,
                          progressBarColor: AirnoteColors.primary,
                          dotColor: AirnoteColors.primary,
                          hideShadow: true),
                      startAngle: 65,
                      angleRange: 320,
                      size: 200.0,
                      animationEnabled: false),
                  onChange: (double value) {
                    if (value >= totalDuration) {
                      _stop();
                      return;
                    }
                    var totalTimeToEndOfLap = 0;
                    for (var i = 0; i <= _currentLap; i += 1) {
                      totalTimeToEndOfLap += widget.durations[i];
                    }
                    if (value >= totalTimeToEndOfLap) {
                      if (_currentLap >= widget.durations.length - 1) return;
                      widget.onLapComplete();
                      _currentLap += 1;
                    }
                  }),
              AirnotePlayerButton(
                icon: _buildIcon(),
                isLarge: true,
                onTap: _handleMainButtonTap,
              ),
              Positioned(
                bottom: 15,
                right: 15,
                child: AirnotePlayerButton(
                  icon: Icon(Icons.stop, color: color),
                  onTap: _stop,
                ),
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
    _timer?.cancel();
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

      _stopwatch.start();
      widget.onStart();
    } catch (e) {
      print(e);
    }
  }

  void _resume() async {
    await _recorder.resume();
    _stopwatch.start();
    setState(() {});
  }

  void _pause() async {
    await _recorder.pause();
    _stopwatch.stop();
    setState(() {});
  }

  void _stop() async {
    if (!_hasPermission) {
      _askForPermission();
      return;
    }
    if (!_isInitialised) {
      return;
    }
    Recording result = await _recorder?.stop();
    _changeStatus(result);
    _stopwatch.stop();
    setState(() {
      _currentLap = 0;
    });
    widget.onComplete(result);
  }

  _handleMainButtonTap() {
    if (!_hasPermission) {
      _askForPermission();
      return;
    }
    switch (_currentRecorderStatus) {
      case RecordingStatus.Initialized:
          _start();
          break;
      case RecordingStatus.Recording:
          _pause();
          break;
      case RecordingStatus.Paused:
          _resume();
          break;
      case RecordingStatus.Stopped:
          _initRecording();
          break;
      default:
        break;
    }
  }

  Icon _buildIcon() {
    IconData icon;
    Color color =
        _hasPermission ? AirnoteColors.primary : AirnoteColors.inactive;
    switch (_currentRecorderStatus) {
      case RecordingStatus.Initialized:
        icon = Icons.mic;
        break;
      case RecordingStatus.Recording:
          icon = Icons.pause;
          break;
      case RecordingStatus.Paused:
          icon = Icons.mic;
          break;
      case RecordingStatus.Stopped:
          icon = Icons.mic_off;
          break;
      default:
          icon = Icons.mic_off;
          break;
        break;
    }
    return Icon(
      icon,
      color: color,
      size: 55,
    );
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

  _askForPermission() async {
    _snackBarService.showSnackBar(
        text: AirnoteMessage.microphoneRequest, icon: Icon(Icons.mic_off));
    await PermissionHandler().requestPermissions([PermissionGroup.microphone]);
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
           fontSize: 60, color: AirnoteColors.grey),
    );
  }
}
