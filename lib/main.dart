import 'package:airnote/managers/app-manager.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/view-models/entry.dart';
import 'package:airnote/view-models/notifications.dart';
import 'package:airnote/view-models/quest.dart';
import 'package:airnote/view-models/routine.dart';
import 'package:airnote/view-models/user.dart';
import 'package:airnote/views/create-entry/entry-type.dart';
import 'package:airnote/views/create-entry/record.dart';
import 'package:airnote/views/create-passphrase.dart';
import 'package:airnote/views/home.dart';
import 'package:airnote/views/login.dart';
import 'package:airnote/views/quest.dart';
import 'package:airnote/views/remember-passphrase.dart';
import 'package:airnote/views/root.dart';
import 'package:airnote/views/routine.dart';
import 'package:airnote/views/settings.dart';
import 'package:airnote/views/settings/account.dart';
import 'package:airnote/views/settings/notifications.dart';
import 'package:airnote/views/settings/privacy.dart';
import 'package:airnote/views/signup.dart';
import 'package:airnote/views/view-entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

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
        ChangeNotifierProvider(
          create: (context) => NotificationsViewModel(),
        ),
      ],
      child: Airnote(),
    ),
  );
}

class Airnote extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

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
      title: TextStyle(color: AirnoteColors.grey),
      subhead: TextStyle(color: AirnoteColors.inactive),
      body1: TextStyle(color: AirnoteColors.grey),
    );

    final _theme = ThemeData(
      inputDecorationTheme: _inputDecorationTheme,
      primaryColor: AirnoteColors.primary,
      primaryIconTheme: IconThemeData(color: AirnoteColors.primary),
      primarySwatch: AirnoteColors.swatch,
      fontFamily: "Raleway",
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
        Login.routeName: (context) => Login(analytics: analytics),
        Signup.routeName: (context) => Signup(analytics: analytics),
        EntryView.routeName: (context) => EntryView(),
        Home.routeName: (context) => Home(analytics: analytics),
        CreatePassPhrase.routeName: (context) => CreatePassPhrase(),
        RememberPassPhrase.routeName: (context) => RememberPassPhrase(),
        RecordEntry.routeName: (context) => RecordEntry(),
        RoutineView.routeName: (context) => RoutineView(),
        QuestView.routeName: (context) => QuestView(),
        SelectEntryType.routeName: (context) => SelectEntryType(),
        SettingsView.routeName: (context) => SettingsView(),
        AccountView.routeName: (context) => AccountView(),
        PrivacyView.routeName: (contect) => PrivacyView(),
        NotificationsView.routeName: (context) => NotificationsView(),
      },
      navigatorObservers: <NavigatorObserver>[observer],
      home: Root(analytics: analytics,),
    );
  }
}
