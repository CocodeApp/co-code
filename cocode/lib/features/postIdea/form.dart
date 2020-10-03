//form.dart
import 'package:flutter/services.dart';
import 'package:cocode/buttons/postbutton.dart';
import 'package:cocode/features/homePage/homePage.dart';
import 'package:cocode/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocode/services/datepicker.dart';

class form extends StatefulWidget {
  @override
  _State createState() => _State();
}

String projectName = "";
String projectDescription = "";
DateTime startdate = null;
DateTime deadline = null;
final ValueNotifier<String> _dateErorrmsg = ValueNotifier<String>("");
String memberNum = "";
List<String> skills = [];

final format = DateFormat("yyyy-MM-dd");

//https://medium.com/@mahmudahsan/how-to-create-validate-and-save-form-in-flutter-e80b4d2a70a4
class _State extends State<form> {
  TextEditingController eCtrl = new TextEditingController();
  TextEditingController membersCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Container(
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
                            contentPadding: EdgeInsets.all(23.0),
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
                            contentPadding: EdgeInsets.all(23.0),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(50.0),
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          maxLines: 5,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter Project Description';
                            } else {
                              projectDescription = value;
                            }
                            return null;
                          },
                        ),
                      ),
                      //startdate
                      mydatepicker("StartDate", (DateTime start) {
                        setState(() {
                          startdate = start;
                        });
                      }),

                      //deadline
                      mydatepicker("Deadline", (DateTime dead) {
                        setState(() {
                          deadline = dead;
                        });
                      }),
                      ValueListenableBuilder(
                        builder:
                            (BuildContext context, String value, Widget child) {
                          // This builder will only get called when the _counter
                          // is updated.
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

                      //members number
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.people,
                            size: 50,
                          ),
                          SizedBox(width: 20),
                          Flexible(
                            child: TextFormField(
                              controller: membersCtrl,
                              validator: (value) {
                                memberNum = value;
                                return null;
                              },
                              decoration: new InputDecoration(
                                labelText: "expected number of team members",
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50.0),
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                            ),
                          ),
                        ],
                      ),
                      //skills
                      SizedBox(
                        height: 19,
                      ),
                      Material(
                        elevation: 10.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        color: Color(0XAA2A4793),
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Wrap(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: skills.length,
                                itemBuilder: (context, Index) {
                                  return Card(
                                    elevation: 15.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                    child: ListTile(
                                      leading: Icon(Icons.assignment),
                                      title: Text(skills[Index]),
                                      trailing: IconButton(
                                          icon: Icon(Icons.delete),
                                          color: Color(0XAAF57862),
                                          onPressed: () {
                                            setState(() {
                                              skills.removeAt(Index);
                                            });
                                          }),
                                    ),
                                  );
                                },
                              ),
                              Theme(
                                data: ThemeData(
                                  primaryColor: Colors.black,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                          focusColor: Color(0XCC2A4793),
                                          hoverColor: Color(0XFF2A4793),
                                          icon: Icon(Icons.add),
                                          onPressed: () {
                                            if (eCtrl.text != "") {
                                              skills.add(eCtrl.text);
                                              eCtrl.clear();
                                              setState(() {});
                                            }
                                          }),
                                      hintText: "Add a New Skill",
                                      contentPadding: EdgeInsets.all(13.0),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 10.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(50.0),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    controller: eCtrl,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      //post button
                      postbutton(
                        onPressed: () {
                          CollectionReference project =
                              FirebaseFirestore.instance.collection('projects');
                          CollectionReference ideaOwnerUser =
                              FirebaseFirestore.instance.collection('User');

                          // project to the projects collections
                          if (startdate != null && deadline != null) {
                            if (startdate.isAfter(deadline))
                              _dateErorrmsg.value =
                                  "startdate must not be after deadline";
                            else
                              _dateErorrmsg.value = "";
                          }

                          if (_formKey.currentState.validate() &&
                              _dateErorrmsg.value == "") {
                            project
                                .add({
                                  'projectName': projectName,
                                  'deadline':
                                      DateFormat.yMMMd().format(deadline),
                                  'ideaOwner': "company", // yet
                                  'membersNum': membersCtrl.text,
                                  'projectDescripion': projectDescription,

                                  'requiredSkills': skills,
                                  'startdate':
                                      DateFormat.yMMMd().format(startdate),
                                  'status': "open",
                                  'supervisor': "", //empty
                                  'teamMembers': [], //empty
                                })
                                .then((value) =>
                                    print("project Added to projects"))
                                .catchError((error) =>
                                    print("Failed to add project: $error"));

                            //add project to the owner user account

                            ideaOwnerUser
                                .doc("u1")
                                .collection("projects")
                                .add({
                                  'projectName': projectName,
                                  'projectDescripion': projectDescription,
                                  //how can i generate a uniqe one?
                                  'projectRole': "Idea Owner",
                                })
                                .then((value) =>
                                    print("project Added to the user"))
                                .catchError((error) =>
                                    print("Failed to add project: $error"));

                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return homePage();
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
