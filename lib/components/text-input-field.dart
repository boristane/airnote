import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';

class AirnoteTextInputField extends StatelessWidget {
  final String label;
  final Function validator;
  final Function save;
  final String hint;
  final Icon suffix;
  final bool obscure;

  AirnoteTextInputField(
      {Key key, this.label, this.hint, this.suffix, this.validator, this.obscure = false, this.save})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              child: Text(label),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 0.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: AirnoteColors.lightBlue),
                  suffixIcon: suffix,
                ),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                validator: validator,
                obscureText: obscure,
                onSaved: (value) => save(value),
              ),
            ),
          ],
        ));
  }
}
