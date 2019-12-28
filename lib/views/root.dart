import 'package:airnote/utils/auth.dart';
import 'package:airnote/views/home.dart';
import 'package:airnote/views/intro.dart';
import 'package:flutter/material.dart';

class Root extends StatefulWidget {
  static final String routeName = "/";
  @override
  State<StatefulWidget> createState() => _RootState();
}

class _RootState extends State<Root> {
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
  }

  @override
  Widget build(BuildContext context) {
    if(_isLoggedIn) {
      return Home();
    }
    return Intro();
  }
}