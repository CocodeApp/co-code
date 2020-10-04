import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocode/features/welcomePage/Background.dart';
import 'package:cocode/features/Login/ForgotPassword.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cocode/Auth.dart';
import 'package:cocode/features/homePage/homePageView.dart';
import 'RegisterPage.dart';
import 'package:cocode/features/verifyEmail/VerifyEmail.dart';
import 'package:cocode/buttons/RoundeButton.dart';
import 'package:cocode/services/database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cocode/features/welcomePage/Background.dart';

class CommonThings {
  static Size size;
}

class AcademicInfoPage extends StatefulWidget {
  @override
  _AcademicInfoPageState createState() {
    return new _AcademicInfoPageState();
  }
}

class _AcademicInfoPageState extends State<AcademicInfoPage> {
  final _formKey = GlobalKey<FormState>();
  String university;
  String major;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    CommonThings.size = MediaQuery.of(context)
        .size; // this size provide us total height and width of screenSize

    return Scaffold(
        body: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("imeges/background.png"),
                  fit: BoxFit.cover),
            ),
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Form(
                    key: _formKey,
                    child: Center(
                        child: new Container(
                            height: CommonThings.size.height * 0.65,
                            width: 325,
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.2),
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 15.0,
                                  spreadRadius: 1.0,
                                )
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                    height: CommonThings.size.height * 0.03),
                                Center(
                                    child: Container(
                                  child: Text(
                                    'Now Let\'s Know more',
                                    style: TextStyle(
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                    textAlign: TextAlign.left,
                                  ),
                                )),
                                Center(
                                    child: Container(
                                  child: Text(
                                    'about your academic life..',
                                    style: TextStyle(
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                    textAlign: TextAlign.left,
                                  ),
                                )),
                                Container(
                                  width: 250.0,
                                  child: TextFormField(
                                    decoration: new InputDecoration(
                                      border: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red)),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.indigo, width: 2.0),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.indigo),
                                      ),
                                      disabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red)),
                                      errorBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red)),
                                      contentPadding: EdgeInsets.only(
                                          left: 15,
                                          bottom: 11,
                                          top: 11,
                                          right: 15),
                                      hintText: "Your university",
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        university = value;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                    height: CommonThings.size.height * 0.03),
                                Container(
                                  width: 250.0,
                                  child: TextFormField(
                                    decoration: new InputDecoration(
                                      border: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red)),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.indigo, width: 2.0),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.indigo),
                                      ),
                                      disabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red)),
                                      errorBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red)),
                                      contentPadding: EdgeInsets.only(
                                          left: 15,
                                          bottom: 11,
                                          top: 11,
                                          right: 15),
                                      hintText: "Your major",
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        major = value;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                    height: CommonThings.size.height * 0.03),
                                RoundedButton(
                                  text: "Next",
                                  textColor: Colors.white,
                                  press: () async {
                                    if (_formKey.currentState.validate()) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      // call login
                                      try {
                                        //await Auth.loginUser(email, password);
                                        String uID = Auth.getCurrentUserID();
                                        await FirebaseFirestore.instance
                                            .collection('User')
                                            .doc(uID)
                                            .update({
                                          'university': university,
                                          'major': major
                                        });
                                      } catch (e) {
                                        Fluttertoast.showToast(
                                            msg: "An error occured",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.blueAccent,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      }

                                      print("done");
                                      setState(() {
                                        isLoading = false;
                                      });

                                      if (Auth.isLoggedIn()) {
                                        if (Auth.isVerified()) {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                            return new homePageView();
                                          }));
                                        } else {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                            return new VerifyEmail();
                                          }));
                                        }
                                      }
                                    }
                                  },
                                ),
                                RoundedButton(
                                    text: "Skip",
                                    color: Colors.blue[100],
                                    textColor: Colors.black,
                                    press: () async {
                                      if (Auth.isLoggedIn()) {
                                        if (Auth.isVerified()) {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                            return new homePageView();
                                          }));
                                        } else {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                            return new VerifyEmail();
                                          }));
                                        }
                                      }
                                    })
                              ],
                            ))))));
  }
}
