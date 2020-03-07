import 'package:airnote/managers/app-manager.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/view-models/entry.dart';
import 'package:airnote/view-models/quest.dart';
import 'package:airnote/view-models/routine.dart';
import 'package:airnote/view-models/user.dart';
import 'package:airnote/views/create-entry/record.dart';
import 'package:airnote/views/create-passphrase.dart';
import 'package:airnote/views/home.dart';
import 'package:airnote/views/login.dart';
import 'package:airnote/views/entry.dart';
import 'package:airnote/views/remember-passphrase.dart';
import 'package:airnote/views/root.dart';
import 'package:airnote/views/routine.dart';
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
          create: (context) => EntryViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => RoutineViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => QuestViewModel(),
        ),
      ],
      child: Airnote(),
    ),
  );
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
      primarySwatch: AirnoteColors.swatch,
      textTheme: _textTheme,
    );

    return MaterialApp(
      title: "Lesley",
      theme: _theme,
      builder: (context, widget) => Scaffold(
        body: Builder(
          builder: (context) => Navigator(
            onGenerateRoute: (RouteSettings settings) => MaterialPageRoute(
              builder: (context) => AppManager(
                child: widget,
              ),
            ),
          ),
        ),
      ),
      routes: {
        Login.routeName: (context) => Login(),
        Signup.routeName: (context) => Signup(),
        EntryView.routeName: (context) => EntryView(),
        Home.routeName: (context) => Home(),
        CreatePassPhrase.routeName: (context) => CreatePassPhrase(),
        RememberPassPhrase.routeName: (context) => RememberPassPhrase(),
        RecordEntry.routeName: (context) => RecordEntry(),
        Routine.routeName: (context) => Routine(),
      },
      home: Root(),
    );
  }
}
