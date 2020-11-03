import 'package:cocode/features/accountSettings/AccountInfo.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Auth.dart';
import 'package:cocode/buttons/RoundeButton.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_bloc/form_bloc.dart';
import 'dart:async';

class editBioFormBloc extends FormBloc<String, String> {
  final _bioFieldBloc =
      TextFieldBloc(asyncValidatorDebounceTime: Duration(milliseconds: 300));

  @override
  List<FieldBloc> get fieldBlocs => [
        _bioFieldBloc,
      ];

  editBioFormBloc() {
    // _bioFieldBloc.addAsyncValidators([_validatebio]);

    _bioFieldBloc.updateInitialValue(AccountInfo.bio);
  }

  // Future<String> _validatebio(String bio) async {
  //   // validate if username exists
  //   if (bio.length > 140) {
  //     return "bio should be 140 letter only";
  //   } else {
  //     return "";
  //   }
  // }

  StreamSubscription<TextFieldBlocState> _textFieldBlocSubscription;

  @override
  void dispose() {
    _bioFieldBloc.dispose();

    _textFieldBlocSubscription.cancel();
    super.dispose();
  }

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    try {
      String uID = Auth.getCurrentUserID();
      await FirebaseFirestore.instance.collection('User').doc(uID).update({
        'bio': _bioFieldBloc.value,
      });

      yield currentState.toSuccess();
    } catch (e) {
      yield currentState.toFailure();
    }
  }
}

class changeBio extends StatefulWidget {
  @override
  _changeBioState createState() => _changeBioState();
}

class _changeBioState extends State<changeBio> {
  String bioBefore;
  String bioAfter;
  bool hasChanged;
  bool isEnabled;
  @override
  void initState() {
    super.initState();
    isEnabled = false;
    bioBefore = AccountInfo.bio;
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('User');
    return new WillPopScope(
        onWillPop: () async => false,
        child: BlocProvider<editBioFormBloc>(
          builder: (context) => editBioFormBloc(),
          child: FutureBuilder<DocumentSnapshot>(
            future: users.doc(Auth.getCurrentUserID()).get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              final _editBioFormBloc =
                  BlocProvider.of<editBioFormBloc>(context);
              return Scaffold(
                  body: FormBlocListener<editBioFormBloc, String, String>(
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
                  AccountInfo.bio = _editBioFormBloc._bioFieldBloc.value;

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
                    title: Text("Change Bio",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xff2A4793))),
                  ),
                  body: Center(
                      child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 100),
                        Container(
                          //box
                          height: 100,
                          width: 250.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 125.0,
                                child: TextFieldBlocBuilder(
                                  textFieldBloc: _editBioFormBloc._bioFieldBloc,
                                  suffixButton: SuffixButton
                                      .circularIndicatorWhenIsAsyncValidating,
                                  decoration: new InputDecoration(
                                    labelText: 'Bio',
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
                                    hintText: "bio",
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
                              bioAfter = _editBioFormBloc._bioFieldBloc.value;

                              hasChanged = (bioBefore != bioAfter);
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
            },
          ),
        ));
  }
}
