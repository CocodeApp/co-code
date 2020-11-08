import 'package:circular_check_box/circular_check_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cocode/features/NotificationHandler/notificationsHandler.dart';
import 'package:cocode/features/accountSettings/changeName.dart';
import 'package:cocode/features/accountSettings/changeUsername.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'dart:async';

import '../../Auth.dart';
import 'NotificationData.dart';

class CommonThings {
  static Size size;
}

//Storing Account Info
class noticationSettings extends KFDrawerContent {
  @override
  _noticationSettingsState createState() => _noticationSettingsState();
}

class _noticationSettingsState extends State<noticationSettings> {
  bool isLoading;
  bool projectSubscription;

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  StreamSubscription iosSubscription;

  @override
  void initState() {
    super.initState();
    projectSubscription = NotificationSettings.newProjects == null
        ? false
        : NotificationSettings.newProjects;
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.indigo,
          title: Text(
            "Nofication Settings",
            textAlign: TextAlign.center,
          ),
        ),
        body: Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 2),
                    Container(
                        padding: EdgeInsets.all(12.0),
                        child: Text('Notify me about.. ',
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.grey))),
                    SizedBox(height: 2),
                    Card(
                      child: ListTile(
                        leading: CircularCheckBox(
                            value: projectSubscription,
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            checkColor: Colors.white,
                            activeColor: Colors.green,
                            inactiveColor: Colors.grey,
                            disabledColor: Colors.grey,
                            onChanged: (newValue) {
                              setState(() {
                                NotificationSettings.newProjects =
                                    projectSubscription = newValue;
                                newValue
                                    ? _fcm.subscribeToTopic('projs')
                                    : _fcm.unsubscribeFromTopic('projs');
                              });
                            }),
                        title: Text("New Projects posted"),
                      ),
                    ),
                  ],
                ))));
  }
}
