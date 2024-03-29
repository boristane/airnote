import 'package:airnote/components/app-bar.dart';
import 'package:airnote/components/header-text.dart';
import 'package:airnote/components/submit-button.dart';
import 'package:airnote/components/text-input-field.dart';
import 'package:airnote/views/create-passphrase.dart';
import 'package:airnote/views/login.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/utils/input-validator.dart';
import 'package:airnote/view-models/base.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:airnote/view-models/user.dart';

class Signup extends StatefulWidget {
  static const routeName = "signup";

  final FirebaseAnalytics analytics;

  Signup({Key key, this.analytics}) : super(key: key);
  @override
  _SignupState createState() => _SignupState(analytics);
}

class _SignupState extends State<Signup> {
  _SignupState(this.analytics);
  final FirebaseAnalytics analytics;
  final _formKey = GlobalKey<FormState>();
  Map<String, String> _formData = {};

  _setForename(String value) {
    setState(() {
      _formData['forename'] = value.trim();
    });
  }

  _setEmail(String value) {
    setState(() {
      _formData['email'] = value.trim();
    });
  }

  _setPassword(String value) {
    setState(() {
      _formData['password'] = value.trim();
    });
  }

  _handleLoginTap() {
    Navigator.of(context).pushNamed(Login.routeName);
  }

  _handleSignupTap() async {
    final userViewModel = Provider.of<UserViewModel>(context);
    final status = userViewModel.getStatus();
    if (status == ViewStatus.LOADING) return;
    final form = _formKey.currentState;
    if (!form.validate()) return;
    form.save();
    final success = await userViewModel.signup(_formData);
    if (!success) {
      return;
    }
    final user = userViewModel.user;
    await analytics.setUserId(user.uuid);
    await analytics.logSignUp(signUpMethod: "email");
    await analytics.logLogin();
    Navigator.of(context).pushNamedAndRemoveUntil(
        CreatePassPhrase.routeName, (Route<dynamic> route) => false,
        arguments: user.uuid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AirnoteAppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20.0),
                    child:
                        AirnoteHeaderText(text: "Let's introduce ourselves!"),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        AirnoteTextInputField(
                          hint: "Nice to meet you!",
                          label: "Forename",
                          validator: InputValidator.name,
                          save: _setForename,
                          suffix: Icon(Icons.face),
                        ),
                        AirnoteTextInputField(
                          hint: "How can we reach you?",
                          label: "Email",
                          validator: InputValidator.email,
                          save: _setEmail,
                          suffix: Icon(Icons.alternate_email),
                        ),
                        AirnoteTextInputField(
                          hint: "Our little secret",
                          label: "Password",
                          validator: InputValidator.password,
                          save: _setPassword,
                          obscure: true,
                          suffix: Icon(Icons.lock_outline),
                        ),
                        AirnoteSubmitButton(
                          text: "Create Account",
                          onPressed: _handleSignupTap,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Already have an account? ",
                            style: TextStyle(color: AirnoteColors.grey)),
                        GestureDetector(
                          onTap: _handleLoginTap,
                          child: Text(
                            "Login",
                            style: TextStyle(color: AirnoteColors.primary),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
