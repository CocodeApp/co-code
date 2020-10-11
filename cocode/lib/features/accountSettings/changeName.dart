//name form
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

class editNameFormBloc extends FormBloc<String, String> {
  final _firstnameFieldBloc =
      TextFieldBloc(asyncValidatorDebounceTime: Duration(milliseconds: 300));
  final _lastnameFieldBloc =
      TextFieldBloc(asyncValidatorDebounceTime: Duration(milliseconds: 300));

  @override
  List<FieldBloc> get fieldBlocs => [
        _firstnameFieldBloc,
        _lastnameFieldBloc,
      ];

  editNameFormBloc() {
    _firstnameFieldBloc.addAsyncValidators([_validatename]);
    _lastnameFieldBloc.addAsyncValidators([_validatename]);

    _firstnameFieldBloc.updateInitialValue(AccountInfo.firstname);
    _lastnameFieldBloc.updateInitialValue(AccountInfo.lastname);
  }

  Future<String> _validatename(String tname) async {
    // validate if username exists
    if (tname.isEmpty || tname == null) {
      return "Name is required!";
    }

    if (tname.length < 3) {
      return "Too short name!";
    }

    return null;
  }

  StreamSubscription<TextFieldBlocState> _textFieldBlocSubscription;

  @override
  void dispose() {
    _firstnameFieldBloc.dispose();
    _lastnameFieldBloc.dispose();
    _textFieldBlocSubscription.cancel();
    super.dispose();
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    try {
      String uID = Auth.getCurrentUserID();
      await FirebaseFirestore.instance.collection('User').doc(uID).update({
        'firstName': _firstnameFieldBloc.value,
        'lastName': _lastnameFieldBloc.value,
      });

      yield currentState.toSuccess();
    } catch (e) {
      yield currentState.toFailure();
    }
  }
}

class ChangeName extends StatefulWidget {
  @override
  _ChangeNameState createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangeName> {
  String fBefore;
  String lBefore;
  String fAfter;
  String lAfter;
  bool hasChanged;
  bool isEnabled;
  @override
  void initState() {
    super.initState();
    isEnabled = false;
    fBefore = AccountInfo.firstname;
    lBefore = AccountInfo.lastname;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: BlocProvider<editNameFormBloc>(
          builder: (context) => editNameFormBloc(),
          child: FutureBuilder<DocumentSnapshot>(
            future: Auth.getcurrentUserInfo(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              final _editNameFormBloc =
                  BlocProvider.of<editNameFormBloc>(context);
              return Scaffold(
                  body: FormBlocListener<editNameFormBloc, String, String>(
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
                  AccountInfo.firstname =
                      _editNameFormBloc._firstnameFieldBloc.value;
                  AccountInfo.lastname =
                      _editNameFormBloc._lastnameFieldBloc.value;
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
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    leading: Container(),
                    centerTitle: true,
                    backgroundColor: Colors.white,
                    title: Text("Change name",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xff2A4793))),
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
                                tag: 'name',
                                child: CircleAvatar(
                                  backgroundColor: Color(0xff2A4793),
                                  foregroundColor: Colors.white,
                                  radius: 40,
                                  child: Icon(
                                    Icons.face,
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
                                width: 125.0,
                                child: TextFieldBlocBuilder(
                                  textFieldBloc:
                                      _editNameFormBloc._firstnameFieldBloc,
                                  suffixButton: SuffixButton
                                      .circularIndicatorWhenIsAsyncValidating,
                                  decoration: new InputDecoration(
                                    labelText: 'First name',
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
                                    hintText: "First name",
                                  ),
                                  onChanged: (text) {
                                    setState(() {
                                      isEnabled = true;
                                    });
                                  },
                                ),
                              ),
                              Container(
                                width: 125.0,
                                child: TextFieldBlocBuilder(
                                  textFieldBloc:
                                      _editNameFormBloc._lastnameFieldBloc,
                                  suffixButton: SuffixButton
                                      .circularIndicatorWhenIsAsyncValidating,
                                  maxLines: 1,
                                  decoration: new InputDecoration(
                                    labelText: 'Last name',
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
                                    isDense: true,
                                    hintText: "Last name",
                                  ),
                                  onChanged: (text) {
                                    setState(() {
                                      isEnabled = true;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        RoundedButton(
                            text: "Save",
                            color: Colors.indigo,
                            textColor: Colors.white,
                            press: () {
                              fAfter =
                                  _editNameFormBloc._firstnameFieldBloc.value;
                              lAfter =
                                  _editNameFormBloc._lastnameFieldBloc.value;

                              hasChanged =
                                  (fBefore != fAfter) || (lBefore != lAfter);
                              if (isEnabled && hasChanged)
                                _editNameFormBloc.submit();
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
