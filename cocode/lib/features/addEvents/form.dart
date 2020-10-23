import '../../Auth.dart';
import 'package:cocode/features/homePage/homePageView.dart';
import 'package:flutter/services.dart';

import 'package:cocode/Auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocode/buttons/postbutton.dart';
import 'package:cocode/features/homePage/homePageView.dart';
import 'package:cocode/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocode/services/agenda_datepicker.dart';
import 'package:cocode/services/agenda_timepicker.dart';

class form extends StatefulWidget {
  @override
  _State createState() => _State();
}

String projectName;
String projectDescription;
DateTime startdate;
DateTime deadline;
final ValueNotifier<String> _dateErorrmsg = ValueNotifier<String>("");

String memberNum = "";
final format = DateFormat("yyyy-MM-dd");

//https://medium.com/@mahmudahsan/how-to-create-validate-and-save-form-in-flutter-e80b4d2a70a4
class _State extends State<form> {
  @override
  void initState() {
    super.initState();
    projectName = "";
    projectDescription = "";
    startdate = null;
    deadline = null;
    _dateErorrmsg.value = "";
  }

  final ValueNotifier<List<String>> skillsNotifier =
      ValueNotifier<List<String>>([]);
  TextEditingController eCtrl = new TextEditingController();
  TextEditingController membersCtrl = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    setState(() {});

    final _formKey = GlobalKey<FormState>();
    return Container(
      decoration: new BoxDecoration(color: Colors.lightBlueAccent),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: Card(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //project name
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Project Name",
                            contentPadding: EdgeInsets.all(18.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(50.0),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter Project Name';
                            } else if (value.length > 12) {
                              return 'Project Name must not exceed 12 characters';
                            }
                            projectName = value;

                            return null;
                          },
                        ),
                      ),
                      //project description
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Project Description",
                            contentPadding: EdgeInsets.all(18.0),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          maxLines: 3,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter Project Description';
                            } else if (value.length > 170) {
                              return 'Project description must not exceed 170 characters';
                            }
                            projectDescription = value;

                            return null;
                          },
                        ),
                      ),
                      //startdate
                      new mydatepicker("Start", (DateTime start) {
                        setState(() {
                          startdate = start;
                        });
                      }),

                      new mytimepicker("Start time", (DateTime dead) {
                        setState(() {
                          deadline = dead;
                        });
                      }),
                      //deadline
                      new mydatepicker("End date", (DateTime dead) {
                        setState(() {
                          deadline = dead;
                        });
                      }),

                      new mytimepicker("End time", (DateTime dead) {
                        setState(() {
                          deadline = dead;
                        });
                      }),
                      ValueListenableBuilder(
                        builder:
                            (BuildContext context, String value, Widget child) {
                          return Padding(
                              padding: EdgeInsets.all(7),
                              child: Text(value,
                                  style: TextStyle(
                                    color: Colors.red[800],
                                    fontSize: 13.0,
                                  )));
                        },
                        valueListenable: _dateErorrmsg,
                      ),

                      //post button
                      postbutton(
                        onPressed: () async {
                          // DocumentReference project = FirebaseFirestore.instance
                          //     .collection('projects')
                          //     .doc();
                          // CollectionReference ideaOwnerUser =
                          //     FirebaseFirestore.instance.collection('User');

                          // project to the projects collections
                          if (startdate != null && deadline != null) {
                            if (startdate.isAfter(deadline))
                              _dateErorrmsg.value =
                                  "startdate must not be after deadline";
                            else
                              _dateErorrmsg.value = "";
                          } else {
                            if (startdate == null || deadline == null) {
                              _dateErorrmsg.value = "cannot be empty";
                            }
                          }

                          if (_formKey.currentState.validate() &&
                              _dateErorrmsg.value == "") {
                            // project
                            //     .set({
                            //       'projectName': projectName,
                            //       'deadline': deadline != null
                            //           ? DateFormat.yMMMd().format(deadline)
                            //           : "Not Set Yet",
                            //       'ideaOwner': Auth.getCurrentUserID(),
                            //       'membersNum': membersCtrl.text,
                            //       'projectDescripion': projectDescription,

                            //       'requiredSkills': skillsNotifier.value,
                            //       'startdate': startdate != null
                            //           ? DateFormat.yMMMd().format(startdate)
                            //           : "Not Set Yet",
                            //       'status': "open",
                            //       'supervisor': "", //empty
                            //       'teamMembers': [], //empty
                            //     })
                            //     .then((value) =>
                            //         print("project Added to projects"))
                            //     .catchError((error) =>
                            //         print("Failed to add project: $error"));

                            // //add project to the owner user account
                            // ideaOwnerUser
                            //     .doc(Auth.getCurrentUserID())
                            //     .collection("myProjects")
                            //     .doc(project.id) //check the output
                            //     .set({
                            //       'projectName': projectName,
                            //       'role': "Idea Owner",
                            //       'tempList': [],
                            //     })
                            //     .then((value) =>
                            //         print("project Added to the user"))
                            //     .catchError((error) =>
                            //         print("Failed to add project: $error"));
                            setState(() {});
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return homePageView();
                            }));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
