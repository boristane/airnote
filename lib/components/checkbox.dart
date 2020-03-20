import 'package:airnote/utils/colors.dart';
import 'package:flutter/material.dart';

class AirnoteCirclarCheckBox extends StatefulWidget {
  final bool value;
  final bool interactive;
  final Function onTap;

  AirnoteCirclarCheckBox({Key key, this.value, this.interactive = true, this.onTap}) : super(key: key);
  @override
  _AirnoteCirclarCheckBoxState createState() => _AirnoteCirclarCheckBoxState();
}

class _AirnoteCirclarCheckBoxState extends State<AirnoteCirclarCheckBox> {
  bool _value = false;

  @override
  void initState() {
    setState(() {
      _value = widget.value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AirnoteColors.primary,
            border: Border.all(width: 1, color: AirnoteColors.primary)),
        child: Container(
          child: Material(
            borderRadius: BorderRadius.circular(50.0),
            color: _value ? AirnoteColors.primary : AirnoteColors.backgroundColor,
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              onTap: () {
                if(!widget.interactive) return;
                setState(() {
                  _value = !_value;
                });
                widget.onTap();
              },
              child: Container(
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: _value ? Icon(
                      Icons.check,
                      size: 30.0,
                      color: AirnoteColors.backgroundColor,
                    ) : Icon(
                      Icons.close,
                      size: 30.0,
                      color: AirnoteColors.backgroundColor,
                    )
                    ),
              ),
            ),
          ),
        ));
  }
}
