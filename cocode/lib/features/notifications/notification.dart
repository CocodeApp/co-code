import 'package:flutter/material.dart';
import 'package:cocode/Auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kf_drawer/kf_drawer.dart';

import 'notificationSettings.dart';

class notification extends KFDrawerContent {
  @override
  _notificationState createState() => _notificationState();
}

class _notificationState extends State<notification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            centerTitle: false,
            titleSpacing: 0.0,
            elevation: 0.0,
            backgroundColor: Colors.white,
            title: Transform(
                // you can forcefully translate values left side using Transform
                transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Latest',
                          style: TextStyle(color: Colors.grey[400]),
                        )),
                    IconButton(
                      icon: Icon(
                        Icons.settings,
                        color: Colors.grey[400],
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return noticationSettings();
                        }));
                      },
                    ),
                  ],
                ))));
    //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
    ///noticationSettings
  }
}
