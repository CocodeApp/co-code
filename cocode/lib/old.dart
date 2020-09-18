import 'dart:async';
import 'dart:io';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_bloc/form_bloc.dart';
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

class RegisterFormBloc extends FormBloc<String, String> {
  final _usernameFieldBloc =
      TextFieldBloc(asyncValidatorDebounceTime: Duration(milliseconds: 300));
  final _emailFieldBloc =
      TextFieldBloc(asyncValidatorDebounceTime: Duration(milliseconds: 300));
  final _passwordFieldBloc =
      TextFieldBloc(asyncValidatorDebounceTime: Duration(milliseconds: 300));

  @override
  List<FieldBloc> get fieldBlocs =>
      [_usernameFieldBloc, _emailFieldBloc, _passwordFieldBloc];

  RegisterFormBloc() {
    _usernameFieldBloc.addAsyncValidators([_validateusername]);
    _emailFieldBloc.addAsyncValidators([_validateemail]);
    _passwordFieldBloc.addAsyncValidators([_validatepassword]);
  }

  Future<String> _validateusername(String tusername) async {
    // validate if username exists
    await Future<void>.delayed(Duration(milliseconds: 200));
    if (!await Auth.checkUsernameAvailability(tusername)) {
      return "Username already taken";
    }

    if (tusername.length < 3) {
      return "too short username";
    }

    return null;
  }

  Future<String> _validateemail(String temail) async {
    // validate if email exists
    String isValid = Auth.validateEmail(temail);
    if (isValid != null) {
      return isValid;
    }
    await Future<void>.delayed(Duration(milliseconds: 200));
    if (!await Auth.checkemailAvailability(temail)) {
      return "Email already exists";
    }

    return null;
  }

  Future<String> _validatepassword(String tpass) async {
    // validate if username exists
    return Auth.validatePassword(tpass);
  }

  StreamSubscription<TextFieldBlocState> _textFieldBlocSubscription;

  @override
  void dispose() {
    _usernameFieldBloc.dispose();
    _emailFieldBloc.dispose();
    _passwordFieldBloc.dispose();
    _textFieldBlocSubscription.cancel();
    super.dispose();
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    try {
      await Auth.registerUser(_usernameFieldBloc.value, _emailFieldBloc.value,
          _passwordFieldBloc.value);
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
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  RegisterFormBloc _registerFormBloc;

  @override
  void initState() {
    super.initState();
    _registerFormBloc = RegisterFormBloc();
  }

  @override
  void dispose() {
    _registerFormBloc.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  String displayName;
  String email;
  String password;
  File _image;
  final picker = ImagePicker();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    CommonThings.size = MediaQuery.of(context)
        .size; // this size provide us total height and width of screenSize
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("imeges/background.png"), fit: BoxFit.cover),
        ),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                child: Center(
                  child: new Container(
                      height: CommonThings.size.height * 0.8,
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
                      child: SingleChildScrollView(
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
                              child: TextFieldBlocBuilder(
                                textFieldBloc:
                                    _registerFormBloc._usernameFieldBloc,
                                suffixButton: SuffixButton
                                    .circularIndicatorWhenIsAsyncValidating,
                                //
                                decoration: new InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.indigo, width: 2.0),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.indigo),
                                  ),
                                  disabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  errorBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  contentPadding: EdgeInsets.only(
                                      left: 15, bottom: 11, top: 11, right: 15),
                                  hintText: "username",
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: CommonThings.size.height * 0.01),
                            Container(
                              width: 250.0,
                              child: TextFieldBlocBuilder(
                                textFieldBloc:
                                    _registerFormBloc._emailFieldBloc,
                                suffixButton: SuffixButton
                                    .circularIndicatorWhenIsAsyncValidating,
                                //
                                decoration: new InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.indigo, width: 2.0),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.indigo),
                                  ),
                                  disabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  errorBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  contentPadding: EdgeInsets.only(
                                      left: 15, bottom: 11, top: 11, right: 15),
                                  hintText: "Email",
                                  prefixIcon: const Icon(
                                    Icons.email,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: CommonThings.size.height * 0.03),
                            Container(
                              width: 250.0,
                              child: TextFieldBlocBuilder(
                                textFieldBloc:
                                    _registerFormBloc._passwordFieldBloc,

                                suffixButton: SuffixButton.obscureText,
                                //
                                decoration: new InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.indigo, width: 2.0),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.indigo),
                                  ),
                                  disabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  errorBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  contentPadding: EdgeInsets.only(
                                      left: 15, bottom: 11, top: 11, right: 15),
                                  hintText: "Password",
                                  prefixIcon: const Icon(
                                    Icons.email,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: CommonThings.size.height * 0.035),
                            RoundedButton(
                              text: "Register",
                              color: Colors.indigo,
                              textColor: Colors.white,
                              press: _registerFormBloc.submit,
                            ),
                            SizedBox(height: CommonThings.size.height * 0.003),
                            RoundedButton(
                              text: "Already have an account ?",
                              color: Colors.blue[100],
                              textColor: Colors.black,
                              press: () async {
                                // call login

                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return LoginPage();
                                }));
                              },
                            ),
                          ],
                        ),
                      )),
                ),
              ),
      ),
    );
  }
}
