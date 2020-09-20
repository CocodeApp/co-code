import 'package:flutter/material.dart';
import 'projectScreen.dart';
import 'package:cocode/features/userProjects/myProjectsPage.dart';
import 'package:cocode/features/userProfile.dart/userProfile.dart';

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  int _currentIndex = 0;
  PageController _pageController = new PageController();
  List<Widget> _screens = [userProjects(), ProjectScreen(), profilePage()];
  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: _pageController,
          children: _screens,
          onPageChanged: _onPageChanged,
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _onItemTapped,
          selectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.work,
                color: _currentIndex == 0 ? Color(0xff2A4793) : null,
              ),
              title: Text(
                'my projects',
                style: TextStyle(
                  color: _currentIndex == 0 ? Color(0xff2A4793) : null,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _currentIndex == 1 ? Color(0xff2A4793) : null,
              ),
              title: Text(
                'home',
                style: TextStyle(
                    color: _currentIndex == 1 ? Color(0xff2A4793) : null),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: _currentIndex == 2 ? Color(0xff2A4793) : null,
              ),
              title: Text(
                'profile',
                style: TextStyle(
                    color: _currentIndex == 0 ? Color(0xff2A4793) : null),
              ),
            ),
          ],
        ));
  }
}
