import 'package:airnote/components/app-bar.dart';
import 'package:airnote/components/header-text.dart';
import 'package:airnote/components/submit-button.dart';
import 'package:airnote/components/text-input-field.dart';
import 'package:airnote/services/database.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/utils/input-validator.dart';
import 'package:airnote/view-models/base.dart';
import 'package:airnote/view-models/user.dart';
import 'package:airnote/views/remember-passphrase.dart';
import 'package:airnote/views/root.dart';
import 'package:airnote/views/signup.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  static final routeName = "login";

  final FirebaseAnalytics analytics;

  Login({Key key, this.analytics}) : super(key: key);
  @override
  _LoginState createState() => _LoginState(analytics);
}

class _LoginState extends State<Login> {
  _LoginState(this.analytics);
  final FirebaseAnalytics analytics;

  final _formKey = GlobalKey<FormState>();
  Map<String, String> _formData = {};

  setEmail(String value) {
    setState(() {
      _formData['email'] = value.trim();
    });
  }

  _setPassword(String value) {
    setState(() {
      _formData['password'] = value.trim();
    });
  }

  _handleSignupTap() {
    Navigator.of(context).pushNamed(Signup.routeName);
  }

  _handleLoginTap() async {
    final userModelView = Provider.of<UserViewModel>(context);
    DatabaseService dbService = locator<DatabaseService>();
    final status = userModelView.getStatus();
    if (status == ViewStatus.LOADING) return;
    final form = _formKey.currentState;
    if (!form.validate()) return;
    form.save();
    final success = await userModelView.login(_formData);
    if (!success) {
      return;
    }
    final user = userModelView.user;
    final passPhrase = await dbService.getPassPhrase(user.uuid);
    await analytics.setUserId(user.uuid);
    await analytics.logLogin();
    if (passPhrase == null) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          RememberPassPhrase.routeName, (Route<dynamic> route) => false,
          arguments: user.uuid);
      return;
    }
    Navigator.of(context).pushNamedAndRemoveUntil(
        Root.routeName, (Route<dynamic> route) => false);
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 20.0, top: 20.0),
                  child: AirnoteHeaderText(text: "Welcome Back!"),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      AirnoteTextInputField(
                        label: "Email",
                        hint: "me@mail.com",
                        validator: InputValidator.email,
                        suffix: Icon(Icons.alternate_email),
                        save: setEmail,
                      ),
                      AirnoteTextInputField(
                        label: "Password",
                        hint: "Our little secret",
                        validator: InputValidator.password,
                        suffix: Icon(Icons.lock_outline),
                        obscure: true,
                        save: _setPassword,
                      ),
                      AirnoteSubmitButton(
                        text: "Login",
                        onPressed: _handleLoginTap,
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("New here? ",
                          style: TextStyle(color: AirnoteColors.grey)),
                      GestureDetector(
                        onTap: _handleSignupTap,
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: AirnoteColors.primary),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
