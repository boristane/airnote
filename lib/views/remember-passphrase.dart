import 'package:airnote/components/app-bar.dart';
import 'package:airnote/components/header-text.dart';
import 'package:airnote/components/submit-button.dart';
import 'package:airnote/components/text-input-field.dart';
import 'package:airnote/services/locator.dart';
import 'package:airnote/views/root.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/utils/input-validator.dart';
import 'package:flutter/material.dart';
import 'package:airnote/services/passphrase.dart';

class RememberPassPhrase extends StatefulWidget {
  static const routeName = "verify-pass-phrase";

  @override
  _RememberPassPhraseState createState() => _RememberPassPhraseState();
}

class _RememberPassPhraseState extends State<RememberPassPhrase> {
  final _formKey = GlobalKey<FormState>();
  Map<String, String> _formData = {};

  _setPassphrase(value) {
    setState(() {
      _formData['passPhrase'] = value;
    });
  }

  _handleProceedTap() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        Root.routeName, (Route<dynamic> route) => false);
  }

  _handleRememberPassPhraseTap() async {
    final uuid = ModalRoute.of(context).settings.arguments;
    final passPhraseService = locator<PassPhraseService>();
    final form = _formKey.currentState;
    if (!form.validate()) return;
    form.save();
    await passPhraseService.savePassPhrase(uuid, _formData["passPhrase"]);
    Navigator.of(context).pushNamedAndRemoveUntil(
        Root.routeName, (Route<dynamic> route) => false);
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
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  child: AirnoteHeaderText(
                      text: "Do you remember your Pass Phrase?"),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20.0, top: 20.0),
                  child: Text(
                    "Please make sure you enter the Pass Phrase you used to sign up. Otherwise your stories will not display properly.",
                    style: TextStyle(
                      fontSize: 15,
                      color: AirnoteColors.grey,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      AirnoteTextInputField(
                        hint: "Your big secret",
                        label: "Pass Phrase",
                        validator: InputValidator.passPhrase,
                        save: _setPassphrase,
                        obscure: true,
                        suffix: Icon(Icons.lock_outline),
                      ),
                      AirnoteSubmitButton(
                        text: "Let's go!",
                        onPressed: _handleRememberPassPhraseTap,
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("You do not have a pass phrase? ",
                          style: TextStyle(color: AirnoteColors.grey)),
                      GestureDetector(
                        onTap: _handleProceedTap,
                        child: Text(
                          "Proceed",
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
