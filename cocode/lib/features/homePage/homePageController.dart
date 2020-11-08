import 'dart:async';
import 'package:cocode/Auth.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:googleapis/storage/v1.dart';
import 'projectScreen.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:cocode/features/postIdea/postIdeaForm.dart' as PostIdea;
import 'package:cocode/features/notifications/notification.dart';
import 'package:animations/animations.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class homePageController extends KFDrawerContent {
  @override
  _homePageControllerState createState() => _homePageControllerState();
}

class _homePageControllerState extends State<homePageController> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  StreamSubscription iosSubscription;

  void initState() {
    super.initState();
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        // save the token  OR subscribe to a topic here
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        addNoti(message['notification']['title'], message['notification']['body']);
        //increment badge

        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
        return;
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        return;
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        return;
      },
    );
  }

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

  void addNoti(String title, String body){
    CollectionReference users = FirebaseFirestore.instance.collection('User');
    String user = Auth.getCurrentUserID();
    users.doc(user).collection('notifications').add({
      'title' : title,
      'body' : body,
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Text(
            _currentIndex == 0
                ? 'Explore'
                : _currentIndex == 1
                    ? 'Notifications'
                    : '',
            style: TextStyle(color: Colors.indigo),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.deepOrangeAccent,
            ),
            onPressed: widget.onMenuPressed,
          ),
        ),
        floatingActionButton: OpenContainer(
          closedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(27.0))),
          transitionDuration: Duration(milliseconds: 600),
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
