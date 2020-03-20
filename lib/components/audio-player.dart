import 'dart:async';

import 'package:airnote/components/player-button.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/utils/stopwatch.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class AirnoteAudioPlayer extends StatefulWidget {
  final String audioFilePath;
  final String backgroundMusicPath;
  final int duration;

  AirnoteAudioPlayer({
    Key key,
    this.audioFilePath,
    this.duration,
    this.backgroundMusicPath,
  }) : super(key: key);
  @override
  State<AirnoteAudioPlayer> createState() => _AirnoteAudioPlayerState();
}

class _AirnoteAudioPlayerState extends State<AirnoteAudioPlayer> {
  AudioPlayer _audioPlayer = AudioPlayer();
  AudioPlayer _backgroundMusicaudioPlayer = AudioPlayer();
  AirnoteStopwatch _stopwatch = new AirnoteStopwatch();
  Timer _timer;

  void _play() async {
    int result = await _audioPlayer.resume();
    if (result == 1) {
      _backgroundMusicaudioPlayer.resume();
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
      _backgroundMusicaudioPlayer.pause();
      _stopwatch.stop();
    }
  }

  void seek(double value) async {
    await _audioPlayer.seek(Duration(milliseconds: value.toInt()));
    await _backgroundMusicaudioPlayer
        .seek(Duration(milliseconds: value.toInt()));
  }

  Icon _getMainButtonIcon() {
    IconData icon;
    if (_stopwatch.isRunning)
      icon = Icons.pause;
    else
      icon = Icons.play_arrow;

    return Icon(
      icon,
      color: AirnoteColors.primary,
      size: 55,
    );
  }

  void _onMainButtonTapped() {
    _stopwatch.isRunning ? _pause() : _play();
  }

  void _onStopButtonTapped() {
    _audioPlayer.stop();
    _backgroundMusicaudioPlayer.stop();
    _stopwatch.stop();
    _stopwatch.reset();
    _timer?.cancel();
    setState(() {});
  }

  String _getElapsedTime() {
    Duration duration =
        Duration(milliseconds: _stopwatch.elapsedMilliseconds.toInt());
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
  }

  void _initialisePlayer() async {
    await _audioPlayer.setUrl(widget.audioFilePath, isLocal: true);
    await _backgroundMusicaudioPlayer.setUrl(widget.backgroundMusicPath);
    await _backgroundMusicaudioPlayer.setVolume(0.5);
    _audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      if (s == AudioPlayerState.COMPLETED) {
        _audioPlayer.stop();
        _backgroundMusicaudioPlayer.stop();
        _stopwatch.stop();
        _stopwatch.reset();
        _timer?.cancel();
        setState(() {});
      }
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
    super.didChangeDependencies();
  }

  @override
  void deactivate() async {
    _timer?.cancel();
    await _audioPlayer.stop();
    await _audioPlayer.release();
    await _audioPlayer.dispose();
    await _backgroundMusicaudioPlayer.stop();
    await _backgroundMusicaudioPlayer.release();
    await _backgroundMusicaudioPlayer.dispose();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.duration == 0)
      return Text(
          "There was a problem loading the recording.",
        );
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SleekCircularSlider(
                  innerWidget: (_) => Container(),
                  initialValue: _stopwatch.elapsedMilliseconds
                      .clamp(0, widget.duration)
                      .toDouble(),
                  min: 0,
                  max: widget.duration.toDouble(),
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
  }
}
