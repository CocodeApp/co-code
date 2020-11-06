import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Auth.dart';

class MessageHandlerx extends StatefulWidget {
  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandlerx> {
  // final FirebaseFirestore _db = FirebaseFirestore.instance;
  // final FirebaseMessaging _fcm = FirebaseMessaging();

  // StreamSubscription iosSubscription;

  @override
  void initState() {
    super.initState();
    // if (Platform.isIOS) {
    //   iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
    //     // save the token  OR subscribe to a topic here
    //   });

    //   _fcm.requestNotificationPermissions(IosNotificationSettings());
    // }

    // _fcm.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage");
    //     showDialog(
    //       context: context,
    //       builder: (context) => AlertDialog(
    //         content: ListTile(
    //           title: Text(message['data']['title']),
    //           subtitle: Text(message['data']['body']),
    //         ),
    //         actions: <Widget>[
    //           FlatButton(
    //             child: Text('Ok'),
    //             onPressed: () => Navigator.of(context).pop(),
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //     // TODO optional
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //     // TODO optional
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(appBar: AppBar(title: Text("hi")), body: Text("hello"));
  }

  // _saveDeviceToken() async {
  //   // Get the current user
  //   String uid = Auth.getCurrentUserID();
  //   // FirebaseUser user = await _auth.currentUser();

  //   // Get the token for this device
  //   String fcmToken = await _fcm.getToken();

  //   // Save it to Firestore
  //   if (fcmToken != null) {
  //     var tokens =
  //         _db.collection('User').doc(uid).collection('tokens').doc(fcmToken);

  //     await tokens.set({
  //       'token': fcmToken,
  //       'createdAt': FieldValue.serverTimestamp(), // optional
  //       'platform': Platform.operatingSystem // optional
  //     });
  //   }
  // }

  // TODO...

}
