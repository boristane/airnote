import 'dart:io' show Platform;

import 'package:airnote/components/loading.dart';
import 'package:airnote/utils/colors.dart';
import 'package:airnote/view-models/base.dart';
import 'package:airnote/view-models/user.dart';
import 'package:airnote/views/root.dart';
import 'package:airnote/views/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AirnoteDrawer extends StatefulWidget {
  @override
  _AirnoteDrawerState createState() => _AirnoteDrawerState();
}

class _AirnoteDrawerState extends State<AirnoteDrawer> {
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

  Widget getLogOutButton(UserViewModel model) {
    return Column(
      children: <Widget>[
        Divider(),
        ListTile(
          title: Text("Log out"),
          leading: Icon(Icons.power_settings_new),
          onTap: () {
            model.logout();
            Navigator.of(context).pushNamedAndRemoveUntil(
                Root.routeName, (Route<dynamic> route) => false);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Container(
      child: Consumer<UserViewModel>(
        builder: (context, model, child) {
          if (model.getStatus() == ViewStatus.LOADING) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(child: AirnoteLoadingScreen()),
                getLogOutButton(model),
              ],
            );
          }
          final profile = model.user;
          if (profile == null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                    child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  alignment: Alignment.center,
                  child:
                      Text("Ooops ! There was a problem getting the data..."),
                )),
                getLogOutButton(model),
              ],
            );
          }
          final storeName = Platform.isAndroid ? "Play Store" : "App Store";
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ListView(
                shrinkWrap: true,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text(
                      "${profile.forename} ${profile.surname}",
                      style: TextStyle(color: AirnoteColors.grey),
                    ),
                    accountEmail: Text(
                      profile.email,
                      style: TextStyle(color: AirnoteColors.grey),
                    ),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/placeholder.png"),
                            fit: BoxFit.fill)),
                  ),
                  ListTile(
                      title: Text("Settings and Privacy"),
                      leading: Icon(Icons.settings),
                      onTap: () {
                        Navigator.of(context)
                          ..pop()
                          ..pushNamed(SettingsView.routeName);
                      }),
                  ListTile(
                      title: Text("Review on $storeName"),
                      leading: Icon(Icons.store),
                      onTap: () {
                        print("Review on $storeName");
                      }),
                ],
              ),
              getLogOutButton(model),
            ],
          );
        },
      ),
    ));
  }
}
