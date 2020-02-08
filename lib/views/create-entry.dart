import 'package:airnote/components/circular-button.dart';
import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';

class CreateEntry extends StatefulWidget {
  static const routeName = "create-entry";
  @override
  _CreateEntryState createState() => _CreateEntryState();
}

class _CreateEntryState extends State<CreateEntry> {
  SpeechRecognition _speechRecognition;

  bool _isAvailable = false;
  bool _isListening = false;

  String _text = '';
  @override
  initState() {
    super.initState();
    _activateSpeechRecognizer();
  }

  void _activateSpeechRecognizer() {
    _speechRecognition = new SpeechRecognition();
    _speechRecognition.setAvailabilityHandler(onSpeechAvailability);
    _speechRecognition.setRecognitionStartedHandler(onRecognitionStarted);
    _speechRecognition.setRecognitionResultHandler(onRecognitionResult);
    _speechRecognition.setRecognitionCompleteHandler(onRecognitionComplete);
    _speechRecognition
        .activate()
        .then((res) => setState(() => _isAvailable = res));
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
              _text,
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
                icon: Icon(Icons.mic),
                isLarge: true,
                onTap: start,
              ),
              AirnoteCircularButton(
                icon: Icon(Icons.stop),
                onTap: stop,
              ),
            ],
          ),
        ],
      ),
    ));
  }

  void start() {
    if (!(_isAvailable && !_isListening)) {
      return;
    }
    _speechRecognition
        .listen(locale: "en_US")
        .then((result) => print('_MyAppState.start => result $result'));
  }

  void cancel() {
    if (!_isListening) {
      return;
    }
    _speechRecognition
        .cancel()
        .then((result) => setState(() => _isListening = result));
  }

  void stop() {
    if (!_isListening) {
      return;
    }
    _speechRecognition.stop().then((result) {
      setState(() => _isListening = result);
    });
  }

  void onSpeechAvailability(bool result) =>
      setState(() => _isAvailable = result);

  void onRecognitionStarted() => setState(() => _isListening = true);

  void onRecognitionResult(String text) => setState(() => _text = text);

  void onRecognitionComplete() => setState(() => _isListening = false);
}
