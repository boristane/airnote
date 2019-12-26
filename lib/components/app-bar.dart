import 'package:flutter/material.dart';

class AirnoteAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AirnoteAppBar({Key key})
      : super(key: key);
  
  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      leading: InkWell(
        customBorder: CircleBorder(),
          onTap: () => Navigator.pop(context),
        child: Icon(Icons.arrow_back,
          color: Color.fromRGBO(90, 97, 117, 1), size: 30),
      )      
    );
  }
}
