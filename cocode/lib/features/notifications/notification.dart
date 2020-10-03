import 'package:flutter/material.dart';
import 'package:cocode/Auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kf_drawer/kf_drawer.dart';

class notification extends KFDrawerContent {
  @override
  _notificationState createState() => _notificationState();
}

class _notificationState extends State<notification> {
  @override
  Widget build(BuildContext context) {
    String email = Auth.getCurrentUserEmail();
    String userName = Auth.getCurrentUsername();
    String ID = Auth.getCurrentUserID();
    String firstName = '';
    String lastName = '';
    String major = '';
    String university = '';
    CollectionReference users = FirebaseFirestore.instance.collection('User');

    return Container();
  }
}
