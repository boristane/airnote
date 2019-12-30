import 'package:airnote/components/app-bar.dart';
import 'package:airnote/components/header-text.dart';
import 'package:airnote/components/submit-button.dart';
import 'package:airnote/components/text-input-field.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/utils/input-validator.dart';
import 'package:airnote/view-models/base.dart';
import 'package:airnote/view-models/user.dart';
import 'package:airnote/views/root.dart';
import 'package:airnote/views/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  static final routeName = "login";
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  Map<String, String> _formData = {};

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

  _handleSignupTap() {
    Navigator.of(context).pushNamed(Signup.routeName);
  }

  _handleLoginTap() async {
    final userModelView = Provider.of<UserViewModel>(context);
    final status = userModelView.getStatus();
    if (status == ViewStatus.LOADING) return;
    final form = _formKey.currentState;
    if (!form.validate()) return;
    form.save();
    await userModelView.login(_formData);
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
                      save: setPassword,
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
    );
  }
}
