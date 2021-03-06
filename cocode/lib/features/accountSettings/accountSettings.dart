import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cocode/features/NotificationHandler/notificationsHandler.dart';
import 'package:cocode/features/notifications/notificationSettings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kf_drawer/kf_drawer.dart';

import '../../Auth.dart';
import 'AccountInfo.dart';
import 'changeEmail.dart';
import 'changeName.dart';
import 'changeUsername.dart';

class CommonThings {
  static Size size;
}

//Storing Account Info
class settingsPage extends KFDrawerContent {
  @override
  _settingsPageState createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {
  String username;
  String displayName;
  String email;
  String password;
  String firstname;
  String lastname;
  bool isLoading;

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  StreamSubscription iosSubscription;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigo,
        title: Text(
          "Account Settings",
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.deepOrangeAccent,
          ),
          onPressed: widget.onMenuPressed,
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: Auth.getcurrentUserInfo(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data.data();
            AccountInfo.username = this.username = data['userName'];
            AccountInfo.email = this.email = data['email'];
            AccountInfo.firstname = this.firstname = data['firstName'];
            AccountInfo.lastname = this.lastname = data['lastName'];
//MessageHandler
            return Scaffold(
                backgroundColor: Colors.white,
                body: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(
                      children: <Widget>[
                        Card(
                          child: ListTile(
                              leading: GestureDetector(
                                child: Hero(
                                    tag: 'username',
                                    child: CircleAvatar(
                                      backgroundColor: Colors.indigo,
                                      foregroundColor: Colors.white,
                                      radius: 20,
                                      child: Icon(
                                        Icons.alternate_email,
                                        color: Colors.white,
                                        size: 30.0,
                                      ),
                                    )),
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return ChangeUsername();
                                  }));
                                },
                              ),
                              dense: false,
                              title: Text('Username',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.grey)),
                              subtitle: Text(this.username,
                                  style: TextStyle(
                                      fontSize: 17.0, color: Colors.black87)),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          new ChangeUsername()),
                                ).then((value) {
                                  setState(() {
                                    this.username = AccountInfo.username;
                                  });
                                });
                              }),
                        ),
                        Card(
                          child: ListTile(
                            leading: GestureDetector(
                              child: Hero(
                                tag: 'name',
                                child: CircleAvatar(
                                  backgroundColor: Colors.indigo,
                                  child: Icon(
                                    Icons.face,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return ChangeName();
                                }));
                              },
                            ),
                            dense: false,
                            title: Text('Name',
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.grey)),
                            subtitle: Text(this.firstname + " " + this.lastname,
                                style: TextStyle(
                                    fontSize: 17.0, color: Colors.black87)),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new ChangeName()),
                              ).then((value) {
                                setState(() {
                                  this.firstname = AccountInfo.firstname;
                                  this.lastname = AccountInfo.lastname;
                                });
                              });
                            },
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: GestureDetector(
                              child: Hero(
                                  tag: 'email',
                                  child: CircleAvatar(
                                    backgroundColor: Colors.indigo,
                                    child: Icon(
                                      Icons.mail_outline,
                                      color: Colors.white,
                                      size: 30.0,
                                    ),
                                    foregroundColor: Colors.white,
                                  )),
                            ),
                            dense: false,
                            title: Text('Email',
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.grey)),
                            subtitle: Text(AccountInfo.email,
                                style: TextStyle(
                                    fontSize: 17.0, color: Colors.black87)),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new ChangeEmail()),
                              ).then((value) {
                                setState(() {
                                  this.email = AccountInfo.email;
                                });
                              });
                            },
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: GestureDetector(
                              child: Hero(
                                  tag: 'password',
                                  child: CircleAvatar(
                                    backgroundColor: Colors.indigo,
                                    child: Icon(
                                      Icons.vpn_key,
                                      color: Colors.white,
                                      size: 30.0,
                                    ),
                                    foregroundColor: Colors.white,
                                  )),
                            ),
                            dense: false,
                            title: Text('Change Password',
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.grey)),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () async {
                              setState(() {
                                isLoading = true;
                              });

                              try {
                                await Auth.resetPassword(
                                        Auth.getCurrentUserEmail())
                                    .then((void nothing) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                });

                                showDialog(
                                    context: context,
                                    builder: (context) => Center(
                                        child: SingleChildScrollView(
                                            child: Card(
                                                child: Container(
                                                    width: 300,
                                                    height: 250,
                                                    padding:
                                                        EdgeInsets.all(12.0),
                                                    child: isLoading
                                                        ? Center(
                                                            child: Card(
                                                              child: Container(
                                                                width: 80,
                                                                height: 80,
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            12.0),
                                                                child:
                                                                    CircularProgressIndicator(),
                                                              ),
                                                            ),
                                                          )
                                                        : Center(
                                                            child: Column(
                                                                children: <
                                                                    Widget>[
                                                                SizedBox(
                                                                    height: 20),
                                                                Icon(
                                                                  Icons.vpn_key,
                                                                  color: Colors
                                                                      .indigo,
                                                                  size: 50.0,
                                                                ),
                                                                SizedBox(
                                                                    height: 20),
                                                                Center(
                                                                    child: Text(
                                                                        "Reset Password",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.grey[800],
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 20))),
                                                                SizedBox(
                                                                    height: 10),
                                                                Center(
                                                                    child: Text(
                                                                        "Check your email for password reset link")),
                                                                SizedBox(
                                                                    height: 10),
                                                                WillPopScope(
                                                                    onWillPop:
                                                                        () async =>
                                                                            false,
                                                                    child: Container(
                                                                        child: Center(
                                                                            child: Column(children: <Widget>[
                                                                      OutlineButton(
                                                                        textColor:
                                                                            Colors.indigo,
                                                                        highlightedBorderColor: Colors
                                                                            .black
                                                                            .withOpacity(0.12),
                                                                        onPressed:
                                                                            Navigator.of(context).pop,
                                                                        child: Text(
                                                                            "OK"),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              10),
                                                                    ]))))
                                                              ])))))));
                              } catch (e) {
                                String err = Auth.AuthErrorMessage(e);
                                Fluttertoast.showToast(
                                    msg: err,
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.indigo,
                                    textColor: Colors.white,
                                    fontSize: 16.0);

                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: GestureDetector(
                              child: Hero(
                                  tag: 'Notifications',
                                  child: CircleAvatar(
                                    backgroundColor: Colors.indigo,
                                    child: Icon(
                                      Icons.notifications_active,
                                      color: Colors.white,
                                      size: 30.0,
                                    ),
                                    foregroundColor: Colors.white,
                                  )),
                            ),
                            dense: false,
                            title: Text('Notifications',
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.grey)),
                            // subtitle: Text(AccountInfo.email,
                            //     style: TextStyle(
                            //         fontSize: 17.0, color: Colors.black87)),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        new noticationSettings()),
                              );
                            },
                          ),
                        ),
                      ],
                    )));
          } else if (!snapshot.hasData)
            return Center(
              child: Card(
                child: Container(
                  width: 80,
                  height: 80,
                  padding: EdgeInsets.all(12.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          else
            return Center(
              child: Card(
                child: Container(
                  width: 80,
                  height: 80,
                  padding: EdgeInsets.all(12.0),
                  child: Text("Oops.. no data!"),
                ),
              ),
            );
        },
      ),
    );
  }
}
