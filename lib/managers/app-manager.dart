import 'package:flutter/material.dart';

class AppManager extends StatefulWidget {
  final Widget child;

  const AppManager({Key key, this.child}) : super(key: key);

  @override
  State<AppManager> createState() => _AppManagerState();
}

class _AppManagerState extends State<AppManager> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
