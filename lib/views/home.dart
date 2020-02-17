import 'package:airnote/utils/colors.dart';
import 'package:airnote/views/create-entry/intro.dart';
import 'package:airnote/views/entries-list.dart';
import 'package:airnote/views/profile.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  static const routeName = 'home';
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  _getColor(int index) {
    return _currentIndex == index ? AirnoteColors.primary : AirnoteColors.inactive;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book, color:_getColor(0),),
            title: Text("Entries", style: TextStyle(color: _getColor(0)),),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.face, color: _getColor(1),),
            title: Text("Profile", style: TextStyle(color:_getColor(1)),),
          ),
        ],
        onTap: _onBottomNavTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: AirnoteColors.primary,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(CreateEntryIntro.routeName);
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: IndexedStack(
        children: <Widget>[
          EntriesList(),
          Profile(),
        ],
        index: _currentIndex,
      )
    );
  }
}
