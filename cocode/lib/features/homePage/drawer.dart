import 'package:flutter/material.dart';
import 'package:cocode/features/userProjects/myProjectsPage.dart';
import 'package:cocode/features/userProfile.dart/userProfile.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:cocode/Auth.dart';
import 'package:cocode/features/Login/LoginPage.dart';
import 'homePage.dart' as home;

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  KFDrawerController _drawerController;

  @override
  void initState() {
    super.initState();
    _drawerController = KFDrawerController(
      initialPage: home.homePage(),
      items: [
        KFDrawerItem.initWithPage(
          text: Text('Explore', style: TextStyle(color: Colors.white)),
          icon: Icon(Icons.home, color: Colors.white),
          page: home.homePage(),
        ),
        KFDrawerItem.initWithPage(
          text: Text('My profile', style: TextStyle(color: Colors.white)),
          icon: Icon(Icons.person, color: Colors.white),
          page: profilePage(),
        ),
        KFDrawerItem.initWithPage(
          text: Text('My projects', style: TextStyle(color: Colors.white)),
          icon: Icon(Icons.work, color: Colors.white),
          page: userProjects(),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: KFDrawer(
        shadowOffset: 0,
//        borderRadius: 0.0,
//        shadowBorderRadius: 0.0,
        // menuPadding: EdgeInsets.fromLTRB(0, 0, 0, 100.0),
//        scrollable: true,
        controller: _drawerController,
        header: Padding(
          padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Column(
                children: [
                  InkWell(
                    child: CircleAvatar(
                      backgroundImage: AssetImage("imeges/man.png"),
                      radius: 40,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    Auth.getCurrentUsername(),
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )
                ],
              ),
            ),
          ),
        ),
        footer: KFDrawerItem(
          text: Text(
            'Logout',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            await Auth.logout();

            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return LoginPage();
            }));
          },
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.fromRGBO(42, 71, 147, 1.0), Colors.black],
          ),
        ),
      ),
    );
  }
}
