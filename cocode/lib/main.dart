import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'features/Login/LoginPage.dart';
import 'features/homePage/projectScreen.dart';
import 'features/homePage/homePage.dart';
import 'Auth.dart';
import 'features/viewProject/teamMembersData.dart';
import 'features/viewProject/teamMembers.dart';
import 'features/viewProject/viewProject.dart';
import 'package:cocode/features/homePage/drawer.dart' as drawer;

Future<void> main() async {
  //https://stackoverflow.com/questions/54469191/persist-user-auth-flutter-firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    // home: await Auth.directoryPage(),
    home: drawer.homePage(),
  ));
}
