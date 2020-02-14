import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TitleInputField extends StatelessWidget {
  final String hint;
  final void Function(String) onSaved;
  final void Function(String) validator;
  const TitleInputField({
    Key key,
    this.hint,
    this.onSaved,
    this.validator,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 3,
        cursorColor: AirnoteColors.primary,
        style: TextStyle(fontWeight: FontWeight.bold, color: AirnoteColors.grey),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: AirnoteColors.lightBlue),
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(100),
        ],
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}