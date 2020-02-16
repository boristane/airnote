import 'dart:async';

import 'package:airnote/components/player-button.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/utils/stopwatch.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class AirnoteAudioPlayer extends StatefulWidget {
  final String audioFilePath;

  AirnoteAudioPlayer({
    Key key,
    this.audioFilePath,
  }) : super(key: key);
  @override
  State<AirnoteAudioPlayer> createState() => _AirnoteAudioPlayerState();
}

class _AirnoteAudioPlayerState extends State<AirnoteAudioPlayer> {
  double _totalDuration = 5000;
  AudioPlayer _audioPlayer = AudioPlayer();
  AirnoteStopwatch _stopwatch = new AirnoteStopwatch();
  Timer _timer;

  void _play() async {
    int result = await _audioPlayer.resume();
    if (result == 1) {
      _stopwatch.start();
      const tick = const Duration(milliseconds: 50);
      _timer = new Timer.periodic(tick, (Timer t) async {
        setState(() {});
      });
    }
  }

  void _pause() async {
    int result = await _audioPlayer.pause();
    if (result == 1) {
      _stopwatch.stop();
    }
  }

  void seek(double value) async {
    await _audioPlayer.seek(Duration(milliseconds: value.toInt()));
  }

  Icon _getMainButtonIcon() {
    if (_stopwatch.isRunning) {
      return Icon(
        Icons.pause,
        color: AirnoteColors.primary,
      );
    }
    return Icon(
      Icons.play_arrow,
      color: AirnoteColors.primary,
    );
  }

  void _onMainButtonTapped() {
    _stopwatch.isRunning ? _pause() : _play();
  }

  void _onStopButtonTapped() {
    _audioPlayer.stop();
    _stopwatch.stop();
    _stopwatch.reset();
    _timer?.cancel();
  }

  String _getElapsedTime() {
    Duration duration =
        Duration(milliseconds: _stopwatch.elapsedMilliseconds.toInt());
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
  }

  // String _getRemainingTime() {
  //   Duration duration = Duration(
  //       milliseconds:
  //           (_totalDuration - _stopwatch.elapsedMilliseconds).toInt());
  //   int minutes = duration.inMinutes.remainder(60);
  //   int seconds = duration.inSeconds.remainder(60);
  //   return "${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
  // }

  void _initialisePlayer() async {
    await _audioPlayer.setUrl(widget.audioFilePath, isLocal: true);
    _audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      if (s == AudioPlayerState.COMPLETED) {
        _audioPlayer.stop();
        _stopwatch.stop();
        _stopwatch.reset();
        _timer?.cancel();
      }
    });
    _audioPlayer.onDurationChanged.listen((Duration d) async {
      int totalDuration = await _audioPlayer?.getDuration();
      setState(() {
        _totalDuration = totalDuration.toDouble();
      });
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialisePlayer();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialisePlayer();
    });
    print(widget.audioFilePath);
    super.didChangeDependencies();
  }

  @override
  void deactivate() async {
    _timer?.cancel();
    await _audioPlayer.stop();
    await _audioPlayer.release();
    await _audioPlayer.dispose();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SleekCircularSlider(
                  innerWidget: (_) => Container(),
                  initialValue:
                      _stopwatch.elapsedMilliseconds.clamp(0, _totalDuration) *
                          1.0,
                  min: 0,
                  max: _totalDuration,
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
                  onChangeEnd: (double value) {
                    seek(value);
                    _stopwatch.reset(
                        initialOffset: Duration(milliseconds: value.toInt()));
                  }),
              AirnotePlayerButton(
                icon: _getMainButtonIcon(),
                isLarge: true,
                onTap: _onMainButtonTapped,
              ),
              Positioned(
                bottom: 15,
                right: 15,
                child: AirnotePlayerButton(
                  icon: Icon(Icons.stop, color: AirnoteColors.primary),
                  onTap: _onStopButtonTapped,
                ),
              ),
              Positioned(
                top: 40,
                child: Text(
                  _getElapsedTime(),
                  style: TextStyle(color: AirnoteColors.text.withOpacity(0.7)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    // return Container(
    //   child: Stack(
    //     alignment: Alignment.center,
    //     children: <Widget>[
    //       Positioned(
    //             bottom: 0,
    //             right: 0,
    //             child: AirnotePlayerButton(
    //               icon: Icon(Icons.stop, color: AirnoteColors.primary),
    //               onTap: () {print("Just stopped");},
    //             ),
    //           ),
    //       Container(
    //           child: AirnotePlayerButton(
    //         icon: _getMainButtonIcon(),
    //         onTap: _onMainButtonTapped,
    //         isLarge: true,
    //       )),
    // SleekCircularSlider(
    //     innerWidget: (_) => Container(),
    //     appearance: CircularSliderAppearance(
    //         customWidths: CustomSliderWidths(
    //             trackWidth: 1, progressBarWidth: 2, handlerSize: 3),
    //         customColors: CustomSliderColors(
    //             trackColor: AirnoteColors.lightBlue,
    //             progressBarColor: AirnoteColors.primary,
    //             dotColor: AirnoteColors.primary,
    //             hideShadow: true),
    //         startAngle: 180,
    //         angleRange: 270,
    //         size: 200.0,
    //         animationEnabled: false),
    //     onChange: (double value) {
    //       setState(() {
    //         _position = value;
    //       });
    //       seek();
    //     }),
    // Stack(
    //   children: <Widget>[
    //     Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: <Widget>[
    //           Text(
    //             _getElapsedTime(),
    //             style:
    //                 TextStyle(color: AirnoteColors.text.withOpacity(0.7)),
    //           ),
    //           Text(_getRemainingTime(),
    //               style: TextStyle(
    //                   color: AirnoteColors.text.withOpacity(0.7)))
    //         ],
    //       ),
    //     ),
    //   ],
    // ),
    //     ],
    //   ),
    // );
  }
}
