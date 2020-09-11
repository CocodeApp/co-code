import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
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
                      child: TextField(
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                            hintText: "Username"),
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 200.0,
                      child: TextField(
                        obscureText: true,
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red)),
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                            hintText: "password"),
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                    ),
                    RaisedButton(
                      child: Text('Sign Up'),
                      onPressed: () {
                        FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: email, password: password)
                            .then((result) {
                          print(result.user.email);
                        });
                      },
                    ),
                  ],
                ))));
  }
}
