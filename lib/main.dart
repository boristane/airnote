import 'package:airnote/managers/app-manager.dart';
import 'package:airnote/screens/intro.dart';
import 'package:airnote/screens/login.dart';
import 'package:airnote/screens/signup.dart';
import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: AirnoteColors.swatch,
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
          hintStyle: TextStyle(color: AirnoteColors.inactive, fontSize: 20.0),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AirnoteColors.primary, width: 2.0),
          ),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black45, width: 2.0))
        ),
        primaryColor: AirnoteColors.primary,
        primaryIconTheme: IconThemeData(color: AirnoteColors.primary),
        textTheme: TextTheme(
          title: TextStyle(color: AirnoteColors.text),
          subhead: TextStyle(color: AirnoteColors.grey),
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
        Login.routeName: (context) => Login(),
        Signup.routeName: (context) => Signup(),
      },
      home: Intro(),
    );
  }
}
