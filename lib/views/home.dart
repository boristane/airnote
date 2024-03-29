import 'package:airnote/utils/colors.dart';
import 'package:airnote/views/create-entry/entry-type.dart';
import 'package:airnote/views/drawer.dart';
import 'package:airnote/views/entries-list.dart';
import 'package:airnote/views/quests-list.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  static const routeName = 'home';

  final FirebaseAnalytics analytics;
  Home({Key key, this.analytics})
      : super(key: key);
  @override
  _HomeState createState() => _HomeState(analytics);
}

class _HomeState extends State<Home> {
  _HomeState(this.analytics);
  final FirebaseAnalytics analytics;
  
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
  void didChangeDependencies() {
    final id = ModalRoute.of(context).settings.arguments;
    if(id != null){
      setState(() {
        _currentIndex = id;
      });
    }
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard, color:_getColor(0),),
            title: Text("Quests", style: TextStyle(color: _getColor(0)),),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book, color:_getColor(1),),
            title: Text("Entries", style: TextStyle(color: _getColor(1)),),
          ),
        ],
        onTap: _onBottomNavTapped,
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: AirnoteColors.primary,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(SelectEntryType.routeName);
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: IndexedStack(
        children: <Widget>[
          QuestsList(),
          EntriesList(),
        ],
        index: _currentIndex,
      ),
      drawer: Drawer(
        child: AirnoteDrawer(),),
    );
  }
}
