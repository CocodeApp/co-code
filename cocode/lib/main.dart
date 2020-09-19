import 'package:cocode/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import "LoginPage.dart";
import 'features/homePage/projectScreen.dart';
import 'features/homePage/homePage.dart';
import 'Auth.dart';
import 'features/viewProject/teamMembersData.dart';
import 'features/viewProject/teamMembers.dart';
import 'features/viewProject/viewProject.dart';

Future<void> main() async {
  //https://stackoverflow.com/questions/54469191/persist-user-auth-flutter-firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new MaterialApp(
    home: homePage(),
    //home: await Auth.directoryPage(),
  ));
}
