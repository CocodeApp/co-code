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
  List<Widget> screens = [needTeamMember(), needSupervisor()];
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
            backgroundColor: Colors.indigo,
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
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Need Supervisor"),
                    ),
                  ),
                ]),
          ),
        ),
        body: TabBarView(
          children: screens,
        ),
      ),
    );
  }
}

// leading: Container(), no need for container here
