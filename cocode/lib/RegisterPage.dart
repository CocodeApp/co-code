import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'Auth.dart';
import 'HomePage.dart';
import 'LoginPage.dart';
import 'VerifyEmail.dart';
import 'buttons/RoundeButton.dart';

class CommonThings {
  static Size size;
}
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
                        height:  CommonThings.size.height *0.8,
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
                            SizedBox(height: CommonThings.size.height * 0.05),
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
                            SizedBox(height: CommonThings.size.height * 0.01),

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
                                validator: (email) {
                                  return Auth.validateEmail(email);
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
                                validator: (password) {
                                  return Auth.validatePassword(password);
                                },
                              ),
                            ),
                            SizedBox(height: CommonThings.size.height * 0.035),

                            RoundedButton(
                              text: "Register",
                                color: Colors.indigo,
                                textColor: Colors.white,
                                press: ()  async {
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
                            SizedBox(height: CommonThings.size.height * 0.003),
                            RoundedButton(
                              text: "Already have an account ?",
                              color: Colors.blue[100],
                              textColor: Colors.black,
                              press: ()  async {
                                // call login

                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return LoginPage();
                                }));
                              },
                            ),
                          ],
                        ),
                    ),
                ),
          ),
      ),
    );
  }
}
