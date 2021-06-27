import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movie_app/Screens/DashBoard/HomePage.dart';
import 'package:movie_app/Screens/favorite/FavoriteScreen.dart';
import 'package:movie_app/Screens/profile/ProfileScreen.dart';
import 'package:movie_app/Screens/search/SearchScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),
    SearchScreen(),
    FavoriteScreen(),
    ProfileScreen()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    getSharedPrefs();
    super.initState();
  }

  getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("movies") == null || prefs.get('movies') == null) {
      final movies = [];
      prefs.setString("movies", jsonEncode(movies));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepOrange,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.blueGrey,
        onTap: onTabTapped,
        // new
        currentIndex: _currentIndex,
        // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Find',
          ),
          new BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              size: 30,
            ),
            label: 'Favorites',
          ),
          new BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 30,
            ),
            label: 'My Profile',
          )
        ],
      ),
    );
  }
}
