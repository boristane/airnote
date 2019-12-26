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
    final cardHeight = screenHeight < 500 ? 460 : screenHeight * 0.7;

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
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Container(),
        Container(
          width: 270,
          height: 380,
          margin: EdgeInsets.only(top: 100.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                  color: Color(0xFF3C4858).withOpacity(.4),
                  offset: Offset(6.0, 10.0),
                  blurRadius: 20.0),
            ],
            image: DecorationImage(
              image: AssetImage(
                _currentSlide.image,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment(0.1, 1.0),
            child: Container(
              padding: EdgeInsets.all(15.0),
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.blueGrey.withOpacity(0.8),
              ),
              child: Text(
                _currentSlide.title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
