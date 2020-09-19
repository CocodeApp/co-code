import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Auth.dart';
import 'features/homePage/projectScreen.dart';
import 'LoginPage.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                                  if (text == null || text.isEmpty) {
                                    return 'Text is empty';
                                  }
                                  return null;
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
                                    return 'Text is empty';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            RaisedButton(
                              child: Text('Register'),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  // call login
                                  await Auth.registerUser(email, password)
                                      .then((void nothing) {
                                    print("done");
                                    setState(() {
                                      isLoading = false;
                                    });
                                  });
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return ProjectScreen();
                                  }));
                                }
                              },
                            ),
                            RaisedButton(
                              child: Text('Already have account?'),
                              onPressed: () async {
                                // call login

                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return LoginPage();
                                }));
                              },
                            ),
                          ],
                        )))));
  }
}
