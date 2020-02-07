import 'package:airnote/components/circular-button.dart';
import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';

class CreateEntry extends StatefulWidget {
  static const routeName = "create-entry";
  @override
  _CreateEntryState createState() => _CreateEntryState();
}

const languages = const [
  const Language('Francais', 'fr_FR'),
  const Language('English', 'en_US'),
  const Language('Pусский', 'ru_RU'),
  const Language('Italiano', 'it_IT'),
  const Language('Español', 'es_ES'),
];

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

class _CreateEntryState extends State<CreateEntry> {
  SpeechRecognition _speechRecognition;

  bool _isAvailable = false;
  bool _isListening = false;

  String _text = '';

  //String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_MyAppState.activateSpeechRecognizer... ');
    _speechRecognition = new SpeechRecognition();
    _speechRecognition.setAvailabilityHandler(onSpeechAvailability);
    _speechRecognition.setCurrentLocaleHandler(onCurrentLocale);
    _speechRecognition.setRecognitionStartedHandler(onRecognitionStarted);
    _speechRecognition.setRecognitionResultHandler(onRecognitionResult);
    _speechRecognition.setRecognitionCompleteHandler(onRecognitionComplete);
    // _speech.setErrorHandler(errorHandler);
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
                  onTap: _isListening ? () => cancel() : null,
                ),
                AirnoteCircularButton(
                  icon: Icon(Icons.mic),
                  isLarge: true,
                  onTap: _isAvailable && !_isListening
                        ? () => start()
                        : null,
                ),
                AirnoteCircularButton(
                  icon: Icon(Icons.stop),
                  onTap: _isListening ? () => stop() : null,
                ),
              ],
            ),
      ],
    ),
        ));
  }

  void start() => _speechRecognition
      .listen(locale: selectedLang.code)
      .then((result) => print('_MyAppState.start => result $result'));

  void cancel() =>
      _speechRecognition.cancel().then((result) => setState(() => _isListening = result));

  void stop() => _speechRecognition.stop().then((result) {
        setState(() => _isListening = result);
      });

  void onSpeechAvailability(bool result) =>
      setState(() => _isAvailable = result);

  void onCurrentLocale(String locale) {
    print('_MyAppState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() => setState(() => _isListening = true);

  void onRecognitionResult(String text) => setState(() => _text = text);

  void onRecognitionComplete() => setState(() => _isListening = false);

  void errorHandler() => activateSpeechRecognizer();
}
