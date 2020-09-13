import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import "LoginPage.dart";
import 'postIdeaForm.dart';
import 'Auth.dart';

Future<void> main() async {
  //https://stackoverflow.com/questions/54469191/persist-user-auth-flutter-firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: await Auth.directoryPage(),
  ));
}
