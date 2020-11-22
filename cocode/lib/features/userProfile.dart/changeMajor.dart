import 'package:cocode/features/accountSettings/AccountInfo.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Auth.dart';
import 'package:cocode/buttons/RoundeButton.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_bloc/form_bloc.dart';
import 'dart:async';

class editMajorFormBloc extends FormBloc<String, String> {
  final _majorFieldBloc =
  TextFieldBloc(asyncValidatorDebounceTime: Duration(milliseconds: 300));

  @override
  List<FieldBloc> get fieldBlocs => [
    _majorFieldBloc,
  ];
  editMajorFormBloc() {
    _majorFieldBloc.updateInitialValue(AccountInfo.major);
  }

  StreamSubscription<TextFieldBlocState> _textFieldBlocSubscription;
  @override
  void dispose() {
    _majorFieldBloc.dispose();

    _textFieldBlocSubscription.cancel();
    super.dispose();
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    try {
      String uID = Auth.getCurrentUserID();
      await FirebaseFirestore.instance.collection('User').doc(uID).update({
        'major': _majorFieldBloc.value,
      });

      yield currentState.toSuccess();
    } catch (e) {
      yield currentState.toFailure();
    }
  }
}

class changeMajor extends StatefulWidget {
  @override
  _changeMajorState createState() => _changeMajorState();
}

class _changeMajorState extends State<changeMajor> {
  String majorBefore;
  String majorAfter;
  bool hasChanged;
  bool isEnabled;
  @override
  void initState() {
    super.initState();
    isEnabled = false;
    majorBefore = AccountInfo.major;
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('User');
    return new WillPopScope(
        onWillPop: () async => false,
        child: BlocProvider<editMajorFormBloc>(
            builder: (context) => editMajorFormBloc(),
            child: FutureBuilder<DocumentSnapshot>(
                future: users.doc(Auth.getCurrentUserID()).get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  final _editBioFormBloc =
                  BlocProvider.of<editMajorFormBloc>(context);
                  return Scaffold(
                      body: FormBlocListener<editMajorFormBloc, String, String>(
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
                          AccountInfo.major =
                              _editBioFormBloc._majorFieldBloc.value;

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
                            title: Text("Change Major",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Color(0xff2A4793))),
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
                                          tag: 'major',
                                          child: CircleAvatar(
                                            backgroundColor: Color(0xff2A4793),
                                            foregroundColor: Colors.white,
                                            radius: 40,
                                            child: Icon(
                                              Icons.local_library,
                                              color: Colors.white,
                                              size: 50.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 300.0,
                                      child: TextFieldBlocBuilder(
                                        textFieldBloc: _editBioFormBloc._majorFieldBloc,
                                        suffixButton: SuffixButton
                                            .circularIndicatorWhenIsAsyncValidating,
                                        textAlign: TextAlign.center,
                                     textAlignVertical: TextAlignVertical.center,                                        style: TextStyle(fontSize: 20),

                                        decoration: new InputDecoration(
                                          labelText:  '                          Major',

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
                                          hintText: "Major",
                                        ),
                                        onChanged: (text) {
                                          setState(() {
                                            isEnabled = true;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    RoundedButton(
                                        text: "Save",
                                        color: Colors.indigo,
                                        textColor: Colors.white,
                                        press: () {
                                          majorAfter =
                                              _editBioFormBloc._majorFieldBloc.value;

                                          hasChanged = (majorBefore != majorAfter);
                                          if (isEnabled && hasChanged)
                                            _editBioFormBloc.submit();
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
                })));
  }
}
