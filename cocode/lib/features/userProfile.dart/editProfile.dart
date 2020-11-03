import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocode/buttons/RoundeButton.dart';
import 'package:cocode/features/userProfile.dart/changeBio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_bloc/form_bloc.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'dart:async';
import 'package:cocode/features/accountSettings/AccountInfo.dart';

import '../../Auth.dart';

class CommonThings {
  static Size size;
}

//Storing Account Info
class editProfile extends KFDrawerContent {
  @override
  _editProfileState createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  String bio;

  bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  Widget build(BuildContext context) {
    String id = Auth.getCurrentUserID();
    CollectionReference users = FirebaseFirestore.instance.collection('User');

    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigo,
        title: Text(
          "Edit Profile",
          textAlign: TextAlign.center,
        ),
        leading: BackButton(
          color: Colors.deepOrangeAccent,
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(id).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data.data();
            AccountInfo.bio = this.bio = data['bio'];

            return Scaffold(
                backgroundColor: Colors.white,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
               Expanded(
                 child: Container(
                  decoration: BoxDecoration(
                  color: Colors.blueAccent[400],
                  borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                  ),
                ),
                   child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.white70,
                    radius: 65,
                    child: FlatButton(
                      //onPressed: callback,
                      child: Icon(
                        Icons.add,
                        size:
                        0.055 * MediaQuery.of(context).size.height,
                      ),
                    ),
                  ),
                  Text("Change your profile image here",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
          Expanded(
          flex: 2,
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(
                      children: <Widget>[
                        Card(
                          child: ListTile(
                              leading: GestureDetector(
                                child: Hero(
                                    tag: 'bio',
                                    child: CircleAvatar(
                                      backgroundColor: Colors.indigo,
                                      foregroundColor: Colors.white,
                                      radius: 20,
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 30.0,
                                      ),
                                    )),
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return changeBio();
                                  }));
                                },
                              ),
                              dense: false,
                              title: Text('Bio',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.grey)),
                              subtitle: Text(this.bio,
                                  style: TextStyle(
                                      fontSize: 17.0, color: Colors.black87)),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new changeBio()),
                                ).then((value) {
                                  setState(() {
                                    this.bio = AccountInfo.username;
                                  });
                                });
                              }),
                        ),
                        // Card(
                        //   child: ListTile(
                        //     leading: GestureDetector(
                        //       child: Hero(
                        //         tag: 'name',
                        //         child: CircleAvatar(
                        //           backgroundColor: Colors.indigo,
                        //           child: Icon(
                        //             Icons.face,
                        //             color: Colors.white,
                        //             size: 30.0,
                        //           ),
                        //           foregroundColor: Colors.white,
                        //         ),
                        //       ),
                        //       onTap: () {
                        //         Navigator.push(context,
                        //             MaterialPageRoute(builder: (_) {
                        //           return ChangeName();
                        //         }));
                        //       },
                        //     ),
                        //     dense: false,
                        //     title: Text('Name',
                        //         style: TextStyle(
                        //             fontSize: 14.0, color: Colors.grey)),
                        //     subtitle: Text(this.firstname + " " + this.lastname,
                        //         style: TextStyle(
                        //             fontSize: 17.0, color: Colors.black87)),
                        //     trailing: Icon(Icons.keyboard_arrow_right),
                        //     onTap: () {
                        //       Navigator.push(
                        //         context,
                        //         new MaterialPageRoute(
                        //             builder: (context) => new ChangeName()),
                        //       ).then((value) {
                        //         setState(() {
                        //           this.firstname = AccountInfo.firstname;
                        //           this.lastname = AccountInfo.lastname;
                        //         });
                        //       });
                        //     },
                        //   ),
                        // ),
                        // Card(
                        //   child: ListTile(
                        //     leading: GestureDetector(
                        //       child: Hero(
                        //           tag: 'email',
                        //           child: CircleAvatar(
                        //             backgroundColor: Colors.indigo,
                        //             child: Icon(
                        //               Icons.mail_outline,
                        //               color: Colors.white,
                        //               size: 30.0,
                        //             ),
                        //             foregroundColor: Colors.white,
                        //           )),
                        //     ),
                        //     dense: false,
                        //     title: Text('Email',
                        //         style: TextStyle(
                        //             fontSize: 14.0, color: Colors.grey)),
                        //     subtitle: Text(AccountInfo.email,
                        //         style: TextStyle(
                        //             fontSize: 17.0, color: Colors.black87)),
                        //     trailing: Icon(Icons.keyboard_arrow_right),
                        //     onTap: () {
                        //       Navigator.push(
                        //         context,
                        //         new MaterialPageRoute(
                        //             builder: (context) => new ChangeEmail()),
                        //       ).then((value) {
                        //         setState(() {
                        //           this.email = AccountInfo.email;
                        //         });
                        //       });
                        //     },
                        //   ),
                        // ),
                        // Card(
                        //   child: ListTile(
                        //     leading: GestureDetector(
                        //       child: Hero(
                        //           tag: 'password',
                        //           child: CircleAvatar(
                        //             backgroundColor: Colors.indigo,
                        //             child: Icon(
                        //               Icons.vpn_key,
                        //               color: Colors.white,
                        //               size: 30.0,
                        //             ),
                        //             foregroundColor: Colors.white,
                        //           )),
                        //     ),
                        //     dense: false,
                        //     title: Text('Change Password',
                        //         style: TextStyle(
                        //             fontSize: 14.0, color: Colors.grey)),
                        //     trailing: Icon(Icons.keyboard_arrow_right),
                        //     onTap: () async {
                        //       setState(() {
                        //         isLoading = true;
                        //       });

                        //       try {
                        //         await Auth.resetPassword(
                        //                 Auth.getCurrentUserEmail())
                        //             .then((void nothing) {
                        //           setState(() {
                        //             isLoading = false;
                        //           });
                        //         });

                        //         showDialog(
                        //             context: context,
                        //             builder: (context) => Center(
                        //                 child: SingleChildScrollView(
                        //                     child: Card(
                        //                         child: Container(
                        //                             width: 300,
                        //                             height: 250,
                        //                             padding:
                        //                                 EdgeInsets.all(12.0),
                        //                             child: isLoading
                        //                                 ? Center(
                        //                                     child: Card(
                        //                                       child: Container(
                        //                                         width: 80,
                        //                                         height: 80,
                        //                                         padding:
                        //                                             EdgeInsets
                        //                                                 .all(
                        //                                                     12.0),
                        //                                         child:
                        //                                             CircularProgressIndicator(),
                        //                                       ),
                        //                                     ),
                        //                                   )
                        //                                 : Center(
                        //                                     child: Column(
                        //                                         children: <
                        //                                             Widget>[
                        //                                         SizedBox(
                        //                                             height: 20),
                        //                                         Icon(
                        //                                           Icons.vpn_key,
                        //                                           color: Colors
                        //                                               .indigo,
                        //                                           size: 50.0,
                        //                                         ),
                        //                                         SizedBox(
                        //                                             height: 20),
                        //                                         Center(
                        //                                             child: Text(
                        //                                                 "Reset Password",
                        //                                                 style: TextStyle(
                        //                                                     color:
                        //                                                         Colors.grey[800],
                        //                                                     fontWeight: FontWeight.bold,
                        //                                                     fontSize: 20))),
                        //                                         SizedBox(
                        //                                             height: 10),
                        //                                         Center(
                        //                                             child: Text(
                        //                                                 "Check your email for password reset link")),
                        //                                         SizedBox(
                        //                                             height: 10),
                        //                                         WillPopScope(
                        //                                             onWillPop:
                        //                                                 () async =>
                        //                                                     false,
                        //                                             child: Container(
                        //                                                 child: Center(
                        //                                                     child: Column(children: <Widget>[
                        //                                               OutlineButton(
                        //                                                 textColor:
                        //                                                     Colors.indigo,
                        //                                                 highlightedBorderColor: Colors
                        //                                                     .black
                        //                                                     .withOpacity(0.12),
                        //                                                 onPressed:
                        //                                                     Navigator.of(context).pop,
                        //                                                 child: Text(
                        //                                                     "OK"),
                        //                                               ),
                        //                                               SizedBox(
                        //                                                   height:
                        //                                                       10),
                        //                                             ]))))
                        //                                       ])))))));
                        //       } catch (e) {
                        //         String err = Auth.AuthErrorMessage(e);
                        //         Fluttertoast.showToast(
                        //             msg: err,
                        //             toastLength: Toast.LENGTH_LONG,
                        //             gravity: ToastGravity.TOP,
                        //             timeInSecForIosWeb: 1,
                        //             backgroundColor: Colors.indigo,
                        //             textColor: Colors.white,
                        //             fontSize: 16.0);

                        //         setState(() {
                        //           isLoading = false;
                        //         });
                        //       }
                        //     },
                        //   ),
                        // ),
                      ],
                    )))]));
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
