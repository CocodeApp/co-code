import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'homePageData.dart';
import 'package:cocode/features/userProfile.dart/userProfile.dart' as profile;
import 'package:cocode/postIdeaForm.dart' as PostIdea;
import 'package:cocode/features/userProjects/myProjectsPage.dart';

import 'package:cocode/Auth.dart';
import 'package:cocode/LoginPage.dart';

class ProjectScreen extends StatefulWidget {
  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, //our tabs
      child: Scaffold(
        appBar: AppBar(
          // leading: Container(), no need for container here
          centerTitle: true,
          backgroundColor: Color(0xff2A4793),
          title: Text( "Explore",
           // style: TextStyle(color: Colors.deepOrangeAccent), chang it to orange ?
            textAlign: TextAlign.center,
          ),
          bottom: TabBar(
            labelColor: Colors.deepOrangeAccent,
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Colors.white),
            tabs: [
          Tab(
          child: Align(
          alignment: Alignment.center,
            child: Text("Need Team Member"),
          ),
        ), Tab(
        child: Align(
          alignment: Alignment.center,
          child: Text("Need Supervisor"),
        ),
      ),
        ]
          ),
        ),
        body: TabBarView(
          children: [needTeamMember(), needSupervisor()],
        ),
        floatingActionButton: FloatingActionButton(
          //for adding new Idea
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return PostIdea.PostIdeaFormPage(
                title: 'Post new idea',
              );
            }));
          },
          child: Icon(Icons.add),
          backgroundColor: Color(0xffF57862),
        ),
      ),
    );
  }
}

//   SizedBox(
//             width: 60,
//             child: RaisedButton(
//               child: Text('logout'),
//               textColor: Colors.white,
//               color: Color(0xffF57862),
//               onPressed: () async {
//                 await Auth.logout();

//                 Navigator.push(context, MaterialPageRoute(builder: (_) {
//                   return LoginPage();
//                 }));
//               },
//             ),
//           ),

//       }),
//     );
//   }
// }
