import 'package:airnote/components/dot-indicator.dart';
import 'package:airnote/components/flat-button.dart';
import 'package:airnote/components/raised-button.dart';
import 'package:airnote/data/slide.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/views/login.dart';
import 'package:airnote/views/signup.dart';
import 'package:flutter/material.dart';

class Intro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AirnoteRaisedButton _signupButton = AirnoteRaisedButton(
        text: "Signup",
        onPressed: () => Navigator.of(context).pushNamed(Signup.routeName));
    final AirnoteFlatButton _loginButton = AirnoteFlatButton(
        text: "Login",
        onPressed: () => Navigator.of(context).pushNamed(Login.routeName));

    return Scaffold(
      body: SingleChildScrollView(
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
    );
  }
}

class IntroSlide extends StatefulWidget {
  final List _data;

  IntroSlide(this._data);
  @override
  State<StatefulWidget> createState() => _IntroSlideState();
}

class _IntroSlideState extends State<IntroSlide> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = screenHeight < 500 ? 460 : screenHeight * 0.75;

    final Container dots = Container(
      width: widget._data.length.toDouble() * 20,
      margin: EdgeInsets.only(bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widget._data.length, (index) {
          return AirnoteDotIndicator(active: _currentIndex == index);
        }),
      ),
    );

    return Container(
      height: cardHeight * 1.05,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: PageView.builder(
              itemCount: widget._data.length,
              onPageChanged: (int position) {
                setState(() {
                  _currentIndex = position;
                });
              },
              itemBuilder: (BuildContext context, int position) {
                final currentSlide = widget._data[position];
                return IntroSlideCard(cardHeight, currentSlide);
              },
            ),
          ),
          dots,
        ],
      ),
    );
  }
}

class IntroSlideCard extends StatelessWidget {
  final double _height;
  final SlideInfo _currentSlide;

  IntroSlideCard(this._height, this._currentSlide);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      child: Stack(children: <Widget>[
        Container(
          height: this._height * 0.95,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                _currentSlide.image,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
            height: this._height * 0.96,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                AirnoteColors.backgroundColor.withOpacity(0.0),
                AirnoteColors.backgroundColor
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
          ),
          Container(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
                width: double.infinity,
                child: Text(
                  _currentSlide.title,
                  style: TextStyle(
                      color: AirnoteColors.primary,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
      ]),
    );
  }
}
