import 'package:airnote/managers/app-manager.dart';
import 'package:airnote/screens/home.dart';
import 'package:airnote/screens/intro.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Airnote(),
    );
  }
}

class Airnote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Airnote",
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Color(0xFFC4C4C4), fontSize: 20.0),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF3C4858), width: 2.0),
          ),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black45, width: 2.0))
        ),
        primaryColor: Color(0xFF3C4858),
        primaryIconTheme: IconThemeData(color: Color(0xFF3C4858)),
        textTheme: TextTheme(
          title: TextStyle(color: Color(0xFF414A53)),
          subhead: TextStyle(color: Color(0xFF686B6F)),
        )
      ),
      builder: (context, widget) => Navigator(
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => AppManager(
            child: widget,
          ),
        ),
      ),
      routes: {
        // "/": (context) => Home(),
      },
      home: Intro(),
    );
  }
}
