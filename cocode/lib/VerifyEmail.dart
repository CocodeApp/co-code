import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Auth.dart';
import 'ForgotPassword.dart';
import 'LoginPage.dart';
import 'RegisterPage.dart';
import 'buttons/RoundeButton.dart';

class CommonThings {
  static Size size;
}

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
                                    Icon(
                                      Icons.lock,
                                      color: Colors.green,
                                    ),
                                    Container(
                                      child: Text(
                                        'Verify your email',
                                        style: TextStyle(
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                    Text(
                                      email,
                                      style: TextStyle(
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
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
                                                  gravity: ToastGravity.CENTER,
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
                                                gravity: ToastGravity.CENTER,
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
