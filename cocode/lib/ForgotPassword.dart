import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Auth.dart';
import 'ForgotPassword.dart';
import 'HomePage.dart';
import 'LoginPage.dart';
import 'RegisterPage.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  String recoveryEmail;
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
                        child: Center(
                            child: Column(
                          children: <Widget>[
                            Text("Forgot password?"),
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
                                    recoveryEmail = value;
                                  });
                                },
                              ),
                            ),
                            RaisedButton(
                              child: Text('Send'),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  // call login
                                  await Auth.resetPassword(recoveryEmail)
                                      .then((void nothing) {
                                    print("done");
                                    setState(() {
                                      isLoading = false;
                                    });
                                  });
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return new LoginPage();
                                  }));
                                }
                              },
                            ),
                            RaisedButton(
                                child: Text('Back'),
                                onPressed: () async {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return new LoginPage();
                                  }));
                                })
                          ],
                        ))))));
  }
}
