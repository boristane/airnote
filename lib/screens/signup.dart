import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  static const routeName = "signup";

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Sign Up"),
    );
  }
} 