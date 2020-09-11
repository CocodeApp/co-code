import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import "LoginPage.dart";
import 'postIdeaForm.dart';

void main() async {
  //wait until
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}
