import 'package:airnote/components/header-text.dart';
import 'package:airnote/components/loading.dart';
import 'package:airnote/components/option-button.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/view-models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountView extends StatefulWidget {
  static const routeName = "account";
  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  UserViewModel _userViewModel;

  @override
  void didChangeDependencies() {
    final userViewModel = Provider.of<UserViewModel>(context);
    super.didChangeDependencies();
    if (this._userViewModel == userViewModel) {
      return;
    }
    this._userViewModel = userViewModel;
    Future.microtask(this._userViewModel.getUser);
  }

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(color: AirnoteColors.primary);
    final subStyle = TextStyle(color: AirnoteColors.grey);
    final user = this._userViewModel.user;
    if (user == null) {
      Navigator.of(context).pop();
      return AirnoteLoadingScreen();
    }
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 140.0),
          child: ListView(shrinkWrap: true, children: <Widget>[
            ListTile(
              title: Text("Name", style: style),
              leading: Icon(
                Icons.face,
                color: AirnoteColors.primary,
              ),
              subtitle:
                  Text("${user.forename} ${user.surname}", style: subStyle),
            ),
            ListTile(
              title: Text("Email", style: style),
              leading: Icon(
                Icons.alternate_email,
                color: AirnoteColors.primary,
              ),
              subtitle: Text("${user.email}", style: subStyle),
            ),
            ListTile(
              title: Text("Membership", style: style),
              leading: Icon(
                Icons.card_membership,
                color: AirnoteColors.primary,
              ),
              subtitle: Text("Premium", style: subStyle),
            ),
          ]),
        ),
        Positioned(
          top: 100,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: AirnoteHeaderText(
              text: "Account",
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: AirnoteOptionButton(
                icon: Icon(Icons.arrow_downward),
                onTap: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
