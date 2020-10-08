import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocode/buttons/RoundeButton.dart';
import 'package:cocode/AccountInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:form_bloc/form_bloc.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'Auth.dart';

class CommonThings {
  static Size size;
}
// I really hope I understood it correctly.. if you think something is wrong please tell me :<

// dear najd yes I don't know whether its field or feild so please focus on the concept and we'll discuss it later.. deal?
class templateFormBloc extends FormBloc<String, String> {
  //here list all the feilds you want exactly this way:
  final _usernameFieldBloc =
      TextFieldBloc(asyncValidatorDebounceTime: Duration(milliseconds: 300));

//final _emailFieldBloc = TextFieldBloc(asyncValidatorDebounceTime: Duration(milliseconds: 300));

// ..

//now put all field names in this array.. here we have only one feild so
  @override
  List<FieldBloc> get fieldBlocs => [
        _usernameFieldBloc,
        //_emailFieldBloc
        // ..
      ];

  templateFormBloc() {
    //here link each field with the name of its validating methods (make the method by yourself like below)
    _usernameFieldBloc.addAsyncValidators([_validateusername]);

    //here if you want to put an initial value in your field
    _usernameFieldBloc.updateInitialValue(AccountInfo.username);
  }

// here is the validating method I was talking about.. just return a string with the error message of each case and otherwise return null.. (it considers null as valid)
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

    // if neither of those cases happened, then return null which means it's valid.. yaay!
    return null;
  }

// keep those stuff as they are.. no change
  StreamSubscription<TextFieldBlocState> _textFieldBlocSubscription;

// no change except adding all fields to dispose
  @override
  void dispose() {
    ///dispose all fields like this:
    _usernameFieldBloc.dispose();
    //_emailFieldBloc.dispose();
    //..
    _textFieldBlocSubscription.cancel();
    super.dispose();
  }

// here is the submit method that won't be executed unless all your fields are valid
  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
//Now those are general ways to store values in firebase:
//(PLEASE DON'T EXECUTE THOSE.. if you want to try the code comment them first)
    //A- if you want to make a brand new document (like making a new user or new project)
    // here I want to make a new document and I want the document name to be same as current user ID (so that each user in firebase authentiaction has a corresponding document in firebase firestore with the same ID)

    //I'll get current user ID.. I already made a method in class Auth to do this

    String uID = Auth.getCurrentUserID();
    DocumentReference reference = FirebaseFirestore.instance
        .doc('User/' + uID); //see the warning on line 78
    reference.set({
      'userName': _usernameFieldBloc.value,
    });

    //B- if you want to update a value in firebase for an existing document .. replace (User) with the name of your collection
    try {
      String uID = Auth.getCurrentUserID();
      await FirebaseFirestore.instance.collection('User').doc(uID).update({
        'userName': _usernameFieldBloc.value,
      });

      // What's the difference between A and B? if you use A for an existing document it will override it with a new document.. but B will only update it with specified values

      // Now what is 'await'? I'' explain this in the bottom of the file to avoid distraction

      //later on we'll see two methods in the widget that we will create.. one is called when we yeild toSuccess and the second is for toFailure
      yield currentState.toSuccess();
    } catch (e) {
      yield currentState.toFailure();
    }
  }
}

// and now comes our widget!
class templatePage extends StatefulWidget {
  @override
  _templatePageState createState() => _templatePageState();
}

class _templatePageState extends State<templatePage> {
  String username;

// we'll use this variable to setState our widget to show loader while we're getting data from database
  bool isLoading;

  @override
  void initState() {
    super.initState();
    username = AccountInfo.username;
    isLoading = false;
  }

  // Keep everything in the widget exactly as it is unless there is a comment to change something
  @override
  Widget build(BuildContext context) {
    //change the name of the collection to the collection you need
    CollectionReference users = FirebaseFirestore.instance.collection('User');

    return new WillPopScope(
        onWillPop: () async => false,
        child: BlocProvider<templateFormBloc>(
          builder: (context) => templateFormBloc(),
          child: FutureBuilder<DocumentSnapshot>(
            future: users.doc(Auth.getCurrentUserID()).get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              final _templateFormBloc =
                  BlocProvider.of<templateFormBloc>(context);

              // if all data is loaded succesfully
              if (snapshot.hasData) {
                Map<String, dynamic> data = snapshot.data.data();

                //between square brackets specify the name of the attribute that you want to get (READ IT FROM FIRESTORE CONSOLE and make sure of capital/small etc)
                username = AccountInfo.username = data['userName'];

                return Scaffold(
                    body: FormBlocListener<templateFormBloc, String, String>(
                  //what will happen while your form is being processed? exactly... show that s***** loader
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

                  // do u remember when we mentioned yeild success and yeild failure? those are the two methods
                  onSuccess: (context, state) {
                    // Hide the progress dialog
                    Navigator.of(context).pop();

                    //show a message for the naive user
                    Fluttertoast.showToast(
                        msg: "Updates saved",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueAccent,
                        textColor: Colors.white,
                        fontSize: 16.0);

                    Navigator.of(context).pop();
                  },

                  //show a message for the sad user
                  onFailure: (context, state) {
                    // Hide the progress dialog
                    Navigator.of(context).pop();
                    Fluttertoast.showToast(
                        msg: "An error accured",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueAccent,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  },

                  // now return normal UI

                  //just in case isLoading is true, show that ***** loader again until state sets loader to false
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Scaffold(
                          appBar: AppBar(
                            leading: Container(),
                            centerTitle: true,
                            backgroundColor: Color(0xff2A4793),
                            title: Text(
                              "example texplate",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          body: Center(
                              child: SingleChildScrollView(
                                  child: Column(
                            children: <Widget>[
                              Text("Current username:" + AccountInfo.username),

                              // here is how to make a blocfiled you initiated in the class above (line 19)
                              TextFieldBlocBuilder(
                                textFieldBloc: _templateFormBloc
                                    ._usernameFieldBloc, //here put the name of the field exactly as in the class
                                suffixButton: SuffixButton
                                    .circularIndicatorWhenIsAsyncValidating,
                                // bla bla.. decoration
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
                                      left: 15,
                                      bottom: 11,
                                      top: 11,
                                      right: -20),
                                  hintText: "Username",
                                ),
                              ),
                              RoundedButton(
                                  text: "Save",
                                  color: Colors.indigo,
                                  textColor: Colors.white,
                                  press: () {
                                    //submit the form.. now it will call all validators then submit
                                    _templateFormBloc.submit();
                                  }),
                            ],
                          ))),
                        ),
                ));
              } else if (!snapshot.hasData)
                return Center(
                  child: Card(
                    child: Container(
                      width: 80,
                      height: 80,
                      padding: EdgeInsets.all(12.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              else // = if (snapshot.data.documents.isEmpty)
                return Center(
                  child: Card(
                    child: Container(
                      width: 80,
                      height: 80,
                      padding: EdgeInsets.all(12.0),
                      child: Text("Oops.. no data!"),
                    ),
                  ),
                );
            },
          ),
        ));
  }
}

// soo.. as most programming languages code is exectuted asynchrounsly when we call firebase to do something for us we can't simply do that..
// we have to wait until we get the response otherwise it will be a mess
// that's why we use await when we ask firebase for something
// await is called only inside a method that is async
// as when we ask firebase for something we wait it to bring something in the future the return type of await is Future<real_return_type>
// real_return_type can be string or boolean etc based on the info we requested
// check Auth class methods there are a lot of examples
// now I really have to sleep
// your friend
// Dijkstra Hawaii..
