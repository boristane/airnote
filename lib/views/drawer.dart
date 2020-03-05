import 'package:airnote/components/loading.dart';
import 'package:airnote/view-models/base.dart';
import 'package:airnote/view-models/user.dart';
import 'package:airnote/views/root.dart';
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

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ListView(
                shrinkWrap: true,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountEmail: Text(profile.email),
                    accountName: Text("${profile.forename} ${profile.surname}"),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://img00.deviantart.net/35f0/i/2015/018/2/6/low_poly_landscape__the_river_cut_by_bv_designs-d8eib00.jpg"),
                            fit: BoxFit.fill)),
                  ),
                  ListTile(
                      title: Text("Settings"),
                      leading: Icon(Icons.settings),
                      onTap: () {
                        print("page 1");
                      }),
                  ListTile(
                      title: Text("Payment Details"),
                      leading: Icon(Icons.credit_card),
                      onTap: () {
                        print("page two");
                      }),
                ],
              ),
              Column(
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
              ),
            ],
          );
        },
      ),
    ));
  }
}
