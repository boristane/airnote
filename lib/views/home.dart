import 'package:airnote/utils/colors.dart';
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _currentIndex == 0 ? AirnoteColors.primary : AirnoteColors.inactive,),
            title: Text("Home", style: TextStyle(color: _currentIndex == 0 ? AirnoteColors.primary : AirnoteColors.inactive),),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: _currentIndex == 1 ? AirnoteColors.primary : AirnoteColors.inactive,),
            title: Text("Profile", style: TextStyle(color: _currentIndex == 1 ? AirnoteColors.primary : AirnoteColors.inactive),),
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
            // Navigator.of(context).push(SlideUpRoute(widget: AddEntry())),
            print("Clicked add");
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
