import 'package:airnote/utils/colors.dart';
import 'package:airnote/view-models/base.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:airnote/view-models/user.dart';

class AirnoteSubmitButton extends Container {
  final String text;
  final Function onPressed;
  AirnoteSubmitButton({Key key, this.text, this.onPressed})
      : super(key: key);

  Widget _getText(BuildContext context) {
    final isLoading = Provider.of<UserViewModel>(context).getStatus() == ViewStatus.LOADING;
    if (isLoading) {
      return SizedBox(
        width: 20.0,
        height: 20.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(AirnoteColors.white),
        ),
      );
    }
    return Text(
      text,
      style: TextStyle(color: AirnoteColors.white, fontSize: 18.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 60,
      margin: EdgeInsets.only(top: 40.0, bottom: 30.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
              color: AirnoteColors.grey.withOpacity(.4),
              offset: Offset(3, 5.0),
              blurRadius: 5.0),
        ],
      ),
      child: RaisedButton(
        onPressed: () {
          onPressed();
        },
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: _getText(context),
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AirnoteColors.white,
              ),
              child: Icon(Icons.arrow_forward,
                  color: AirnoteColors.primary, size: 20.0),
            )
          ],
        ),
        color: AirnoteColors.primary,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
    );
  }
}
