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
          backgroundColor: Color(0xff2A4793),
          title: Text(
            'Explore',
            textAlign: TextAlign.center,
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                text: "need team member",
              ),
              Tab(
                text: 'need subervisor',
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [needTeamMember(), needSupervisor()],
        ),
        floatingActionButton: FloatingActionButton(
          //for adding new Idea
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return PostIdea.PostIdeaFormPage();
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
