import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'projectsCardData.dart';
import 'package:cocode/features/userProfile.dart/userProfile.dart' as profile;
import 'package:cocode/features/postIdea/postIdeaForm.dart' as PostIdea;
import 'package:cocode/features/userProjects/myProjectsPage.dart';

import 'package:cocode/Auth.dart';
import 'package:cocode/features/Login/LoginPage.dart';
import 'package:kf_drawer/kf_drawer.dart';

class ProjectScreen extends KFDrawerContent {
  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, //our tabs
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            bottom: TabBar(
              indicatorColor: Color(0xffF57862),
              tabs: [
                Tab(
                  child: Text("need team member",
                      style: TextStyle(color: Color(0xff2A4793))),
                  // text: "need team member",
                ),
                Tab(
                  child: Text("need supervisor",
                      style: TextStyle(color: Color(0xff2A4793))),
                )
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [needTeamMember(), needSupervisor()],
        ),
      ),
    );
  }
}
