import 'dart:io';

import 'package:cocode/ForgotPassword.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Auth.dart';
import 'HomePage.dart';
import 'RegisterPage.dart';
import 'VerifyEmail.dart';
import 'services/database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                child: Center(
                    child: new Container(
                        height: 300.0,
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
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 200.0,
                              child: TextFormField(
                                decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red)),
                                    contentPadding: EdgeInsets.only(
                                        left: 15,
                                        bottom: 11,
                                        top: 11,
                                        right: 15),
                                    hintText: "Email"),
                                onChanged: (value) {
                                  setState(() {
                                    email = value;
                                  });
                                },
                                validator: (text) {
                                  return Auth.validateEmail(email);
                                },
                              ),
                            ),
                            Container(
                              width: 200.0,
                              child: TextFormField(
                                obscureText: true,
                                decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red)),
                                    contentPadding: EdgeInsets.only(
                                        left: 15,
                                        bottom: 11,
                                        top: 11,
                                        right: 15),
                                    hintText: "password"),
                                onChanged: (value) {
                                  setState(() {
                                    password = value;
                                  });
                                },
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'passsword can\'t be empty';
                                  }

                                  return null;
                                },
                              ),
                            ),
                            RaisedButton(
                              child: Text('Log In'),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  // call login
                                  try {
                                    await Auth.loginUser(email, password);

                                    Fluttertoast.showToast(
                                        msg: "Logged In successfully",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.blueAccent,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  } catch (e) {
                                    Fluttertoast.showToast(
                                        msg: Auth.AuthErrorMessage(e),
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
                                        return new HomePage();
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
                            RaisedButton(
                              child: Text('New Account?'),
                              onPressed: () async {
                                // call login
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return new RegisterPage();
                                }));
                              },
                            ),
                            RaisedButton(
                                child: Text('Forgot Password?'),
                                onPressed: () async {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return new ForgotPassword();
                                  }));
                                })
                          ],
                        )))));
  }
}
