import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocode/features/accountSettings/accountSettings.dart';
import 'package:flutter/material.dart';
import 'package:cocode/features/userProjects/myProjectsPage.dart';
import 'package:cocode/features/userProfile.dart/userProfile.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:cocode/Auth.dart';
import 'package:cocode/features/Login/LoginPage.dart';
import 'homePageController.dart';

//هذي الصفحة مسؤولة عن عرض المحتويات للهوم بيج .. تحتوي على المنيو الذي بدوره سيستدعي البيانات من الكنترولر لعرضها

class homePageView extends StatefulWidget {
  @override
  _homePageViewState createState() => _homePageViewState();
}

class _homePageViewState extends State<homePageView> {
  KFDrawerController _drawerController;

  @override
  void initState() {
    super.initState();
    _drawerController = KFDrawerController(
      items: [
        KFDrawerItem.initWithPage(
          text: Text('Explore', style: TextStyle(color: Colors.white)),
          icon: Icon(Icons.home, color: Colors.white),
          page: homePageController(),
        ),
        KFDrawerItem.initWithPage(
          text: Text('My profile', style: TextStyle(color: Colors.white)),
          icon: Icon(Icons.person, color: Colors.white),
          page: profilePage(userId: Auth.getCurrentUserID()),
        ),
        KFDrawerItem.initWithPage(
          text: Text('My projects', style: TextStyle(color: Colors.white)),
          icon: Icon(Icons.work, color: Colors.white),
          page: userProjects(),
        ),
        KFDrawerItem.initWithPage(
          text: Text('Settings', style: TextStyle(color: Colors.white)),
          icon: Icon(Icons.settings, color: Colors.white),
          page: settingsPage(),
        ),
      ],
      initialPage: homePageController(),
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
                  InkWell(child: userImg()),
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

  Widget userImg() {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("User")
          .doc(Auth.getCurrentUserID())
          .get(),
      builder: (context, snapshot) {
        if (snapshot.data == null) return Text('');

        Map<String, dynamic> data = snapshot.data.data();
        String imgUrl = data['image'];
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return CircleAvatar(
            backgroundImage: imgUrl == null
                ? new AssetImage("imeges/man.png")
                : NetworkImage(imgUrl),
            backgroundColor: Colors.white,
            radius: 40,
          );
        }
      },
    );
  }
}
