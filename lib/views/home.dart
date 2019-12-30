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
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
          ),
        ],
        onTap: _onBottomNavTapped,
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF3C4858),
          child: Icon(Icons.add),
          onPressed: () {
            // Navigator.of(context).push(SlideUpRoute(widget: AddEntry())),
            print("Clicked home");
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Text("Home"),
          ),
        ),
      ),
    );
  }
}
