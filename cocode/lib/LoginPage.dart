import 'dart:io';
import 'package:cocode/Background.dart';
import 'package:cocode/ForgotPassword.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Auth.dart';
import 'HomePage.dart';
import 'RegisterPage.dart';
import 'VerifyEmail.dart';
import 'buttons/RoundeButton.dart';
import 'services/database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Background.dart';


class CommonThings {
  static Size size;
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    CommonThings.size = MediaQuery.of(context).size; // this size provide us total height and width of screenSize
    return Scaffold(
        body :DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(  image: AssetImage("imeges/background.png"), fit: BoxFit.cover),
      ),
          child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                child: Center(
                    child: new Container(
                        height:  CommonThings.size.height * 0.65,
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
                            SizedBox(height: CommonThings.size.height * 0.03),
                            Container(
                              width: 250.0,
                              child: TextFormField(
                                decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.deepOrange),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.indigo),
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
                                  return Auth.validateEmail(text);
                                },
                              ),
                            ),
                            SizedBox(height: CommonThings.size.height * 0.03),
                            Container(
                              width: 250.0,
                              child: TextFormField(
                                obscureText: true,
                                decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.deepOrange),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.indigo),
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
                            SizedBox(height: CommonThings.size.height * 0.03),
                            RoundedButton(
                              text: "Login",
                              textColor: Colors.white,
                                  press:() async {
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
                            SizedBox(height: CommonThings.size.height * 0.003),
                            RoundedButton(
                                text: "Forgot your Password ?",
                                color: Colors.deepOrangeAccent[200],
                                textColor: Colors.white,
                                press: () async {
                                // call login
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return new ForgotPassword();
                                }));
                              },
                            ),
                            SizedBox(height: CommonThings.size.height * 0.003),
                            RoundedButton(
                                text: "You don't have an Account ?",
                                color: Colors.blue[100],
                                textColor: Colors.black,
                                press: () async {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return new RegisterPage();
                                  }));
                                })
                          ],
                        )  )))));
  }
}
