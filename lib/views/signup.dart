import 'package:airnote/components/app-bar.dart';
import 'package:airnote/components/header-text.dart';
import 'package:airnote/components/submit-button.dart';
import 'package:airnote/components/text-input-field.dart';
import 'package:airnote/views/login.dart';
import 'package:airnote/views/root.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/utils/input-validator.dart';
import 'package:airnote/view-models/base.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:airnote/view-models/user.dart';

class Signup extends StatefulWidget {
  static const routeName = "signup";

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  Map<String, String> _formData = {};

  setForename(value) {
    setState(() {
      _formData['forename'] = value;
    });
  }

  setSurname(value) {
    setState(() {
      _formData['surname'] = value;
    });
  }

  setEmail(value) {
    setState(() {
      _formData['email'] = value;
    });
  }

  setPassword(value) {
    setState(() {
      _formData['password'] = value;
    });
  }

  _handleLoginTap() {
    Navigator.of(context).pushNamed(Login.routeName);
  }

  _handleSignupTap() async {
    final userModelView = Provider.of<UserViewModel>(context);
    final status = userModelView.getStatus();
    if (status == ViewStatus.LOADING) return;
    final form = _formKey.currentState;
    if (!form.validate()) return;
    form.save();
    await userModelView.signup(_formData);
    Navigator.of(context).pushNamedAndRemoveUntil(Root.routeName, (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AirnoteAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 20.0, top: 20.0),
                  child: AirnoteHeaderText(text: "Let's introduce ourselves!"),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      AirnoteTextInputField(
                        hint: "Nice to meet you!",
                        label: "Forename",
                        validator: InputValidator.name,
                        save: setForename,
                        suffix: Icon(Icons.face),
                      ),
                      AirnoteTextInputField(
                        hint: "How should we call you?",
                        label: "Surname",
                        validator: InputValidator.name,
                        save: setSurname,
                        suffix: Icon(Icons.person_outline),
                      ),
                      AirnoteTextInputField(
                        hint: "How can we reach you?",
                        label: "Email",
                        validator: InputValidator.email,
                        save: setEmail,
                        suffix: Icon(Icons.alternate_email),
                      ),
                      AirnoteTextInputField(
                        hint: "Our little secret",
                        label: "Password",
                        validator: InputValidator.password,
                        save: setPassword,
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
    );
  }
}
