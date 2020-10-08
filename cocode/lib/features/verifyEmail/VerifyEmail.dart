import 'dart:io';
import 'package:cocode/features/homePage/homePageView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cocode/Auth.dart';
import 'package:cocode/features/Login/LoginPage.dart';
import 'package:cocode/features/Login/ForgotPassword.dart';
import 'package:cocode/features/registertion/RegisterPage.dart';
import 'package:cocode/buttons/RoundeButton.dart';
import 'package:kf_drawer/kf_drawer.dart';

class CommonThings {
  static Size size;
}

class VerifyEmail extends KFDrawerContent {
  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final _formKey = GlobalKey<FormState>();
  final String email = Auth.getCurrentUserEmail();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
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
                                height: 400.0,
                                width: 300,
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
                                child: Center(
                                    child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Icon(
                                      Icons.lock,
                                      color: Colors.green,
                                      size: 50.0,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      child: Text(
                                        'Verify your email',
                                        style: TextStyle(
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      email,
                                      style: TextStyle(
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    SizedBox(height: 10),
                                    RoundedButton(
                                      text: "Done",
                                      color: Colors.indigo,
                                      textColor: Colors.white,
                                      press: () async {
                                        if (_formKey.currentState.validate()) {
                                          // call login
                                          Auth.auth.currentUser
                                              .reload()
                                              .then((void nothing) {
                                            if (Auth.auth.currentUser
                                                .emailVerified) {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (_) {
                                                return new homePageView();
                                              }));
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: "Email not verified yet",
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  gravity: ToastGravity.TOP,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor:
                                                      Colors.blueAccent,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            }
                                          });
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    RoundedButton(
                                      text: "Send Again",
                                      color: Colors.deepOrangeAccent,
                                      textColor: Colors.white,
                                      press: () async {
                                        if (_formKey.currentState.validate()) {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          // call login
                                          try {
                                            await Auth.sendVerificationEmail()
                                                .then((void nothing) {
                                              print("back");
                                              setState(() {
                                                isLoading = false;
                                              });

                                              Fluttertoast.showToast(
                                                  msg: "Email Sent",
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  gravity: ToastGravity.TOP,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor:
                                                      Colors.blueAccent,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            });
                                          } catch (e) {
                                            Fluttertoast.showToast(
                                                msg: "${e.message}",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.TOP,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                    Colors.blueAccent,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          }
                                        }
                                      },
                                    ),
                                    RoundedButton(
                                        text: "Logout",
                                        color: Colors.blue[100],
                                        textColor: Colors.black,
                                        press: () async {
                                          await Auth.logout();
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                            return new LoginPage();
                                          }));
                                        })
                                  ],
                                ))))))));
  }
}
