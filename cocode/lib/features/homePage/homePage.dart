import 'package:flutter/material.dart';
import 'projectScreen.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:cocode/features/postIdea/postIdeaForm.dart' as PostIdea;
import 'package:cocode/features/notifications/notification.dart';
import 'package:animations/animations.dart';
import 'package:kf_drawer/kf_drawer.dart';

class homePage extends KFDrawerContent {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  int _currentIndex = 0;

  PageController _pageController = new PageController();
  List<Widget> _screens = [ProjectScreen(), notification()];
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
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Text(
            _currentIndex == 0
                ? 'Explore'
                : _currentIndex == 1 ? 'Notifications' : '',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onPressed: widget.onMenuPressed,
          ),
        ),
        floatingActionButton: OpenContainer(
          closedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(27.0))),
          transitionDuration: Duration(milliseconds: 800),
          closedBuilder: (context, action) {
            return FloatingActionButton(
              //for adding new Idea
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              backgroundColor: Color(0xFFC2D8FD),
            );
          },
          openBuilder: (context, action) {
            return PostIdea.PostIdeaFormPage(
              title: 'Post new idea',
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: PageView(
          controller: _pageController,
          children: _screens,
          onPageChanged: _onPageChanged,
        ),
        bottomNavigationBar: ConvexAppBar(
          style: TabStyle.flip,
          backgroundColor: Color(0xff2A4793),
          color: Colors.white,
          activeColor: Colors.white,
          onTap: _onItemTapped,
          items: [
            TabItem(
                icon: Icon(
                  Icons.home,
                  color: Color(0xffF57862),
                ),
                title: 'Explore'),
            TabItem(
                icon: Icon(
                  Icons.notifications,
                  color: Color(0xffF57862),
                ),
                title: 'notifications')
          ],
        ));
  }
}
