import 'package:flutter/material.dart';
import 'package:windmill_assignment/screens/favourites_screen.dart';
import 'package:windmill_assignment/screens/home_screen.dart';

class BottomBarPage extends StatefulWidget {
  BottomBarPage({Key key}) : super(key: key);

  @override
  _BottomBarPageState createState() => _BottomBarPageState();
}

class _BottomBarPageState extends State<BottomBarPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [HomeScreen(), FavouriteScreen()];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 20,
        backgroundColor: Colors.grey[900],
        currentIndex: 0,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _currentIndex == 0 ? Colors.yellowAccent : Colors.white,
            ),
            title: Text(
              'Home',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.mail,
              color: _currentIndex == 1 ? Colors.yellowAccent : Colors.white,
            ),
            title: Text(
              'Messages',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
      body: _children[_currentIndex],
    );
  }
}
