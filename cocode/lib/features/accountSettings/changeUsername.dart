import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Auth.dart';
import 'AccountInfo.dart';
import 'package:cocode/buttons/RoundeButton.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_bloc/form_bloc.dart';
import 'dart:async';

//Username form
class editUsernameFormBloc extends FormBloc<String, String> {
  final _usernameFieldBloc =
      TextFieldBloc(asyncValidatorDebounceTime: Duration(milliseconds: 300));
  @override
  List<FieldBloc> get fieldBlocs => [
        _usernameFieldBloc,
      ];

  editUsernameFormBloc() {
    _usernameFieldBloc.addAsyncValidators([_validateusername]);
    _usernameFieldBloc.updateInitialValue(AccountInfo.username);
  }

  Future<String> _validateusername(String tusername) async {
    // validate if username exists
    await Future<void>.delayed(Duration(milliseconds: 200));
    if (!await Auth.checkUsernameAvailability(tusername)) {
      if (tusername != Auth.getCurrentUsername())
        return "Username already taken";
    }

    if (tusername.length < 3) {
      return "Too short username";
    }

    return null;
  }

  StreamSubscription<TextFieldBlocState> _textFieldBlocSubscription;

  @override
  void dispose() {
    _usernameFieldBloc.dispose();
    _textFieldBlocSubscription.cancel();
    super.dispose();
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    try {
      String uID = Auth.getCurrentUserID();
      String newUsername = _usernameFieldBloc.value;
      await FirebaseFirestore.instance.collection('User').doc(uID).update({
        'userName': newUsername,
      });

      await Auth.auth.currentUser.updateProfile(
        displayName: newUsername,
      );
      yield currentState.toSuccess();
    } catch (e) {
      yield currentState.toFailure();
    }
  }
}

class ChangeUsername extends StatefulWidget {
  @override
  _ChangeUsernameState createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
  String before;
  String after;

  bool isEnabled;
  @override
  void initState() {
    super.initState();
    isEnabled = false;
    before = AccountInfo.username;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: BlocProvider<editUsernameFormBloc>(
          builder: (context) => editUsernameFormBloc(),
          child: FutureBuilder<DocumentSnapshot>(
            future: Auth.getcurrentUserInfo(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              final _editUsernameFormBloc =
                  BlocProvider.of<editUsernameFormBloc>(context);

              return Scaffold(
                  body: FormBlocListener<editUsernameFormBloc, String, String>(
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
                onSuccess: (context, state) {
                  AccountInfo.username =
                      _editUsernameFormBloc._usernameFieldBloc.value;
                  // Hide the progress dialog
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                      msg: "Updates saved",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Color(0xff2A4793),
                      textColor: Colors.white,
                      fontSize: 16.0);
                  // Navigate to success screen
                  Navigator.of(context).pop();
                },
                onFailure: (context, state) {
                  // Hide the progress dialog
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                      msg: "An error accured",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Color(0xff2A4793),
                      textColor: Colors.white,
                      fontSize: 16.0);
                  // Show snackbar with the error
                },
                child: Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    leading: Container(),
                    centerTitle: true,
                    backgroundColor: Colors.white,
                    title: Text("Change Username",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff2A4793),
                        )),
                  ),
                  body: Center(
                      child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        Container(
                            width: 230.0,
                            child: GestureDetector(
                              child: Hero(
                                tag: 'username',
                                child: CircleAvatar(
                                  backgroundColor: Color(0xff2A4793),
                                  foregroundColor: Colors.white,
                                  radius: 40,
                                  child: Icon(
                                    Icons.alternate_email,
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
                          width: 230.0,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 180.0,
                                  child: TextFieldBlocBuilder(
                                    textFieldBloc: _editUsernameFormBloc
                                        ._usernameFieldBloc,
                                    suffixButton: SuffixButton
                                        .circularIndicatorWhenIsAsyncValidating,
                                    //

                                    autofocus: true,
                                    maxLength: 9,

                                    textAlign: TextAlign.center,
                                    textAlignVertical: TextAlignVertical.center,

                                    style: TextStyle(fontSize: 20),
                                    decoration: new InputDecoration(
                                      counterText: '',
                                      counterStyle: TextStyle(fontSize: 0),
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
                                          left: 20,
                                          bottom: 0,
                                          top: 11,
                                          right: -20),
                                      hintText: "Username",
                                    ),
                                    onChanged: (text) {
                                      setState(() {
                                        isEnabled = true;
                                      });
                                    },
                                  ),
                                )
                              ]),
                        ),
                        SizedBox(height: 20),
                        RoundedButton(
                            text: "Save",
                            color: Colors.indigo,
                            textColor: Colors.white,
                            press: () {
                              after = _editUsernameFormBloc
                                  ._usernameFieldBloc.value;

                              if (isEnabled && before != after)
                                _editUsernameFormBloc.submit();
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

                  //these methods are in hamePageData files
                ),
              ));
            },
          ),
        ));
  }
}
