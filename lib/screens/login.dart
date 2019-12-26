import 'package:airnote/components/app-bar.dart';
import 'package:airnote/components/header-text.dart';
import 'package:airnote/components/text-input-field.dart';
import 'package:airnote/utils/input-validator.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  static final routeName = "login";
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _loginFormKey = GlobalKey<FormState>();
  Map<String, String> _formData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AirnoteAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 20.0, top: 20.0),
                child: AirnoteHeaderText(text: "Welcome Back!"),
              ),
              Form(
                  key: _loginFormKey,
                  child: Column(
                    children: <Widget>[
                      AirnoteTextInputField(
                        label: "Email",
                        hint: "me@mail.com",
                        validator: InputValidator.email,
                        suffix: Icon(Icons.alternate_email),
                      ),
                      AirnoteTextInputField(
                        label: "Password",
                        hint: "Our little secret",
                        validator: InputValidator.password,
                        suffix: Icon(Icons.lock_outline),
                      ),
                    ],
                  ))
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 25.0),
        )),
      ),
    );
  }
}
