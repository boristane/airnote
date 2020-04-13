import 'package:airnote/utils/auth.dart';
import 'package:airnote/views/home.dart';
import 'package:airnote/views/intro.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class Root extends StatefulWidget {
  static final String routeName = "/";
  final FirebaseAnalytics analytics;

  Root({Key key, this.analytics})
      : super(key: key);
  @override
  _RootState createState() => _RootState(analytics);
}

class _RootState extends State<Root> {
  _RootState(this.analytics);
  final FirebaseAnalytics analytics;
  bool _isLoggedIn = false;

  _getAuthStatus() async {
    final isLoggedIn = (await AuthHelper.status()) == AuthStatus.LOGGED_IN;
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  @override
  initState() {
    super.initState();
    _getAuthStatus();
    analytics.logAppOpen();
  }

  @override
  Widget build(BuildContext context) {
    if(_isLoggedIn) {
      return Home(analytics: analytics);
    }
    return Intro();
  }
}