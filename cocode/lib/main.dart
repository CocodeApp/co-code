import 'package:cocode/features/addEvent.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Auth.dart';

Future<void> main() async {
  //https://stackoverflow.com/questions/54469191/persist-user-auth-flutter-firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'Open Sans'),
    home: await Auth.directoryPage(),
    // home: signIn(),
  ));
}
