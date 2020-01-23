import 'package:airnote/components/circular-button.dart';
import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';

class AirnoteAudioPlayer extends StatefulWidget {
  @override
  State<AirnoteAudioPlayer> createState() => _AirnoteAudioPlayerState();
}

class _AirnoteAudioPlayerState extends State<AirnoteAudioPlayer> {
  double _position = 0.0;

  @override
  Widget build(BuildContext context) {
    // return Container(child: Text("Whatever"),);
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
                onChanged: (double value){
                  setState(() {
                    _position = value;
                  });
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
                      '2:10',
                      style: TextStyle(color: Colors.black.withOpacity(0.7)),
                    ),
                    Text('-03:56',
                        style: TextStyle(color: Colors.black.withOpacity(0.7)))
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
                        icon: Icon(
                          Icons.play_arrow,
                          color: AirnoteColors.primary,
                        ),
                        onTap: () {
                          print("Playing");
                        },
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
