//name form
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocode/LoginPage.dart';
import 'package:cocode/features/accountSettings/changeName.dart';
import 'package:flutter/material.dart';
import '../../Auth.dart';
import '../../VerifyEmail.dart';
import 'AccountInfo.dart';
import 'package:cocode/buttons/RoundeButton.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_bloc/form_bloc.dart';
import 'dart:async';

class CommonThings {
  static Size size;
}

class EditEmailFormBloc extends FormBloc<String, String> {
  final _emailFieldBloc =
      TextFieldBloc(asyncValidatorDebounceTime: Duration(milliseconds: 300));
  final _passwordFieldBloc =
      TextFieldBloc(asyncValidatorDebounceTime: Duration(milliseconds: 300));
  var timescounter;

  @override
  List<FieldBloc> get fieldBlocs => [_emailFieldBloc, _passwordFieldBloc];

  EditEmailFormBloc() {
    timescounter = 3;
    String currentEmail = Auth.getCurrentUserEmail();

    _emailFieldBloc.addAsyncValidators([_validateemail]);
    _emailFieldBloc.updateInitialValue(currentEmail);
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
    String uID = Auth.getCurrentUserID();
    String orignalEmail = Auth.getCurrentUserEmail();
    String newEmail = _emailFieldBloc.value;

    //change both firestore and auth independently to avoid conflict
    try {
      //update auth

      String err = await Auth.updateEmail(newEmail);

      //if no exception were thrown at auth, go ahead and change firestaore
      if (err == null) {
        await FirebaseFirestore.instance
            .collection('User')
            .doc(uID)
            .update({'email': _emailFieldBloc.value});
        Auth.sendVerificationEmail();
        yield currentState.toSuccess();
      } else {
        yield currentState.toFailure(err);
      }
    } catch (e) {
      //if updating auth email was successful but an error occured while updating firestore email,
      //return auth orignal email to keep both firestore and auth consistent, then return error msg
      await Auth.updateEmail(orignalEmail);
      yield currentState.toFailure(e);
    }
  }
}

class ChangeEmail extends StatefulWidget {
  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  String before;
  String after;
  bool isEnabled;
  bool firstPress;
  bool isLoading;

  @override
  void initState() {
    super.initState();
    isEnabled = false;
    before = AccountInfo.email;
    firstPress = true;
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: BlocProvider<EditEmailFormBloc>(
          builder: (context) => EditEmailFormBloc(),
          child: FutureBuilder<DocumentSnapshot>(
            future: Auth.getcurrentUserInfo(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              final _editEmailFormBloc =
                  BlocProvider.of<EditEmailFormBloc>(context);

              return Scaffold(
                  body: FormBlocListener<EditEmailFormBloc, String, String>(
                onSubmitting: (context, state) {
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

                //on success
                onSuccess: (context, state) {
                  Navigator.of(context).pop();

                  AccountInfo.email = _editEmailFormBloc._emailFieldBloc.value;
                  setState(() {
                    isLoading = false;
                  });
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Center(
                            child: Container(
                                height: 250,
                                width: 350,
                                padding: EdgeInsets.all(12.0),
                                child: Card(
                                    child: Column(children: <Widget>[
                                  SizedBox(height: 20),
                                  Icon(
                                    Icons.move_to_inbox,
                                    color: Colors.black,
                                    size: 50.0,
                                  ),
                                  SizedBox(height: 20),
                                  Center(
                                      child: Text("Verify your new email",
                                          style: TextStyle(
                                              color: Colors.grey[800],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20))),
                                  SizedBox(height: 10),
                                  Center(
                                      child: Text(
                                          "When you're done, click 'done'")),
                                  SizedBox(height: 10),
                                  WillPopScope(
                                      onWillPop: () async => false,
                                      child: Container(
                                          child: Center(
                                              child: Column(children: <Widget>[
                                        OutlineButton(
                                          textColor: Colors.indigo,
                                          highlightedBorderColor:
                                              Colors.black.withOpacity(0.12),
                                          onPressed: () async {
                                            Auth.auth.currentUser
                                                .reload()
                                                .then((void nothing) {
                                              if (Auth.auth.currentUser
                                                  .emailVerified) {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();

                                                return Fluttertoast.showToast(
                                                    msg: "updates saved",
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    gravity: ToastGravity.TOP,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        Colors.blueAccent,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              } else {
                                                return Fluttertoast.showToast(
                                                    msg:
                                                        "Email not verified yet",
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    gravity: ToastGravity.TOP,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        Colors.blueAccent,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              }
                                            });
                                          },
                                          child: Text("Done"),
                                        ),
                                        SizedBox(height: 10),
                                      ]))))
                                ]))));
                      });
                },

                //on failure
                onFailure: (context, state) {
                  setState(() {
                    isLoading = false;
                  });

                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                      msg: "An error accured: " + state.failureResponse,
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.blueAccent,
                      textColor: Colors.white,
                      fontSize: 16.0);
                },

                //re-authenticate

                child: Scaffold(
                  appBar: AppBar(
                    leading: Container(),
                    centerTitle: true,
                    backgroundColor: Color(0xff2A4793),
                    title: Text(
                      "Update Email",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  body: Center(
                      child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        Container(
                            width: 250.0,
                            child: GestureDetector(
                              child: Hero(
                                tag: 'email',
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  radius: 40,
                                  child: Icon(
                                    Icons.mail_outline,
                                    color: Colors.white,
                                    size: 50.0,
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            )),
                        Container(
                          width: 250.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 250.0,
                                child: TextFieldBlocBuilder(
                                  textFieldBloc:
                                      _editEmailFormBloc._emailFieldBloc,
                                  suffixButton: SuffixButton
                                      .circularIndicatorWhenIsAsyncValidating,
                                  decoration: new InputDecoration(
                                    labelText: 'Email',
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
                                        left: 15,
                                        bottom: 11,
                                        top: 11,
                                        right: -30),
                                    hintText: "Email",
                                  ),
                                  onChanged: (text) {
                                    setState(() {
                                      isEnabled = true;
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        RoundedButton(
                            text: "Save",
                            color: Colors.indigo,
                            textColor: Colors.white,
                            press: () {
                              after = _editEmailFormBloc._emailFieldBloc.value;
                              if (isEnabled && before != after) {
                                //logic to authenticate *****

                                showDialog(
                                    context: context,
                                    builder: (context) => Center(
                                          child: SingleChildScrollView(
                                              child: Card(
                                            child: Container(
                                                width: 300,
                                                height: 200,
                                                padding: EdgeInsets.all(12.0),
                                                child: isLoading
                                                    ? Center(
                                                        child: Card(
                                                          child: Container(
                                                            width: 80,
                                                            height: 80,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    12.0),
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                        ),
                                                      )
                                                    : ListView(children: <
                                                        Widget>[
                                                        SizedBox(height: 20),

                                                        //row 1 --> label
                                                        Container(
                                                          width: 250.0,
                                                          child: Center(
                                                              child: Text(
                                                                  "Please enter your password:")),
                                                        ),

                                                        SizedBox(height: 20),

                                                        //row 2 --> password field
                                                        Container(
                                                          width: 250.0,
                                                          child:
                                                              TextFieldBlocBuilder(
                                                            textFieldBloc:
                                                                _editEmailFormBloc
                                                                    ._passwordFieldBloc,
                                                            suffixButton:
                                                                SuffixButton
                                                                    .obscureText,
                                                            decoration:
                                                                new InputDecoration(
                                                              border: UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.red)),
                                                              focusedBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .indigo,
                                                                    width: 2.0),
                                                              ),
                                                              enabledBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .indigo),
                                                              ),
                                                              disabledBorder:
                                                                  UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                              color: Colors.red)),
                                                              errorBorder: UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.red)),
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      left: 15,
                                                                      bottom:
                                                                          11,
                                                                      top: 11,
                                                                      right:
                                                                          15),
                                                              hintText:
                                                                  "Password",
                                                              prefixIcon:
                                                                  const Icon(
                                                                Icons.lock,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        //row 3 --> button to submit
                                                        FlatButton(
                                                          child: Text("submit"),
                                                          textColor:
                                                              Colors.black,

                                                          //submitting process
                                                          onPressed: () async {
                                                            if (firstPress) {
                                                              firstPress =
                                                                  false;

                                                              try {
                                                                setState(() {
                                                                  isLoading =
                                                                      true;
                                                                });
                                                                //first, login user
                                                                await Auth.loginUser(
                                                                        Auth
                                                                            .getCurrentUserEmail(),
                                                                        _editEmailFormBloc
                                                                            ._passwordFieldBloc
                                                                            .value)
                                                                    .then((void
                                                                        nothing) {
                                                                  setState(() {
                                                                    isLoading =
                                                                        false;
                                                                  });

                                                                  _editEmailFormBloc
                                                                      .submit();
                                                                });

                                                                //if password is correct, change email

                                                              } catch (e) {
                                                                setState(() {
                                                                  isLoading =
                                                                      false;
                                                                });
                                                                // if password is not correct, store the error message
                                                                String err = Auth
                                                                    .AuthErrorMessage(
                                                                        e);

                                                                _editEmailFormBloc
                                                                    .timescounter--;
                                                                //then show a dialog to indecate
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return Center(
                                                                          child: Container(
                                                                              height: 250,
                                                                              width: 350,
                                                                              padding: EdgeInsets.all(12.0),
                                                                              child: Card(
                                                                                  child: ListView(children: <Widget>[
                                                                                SizedBox(height: 20),
                                                                                Icon(
                                                                                  Icons.close,
                                                                                  color: Colors.red,
                                                                                  size: 50.0,
                                                                                ),
                                                                                SizedBox(height: 20),
                                                                                Center(child: Text("Wrong Password", style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold, fontSize: 20))),
                                                                                SizedBox(height: 10),

                                                                                //if the counter is greater than zero, show number of remaining chances and a button to retry
                                                                                _editEmailFormBloc.timescounter > 0

                                                                                    //if only one time is remaining

                                                                                    ? WillPopScope(
                                                                                        onWillPop: () async => false,
                                                                                        child: Container(
                                                                                            child: Center(
                                                                                                child: Column(children: <Widget>[
                                                                                          OutlineButton.icon(
                                                                                            textColor: Colors.indigo,
                                                                                            highlightedBorderColor: Colors.black.withOpacity(0.12),
                                                                                            onPressed: () {
                                                                                              Navigator.of(context).pop();
                                                                                            },
                                                                                            icon: Icon(Icons.keyboard_arrow_left, size: 14),
                                                                                            label: Text("Retry"),
                                                                                          ),
                                                                                          SizedBox(height: 10),
                                                                                          _editEmailFormBloc.timescounter == 1 ? Text("(You have only time left!)") : Text("(You have " + _editEmailFormBloc.timescounter.toString() + " times left)"),
                                                                                        ]))))
                                                                                    : WillPopScope(
                                                                                        onWillPop: () async => false,
                                                                                        child: Container(
                                                                                            child: Center(
                                                                                                child: Column(children: <Widget>[
                                                                                          SizedBox(height: 10),
                                                                                          Text("You will be logged out from the account"),
                                                                                        ])))),
                                                                              ]))));
                                                                    });
                                                                if (_editEmailFormBloc
                                                                        .timescounter ==
                                                                    0) {
                                                                  Future.delayed(
                                                                      Duration(
                                                                          seconds:
                                                                              5),
                                                                      () async {
                                                                    await Auth
                                                                        .logout();

                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(builder:
                                                                            (_) {
                                                                      return LoginPage();
                                                                    }));
                                                                  });
                                                                }
                                                              }

                                                              firstPress = true;
                                                            }
                                                          },
                                                        )
                                                      ])),
                                          )),
                                        ));
                              }
                              //_editEmailFormBloc.submit();
                              else
                                Navigator.of(context).pop();
                            }),
                        SizedBox(height: 20),
                        RoundedButton(
                          text: "Cancel",
                          color: Colors.blue[100],
                          textColor: Colors.black,
                          press: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  )),
                ),
              ));
            },
          ),
        ));
  }
}
