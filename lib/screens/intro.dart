import 'package:airnote/components/dot-indicator.dart';
import 'package:airnote/components/flat-button.dart';
import 'package:airnote/components/raised-button.dart';
import 'package:airnote/data/slide.dart';
import 'package:flutter/material.dart';

class Intro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AirnoteRaisedButton _signupButton =
        AirnoteRaisedButton(text: "Signup", onPressed: () => print("Signup"));
    final AirnoteFlatButton _loginButton =
        AirnoteFlatButton(text: "Login", onPressed: () => print("Login"));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                IntroSlide(slideData),
                _signupButton,
                _loginButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IntroSlide extends StatefulWidget {
  List _data = [];

  IntroSlide(this._data);
  @override
  State<StatefulWidget> createState() => _IntroSlideState();
}

class _IntroSlideState extends State<IntroSlide> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final height = screenHeight < 500 ? 460 : screenHeight * 0.7;

    final Container dots = Container(
      width: widget._data.length.toDouble() * 20,
      margin: EdgeInsets.only(bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widget._data.length,
            (index) {
          return AirnoteDotIndicator(active: _currentIndex == index);
        }),
      ),
    );

    return Container(
      child: dots,
    );
  }
}


