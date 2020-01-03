import 'package:airnote/components/loading.dart';
import 'package:airnote/models/user.dart';
import 'package:airnote/view-models/base.dart';
import 'package:airnote/view-models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User _profile;
  UserViewModel _userViewModel;
  
  @override
  void didChangeDependencies() {
    final userViewModel = Provider.of<UserViewModel>(context);
    super.didChangeDependencies();
    if(this._userViewModel == userViewModel) {
      return;
    }
    this._userViewModel = userViewModel;
    Future.microtask(this._userViewModel.getUser);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Consumer<UserViewModel>(
          builder: (context, model, child) {
            if (model.getStatus() == ViewStatus.LOADING)
            {
              return AirnoteLoadingScreen();
            }
            _profile = model.user;
            return Text("${_profile}");
          },
        ),
      )
    );
  }
}