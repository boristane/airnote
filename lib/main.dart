import 'package:airnote/managers/dialog-manager.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/view-models/note.dart';
import 'package:airnote/view-models/user.dart';
import 'package:airnote/views/login.dart';
import 'package:airnote/views/root.dart';
import 'package:airnote/views/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => NoteViewModel(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

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
    final _inputDecorationTheme = InputDecorationTheme(
        hintStyle: TextStyle(color: AirnoteColors.inactive, fontSize: 20.0),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AirnoteColors.primary, width: 2.0),
        ),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black45, width: 2.0)));

    final _textTheme = TextTheme(
      title: TextStyle(color: AirnoteColors.text),
      subhead: TextStyle(color: AirnoteColors.grey),
    );

    final _theme = ThemeData(
      inputDecorationTheme: _inputDecorationTheme,
      primaryColor: AirnoteColors.primary,
      primaryIconTheme: IconThemeData(color: AirnoteColors.primary),
      textTheme: _textTheme,
    );

    return MaterialApp(
      title: "Airnote",
      theme: _theme,
      builder: (context, widget) => Navigator(
        onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
          builder: (context) => DialogManager(
            child: widget,
          ),
        ),
      ),
      routes: {
        Login.routeName: (context) => Login(),
        Signup.routeName: (context) => Signup(),
      },
      home: Root(),
    );
  }
}
