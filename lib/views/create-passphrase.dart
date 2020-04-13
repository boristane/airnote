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

class CreatePassPhrase extends StatefulWidget {
  static const routeName = "create-pass-phrase";

  @override
  _CreatePassPhraseState createState() => _CreatePassPhraseState();
}

class _CreatePassPhraseState extends State<CreatePassPhrase> {
  final _formKey = GlobalKey<FormState>();
  Map<String, String> _formData = {};
  bool _checked = true;

  _setPassphrase(value) {
    setState(() {
      _formData['passPhrase'] = value;
    });
  }

  _setChecked(bool value) {
    setState(() {
      _formData['checked'] = value ? "checked" : "not-checked";
    });
  }

  _handleProceedTap() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        Root.routeName, (Route<dynamic> route) => false);
  }

  _handleSavePassPhraseTap() async {
    setState(() {
    _checked = _formData['checked'] == "checked";
    });
    final uuid = ModalRoute.of(context).settings.arguments;
    final passPhraseService = locator<PassPhraseService>();
    final form = _formKey.currentState;
    if (!form.validate() || !_checked) return;
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
                      text: "A pass phrase to protect your privacy."),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20.0, top: 20.0),
                  child: Text(
                    "With a pass phrase, your journal is encrypted on your phone. You and only you (not even us) can read or listen to your stories. Please make sure you remember your Pass Phrase, your stories will not display properly otherwise.",
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _formData['checked'] =
                                  _formData['checked'] == "not-checked"
                                      ? "checked"
                                      : "not-checked";
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Transform.scale(
                                scale: 1.2,
                                child: Checkbox(
                                  value: _formData["checked"] == "checked",
                                  onChanged: _setChecked,
                                  activeColor: AirnoteColors.primary,
                                  checkColor: AirnoteColors.white,
                                ),
                              ),
                              Text(
                                "I have written my pass phrase down.",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: _checked ? AirnoteColors.grey : AirnoteColors.danger,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AirnoteSubmitButton(
                        text: "Let's go!",
                        onPressed: _handleSavePassPhraseTap,
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Not for encryption? ",
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
