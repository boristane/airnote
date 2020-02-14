import 'package:airnote/components/player-button.dart';
import 'package:airnote/utils/colors.dart';
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
  double _position = 0.0;
  bool _isPlaying = false;
  int _totalDuration = 0;
  AudioPlayer _audioPlayer = AudioPlayer();

  void _play() async {
    int result = await _audioPlayer.resume();
    if (result == 1) {
      print("Playing sound");
    } else {
      print("Not playing sound");
    }
  }

  void _pause() async {
    int result = await _audioPlayer.pause();
    if (result == 1) {
      print("Paused sound");
    } else {
      print("Not paused sound");
    }
  }

  void seek() async {
    int result = await _audioPlayer
        .seek(Duration(milliseconds: (_totalDuration * _position).toInt()));
    if (result == 1) {
      print("Seek worked");
    } else {
      print("Seek failed");
    }
  }

  Icon _getMainButtonIcon() {
    if (_isPlaying) {
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
    _isPlaying ? _pause() : _play();
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  String _getElapsedTime() {
    Duration duration =
        Duration(milliseconds: (_position * _totalDuration).toInt());
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
  }

  String _getRemainingTime() {
    Duration duration =
        Duration(milliseconds: ((1 - _position) * _totalDuration).toInt());
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
  }

  void _initialisePlayer() async {
    await _audioPlayer.setUrl(widget.audioFilePath, isLocal: true);
    _audioPlayer.onAudioPositionChanged.listen((Duration d) async {
      int currentPosition = await _audioPlayer.getCurrentPosition();
      setState(
          () => _position = (currentPosition / _totalDuration).clamp(0.0, 1.0));
    });
    _audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      if (s == AudioPlayerState.COMPLETED) {
        _audioPlayer.stop();
        setState(() {
          _position = 0;
          _isPlaying = false;
        });
      }
    });
    _audioPlayer.onDurationChanged.listen((Duration d) async {
      int totalDuration = await _audioPlayer.getDuration();
      setState(() {
        _totalDuration = totalDuration;
      });
    });
  }

  @override
  void initState() {
    // AudioPlayer.logEnabled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialisePlayer();
    });
    print(widget.audioFilePath);
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
    await _audioPlayer.stop();
    await _audioPlayer.release();
    await _audioPlayer.dispose();
    super.deactivate();
  }

  void _display(int init, int end, int last) {
    print("$init, $end, $last");
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
              initialValue: 0,
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
                setState(() {
                  _position = value;
                });
                seek();
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
                  onTap:  () {print("Just stopped");},
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
    //       Stack(
    //         children: <Widget>[
    //           Padding(
    //             padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: <Widget>[
    //                 Text(
    //                   _getElapsedTime(),
    //                   style:
    //                       TextStyle(color: AirnoteColors.text.withOpacity(0.7)),
    //                 ),
    //                 Text(_getRemainingTime(),
    //                     style: TextStyle(
    //                         color: AirnoteColors.text.withOpacity(0.7)))
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }
}
