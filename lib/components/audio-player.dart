import 'package:airnote/components/circular-button.dart';
import 'package:airnote/utils/colors.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

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
    Duration duration = Duration(milliseconds: (_position * _totalDuration).toInt());
    int minutes =  duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2,"0")}:${seconds.toString().padLeft(2, "0")}";
  }

  String _getRemainingTime() {
    Duration duration = Duration(milliseconds: ((1 - _position) * _totalDuration).toInt());
    int minutes =  duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2,"0")}:${seconds.toString().padLeft(2, "0")}";
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AirnoteColors.backgroundColor,
        border: Border(top: BorderSide(color: Colors.black12)),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AirnoteColors.primary,
                inactiveTrackColor: AirnoteColors.inactive,
                trackHeight: 3.0,
                thumbColor: AirnoteColors.primary,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.0),
                overlayColor: AirnoteColors.primary.withAlpha(32),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 12.0),
              ),
              child: Slider(
                onChanged: (double value) {
                  setState(() {
                    _position = value;
                  });
                  seek();
                },
                value: _position,
              ),
            ),
          ),
          Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      _getElapsedTime(),
                      style: TextStyle(color: AirnoteColors.text.withOpacity(0.7)),
                    ),
                    Text( _getRemainingTime(),
                        style: TextStyle(color: AirnoteColors.text.withOpacity(0.7)))
                  ],
                ),
              ),
              Align(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width / 2,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        Icons.fast_rewind,
                        color: AirnoteColors.primary,
                        size: 30.0,
                      ),
                      Container(
                          child: AirnoteCircularButton(
                        icon: _getMainButtonIcon(),
                        onTap: _onMainButtonTapped,
                        isLarge: true,
                      )),
                      Icon(
                        Icons.fast_forward,
                        color: AirnoteColors.primary,
                        size: 30.0,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
