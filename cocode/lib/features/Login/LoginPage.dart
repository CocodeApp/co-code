import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocode/features/Login/ForgotPassword.dart';
import 'package:cocode/features/homePage/homePageView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:form_bloc/form_bloc.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_bloc/form_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:cocode/Auth.dart';
import 'LoginPage.dart';

import 'package:cocode/features/registertion/MoreInfoPage.dart';
import 'package:cocode/features/registertion/RegisterPage.dart';
import 'package:cocode/features/verifyEmail/VerifyEmail.dart';
import 'package:cocode/buttons/RoundeButton.dart';

class CommonThings {
  static Size size;
}

class LoginFormBloc extends FormBloc<String, String> {
  final _emailFieldBloc =
      TextFieldBloc(asyncValidatorDebounceTime: Duration(milliseconds: 300));
  final _passwordFieldBloc =
      TextFieldBloc(asyncValidatorDebounceTime: Duration(milliseconds: 300));

  @override
  List<FieldBloc> get fieldBlocs => [_emailFieldBloc, _passwordFieldBloc];

  LoginFormBloc() {
    _emailFieldBloc.addAsyncValidators([_validateemail]);
    _passwordFieldBloc.addAsyncValidators([_validatepassword]);
  }

  Future<String> _validateemail(String temail) async {
    // validate if email exists
    String isValid = Auth.validateEmail(temail);
    if (isValid != null) {
      return isValid;
    }
    await Future<void>.delayed(Duration(milliseconds: 200));
    if (await Auth.checkemailAvailability(temail)) {
      return "Email doesn't exists";
    }

    return null;
  }

  Future<String> _validatepassword(String tpass) async {
    if (tpass == null || tpass.isEmpty) {
      return "Password can\'t be empty";
    }
    return null;
  }

  StreamSubscription<TextFieldBlocState> _textFieldBlocSubscription;

  @override
  void dispose() {
    _emailFieldBloc.dispose();
    _passwordFieldBloc.dispose();
    _textFieldBlocSubscription.cancel();
    super.dispose();
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    try {
      await Auth.loginUser(_emailFieldBloc.value, _passwordFieldBloc.value);

      yield currentState.toSuccess();
    } catch (e) {
      String err = Auth.AuthErrorMessage(e);
      yield currentState.toFailure(err);
    }
  }
}

class LoginPage extends StatelessWidget {
  String email;
  String password;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: BlocProvider<LoginFormBloc>(
          builder: (context) => LoginFormBloc(),
          child: Builder(
            builder: (context) {
              final _LoginFormBloc = BlocProvider.of<LoginFormBloc>(context);
              CommonThings.size = MediaQuery.of(context).size;
              return Scaffold(
                body: FormBlocListener<LoginFormBloc, String, String>(
                  onSubmitting: (context, state) {
                    // Show the progress dialog
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => WillPopScope(
                        onWillPop: () async => false,
                        child: Center(
                          child: Card(
                            child: Container(
                              width: 80,
                              height: 80,
                              padding: EdgeInsets.all(12.0),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  onSuccess: (context, state) {
                    // Hide the progress dialog
                    Navigator.of(context).pop();
                    Fluttertoast.showToast(
                        msg: "Logged In Successfully",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueAccent,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    // Navigate to success screen

                    if (Auth.isLoggedIn()) {
                      if (Auth.isVerified()) {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return new homePageView();
                        }));
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return new VerifyEmail();
                        }));
                      }
                    }
                  },
                  onFailure: (context, state) {
                    // Hide the progress dialog
                    Navigator.of(context).pop();
                    Fluttertoast.showToast(
                        msg: state.failureResponse,
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueAccent,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    // Show snackbar with the error
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("imeges/background.png"),
                          fit: BoxFit.cover),
                    ),
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Center(
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
                                      SizedBox(
                                          height:
                                              CommonThings.size.height * 0.03),
                                      Text(
                                        'Login',
                                        style: TextStyle(
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                        textAlign: TextAlign.left,
                                      ),
                                      SizedBox(
                                          height:
                                              CommonThings.size.height * 0.01),
                                      Container(
                                        width: 250.0,
                                        child: TextFieldBlocBuilder(
                                          textFieldBloc:
                                              _LoginFormBloc._emailFieldBloc,
                                          suffixButton: SuffixButton
                                              .circularIndicatorWhenIsAsyncValidating,
                                          //
                                          decoration: new InputDecoration(
                                            border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red)),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.indigo,
                                                  width: 2.0),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.indigo),
                                            ),
                                            disabledBorder:
                                                UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.red)),
                                            errorBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red)),
                                            contentPadding: EdgeInsets.only(
                                                left: 15,
                                                bottom: 11,
                                                top: 11,
                                                right: 15),
                                            hintText: "Email",
                                            prefixIcon: const Icon(
                                              Icons.email,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              CommonThings.size.height * 0.03),
                                      Container(
                                        width: 250.0,
                                        child: TextFieldBlocBuilder(
                                          textFieldBloc:
                                              _LoginFormBloc._passwordFieldBloc,

                                          suffixButton:
                                              SuffixButton.obscureText,
                                          //
                                          decoration: new InputDecoration(
                                            border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red)),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.indigo,
                                                  width: 2.0),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.indigo),
                                            ),
                                            disabledBorder:
                                                UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.red)),
                                            errorBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red)),
                                            contentPadding: EdgeInsets.only(
                                                left: 15,
                                                bottom: 11,
                                                top: 11,
                                                right: 15),
                                            hintText: "Password",
                                            prefixIcon: const Icon(
                                              Icons.lock,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              CommonThings.size.height * 0.035),
                                      RoundedButton(
                                        text: "Login",
                                        color: Colors.indigo,
                                        textColor: Colors.white,
                                        press: _LoginFormBloc.submit,
                                      ),
                                      SizedBox(
                                          height:
                                              CommonThings.size.height * 0.003),
                                      RoundedButton(
                                        text: "don't have Account?",
                                        color: Colors.blue[100],
                                        textColor: Colors.black,
                                        press: () async {
                                          // call login

                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                            return RegisterPage();
                                          }));
                                        },
                                      ),
                                      SizedBox(
                                          height:
                                              CommonThings.size.height * 0.003),
                                      RoundedButton(
                                        text: "Forgot password?",
                                        color: Colors.blue[100],
                                        textColor: Colors.black,
                                        press: () {
                                          // call login

                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                            return ForgotPassword();
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
            },
          ),
        ));
  }
}
