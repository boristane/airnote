import 'package:airnote/components/loading.dart';
import 'package:airnote/components/raised-button.dart';
import 'package:airnote/models/user.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/view-models/base.dart';
import 'package:airnote/view-models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
    return SafeArea(child: Container(
      child: Consumer<UserViewModel>(
        builder: (context, model, child) {
          if (model.getStatus() == ViewStatus.LOADING) {
            return AirnoteLoadingScreen();
          }
          final profile = model.user;
          if (profile == null) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              alignment: Alignment.center,
              child: Text("Ooops ! There was a problem getting the data..."),
            );
          }

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                NameBox(forename: profile.forename),
                DetailsCard(profile: profile),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: AirnoteRaisedButton(
                      text: "Log out",
                      onPressed: () {
                        print("Login out");
                      },
                      shadow: false,
                    )),
                  ],
                )
              ],
            ),
          );
        },
      ),
    ));
  }
}

class NameBox extends StatelessWidget {
  final String forename;

  NameBox({Key key, this.forename}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: 100,
        height: 100,
        margin: EdgeInsets.only(bottom: 40.0),
        decoration: BoxDecoration(
            color: AirnoteColors.text,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, 0.0),
                  blurRadius: 10.0),
            ]),
        child: Text(
          "${forename[0].toUpperCase()}",
          style: TextStyle(color: AirnoteColors.white, fontSize: 32),
        ));
  }
}

class DetailsCard extends StatelessWidget {
  final User profile;
  DetailsCard({Key key, this.profile}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final mainTextStyle =
        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);
    final headerTextStyle = TextStyle(
        color: AirnoteColors.lightGrey,
        fontSize: 14.0,
        fontWeight: FontWeight.bold);
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              margin: EdgeInsets.only(bottom: 40),
              decoration: BoxDecoration(
                  color: AirnoteColors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0),
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      'Your name',
                      style: headerTextStyle,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      profile.forename + " " + profile.surname,
                      style: mainTextStyle,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      'Your email',
                      style: headerTextStyle,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Text(profile.email, style: mainTextStyle),
                  )
                ],
              )),
        ),
      ],
    );
  }
}
