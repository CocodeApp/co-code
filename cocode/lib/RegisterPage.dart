import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'Auth.dart';
import 'HomePage.dart';
import 'LoginPage.dart';
import 'VerifyEmail.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String displayName;
  String email;
  String password;
  File _image;
  final picker = ImagePicker();

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
                        child: Column(
                          children: <Widget>[
                            Center(
                              child: _image == null
                                  ? Text('No image selected.')
                                  : Image.file(_image),
                            ),
                            FloatingActionButton(
                              onPressed: () async {
                                final pickedFile = await picker.getImage(
                                    source: ImageSource.camera);

                                setState(() {
                                  _image = File(pickedFile.path);
                                });
                              },
                              tooltip: 'Pick Image',
                              child: Icon(Icons.add_a_photo),
                            ),
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
                                    hintText: "Username"),
                                onChanged: (value) {
                                  setState(() {
                                    displayName = value;
                                  });
                                },
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'username can\'t be empty';
                                  }
                                  return null;
                                },
                              ),
                            ),
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
                                validator: (email) {
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
                                validator: (password) {
                                  return Auth.validatePassword(password);
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
                                    try {
                                      await Auth.registerUser(
                                          email, password, displayName);
                                      Fluttertoast.showToast(
                                          msg: "Signed Up Successfully",
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
                                }),
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
