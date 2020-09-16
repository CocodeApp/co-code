import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Auth.dart';
import 'ForgotPassword.dart';
import 'HomePage.dart';
import 'LoginPage.dart';
import 'RegisterPage.dart';

class VerifyEmail extends StatefulWidget {
  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final _formKey = GlobalKey<FormState>();
  final String email = Auth.getCurrentUserEmail();
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
                            Text("Please Verify your Email"),
                            Text(email),
                            RaisedButton(
                              child: Text('Send Again'),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  // call login
                                  await Auth.sendVerificationEmail()
                                      .then((void nothing) {
                                    print("back");
                                    setState(() {
                                      isLoading = false;
                                    });
                                  });
                                  await Auth.logout();
                                }
                              },
                            ),
                            RaisedButton(
                                child: Text('Back'),
                                onPressed: () async {
                                  await Auth.logout();
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return new LoginPage();
                                  }));
                                })
                          ],
                        ))))));
  }
}
