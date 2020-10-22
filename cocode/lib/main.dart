import 'package:cocode/features/addEvents/addeventsView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Auth.dart';
import 'features/addEvents/addEvent.dart';

Future<void> main() async {
  //https://stackoverflow.com/questions/54469191/persist-user-auth-flutter-firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'Open Sans'),
    // home: await Auth.directoryPage(),
    home: signIn(),
  ));
}

// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs
