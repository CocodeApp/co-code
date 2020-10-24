import 'package:fluttertoast/fluttertoast.dart';

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

import 'addEvent.dart';

class AddEventFormPage extends StatefulWidget {
  AddEventFormPage({Key key, @required this.id});
  var id;
  @override
  _State createState() => _State();
}

String eventname;
String eventdescription;
DateTime startdate;
DateTime deadline;
DateTime starttime;
DateTime endtime;

final ValueNotifier<String> _dateErorrmsg = ValueNotifier<String>("");

String memberNum = "";
final format = DateFormat("yyyy-MM-dd");

//https://medium.com/@mahmudahsan/how-to-create-validate-and-save-form-in-flutter-e80b4d2a70a4
class _State extends State<AddEventFormPage> {
  @override
  void initState() {
    super.initState();
    eventname = "";
    eventdescription = "";
    startdate = null;
    deadline = null;
    starttime = null;
    endtime = null;

    _dateErorrmsg.value = "";
  }

  final ValueNotifier<List<String>> skillsNotifier =
      ValueNotifier<List<String>>([]);
  TextEditingController eCtrl = new TextEditingController();
  // TextEditingController membersCtrl = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    setState(() {});

    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        leading: BackButton(
          color: Colors.deepOrangeAccent,
        ),
        title: Text(
          "Add Event",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: new Container(
        height: 700.0,
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
                              hintText: "Event Name",
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
                                return 'Please enter Event Name';
                              } else if (value.length > 12) {
                                return 'Project Name must not exceed 12 characters';
                              }
                              eventname = value;

                              return null;
                            },
                          ),
                        ),
                        //project description
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "Event Description",
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
                                return 'Please enter Event Description';
                              } else if (value.length > 170) {
                                return 'Evnt description must not exceed 170 characters';
                              }
                              eventdescription = value;

                              return null;
                            },
                          ),
                        ),
                        //startdate
                        new mydatepicker("StartDate", (DateTime start) {
                          setState(() {
                            startdate = start;
                          });
                        }),

                        new mytimepicker("StartTime", (DateTime start) {
                          setState(() {
                            starttime = start;
                          });
                        }),
                        //deadline
                        new mydatepicker("EndDate", (DateTime dead) {
                          setState(() {
                            deadline = dead;
                          });
                        }),

                        new mytimepicker("endTime", (DateTime end) {
                          setState(() {
                            endtime = end;
                          });
                        }),
                        ValueListenableBuilder(
                          builder: (BuildContext context, String value,
                              Widget child) {
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
                            //                         DocumentReference project = FirebaseFirestore
                            //                             .instance
                            //                             .collection('projects')
                            //                             .doc(widget.id);

                            // String x = result.data()['firstName'];

                            //print(project.)
                            // CollectionReference ideaOwnerUser =
                            //     FirebaseFirestore.instance.collection('User');

                            // project to the projects collections

                            print("id is  " + widget.id);
                            if (startdate != null && deadline != null) {
                              if (startdate.isAfter(deadline))
                                _dateErorrmsg.value =
                                    "startdate must not be after deadline";
                              else
                                _dateErorrmsg.value = "";
                            } else {
                              if (startdate == null || deadline == null) {
                                _dateErorrmsg.value =
                                    "Date and time can't be empty";
                                print("-------");
                              }
                            }

                            if (_formKey.currentState.validate() &&
                                _dateErorrmsg.value == "") {
                              //setting attributes

                              //1- event name
                              String event_name = eventname;

                              // description
                              String event_description = eventdescription;

                              //3- start date
                              DateTime start_date = DateTime(
                                  startdate.year,
                                  startdate.month,
                                  startdate.day,
                                  starttime.hour,
                                  starttime.minute);

                              //4- end date

                              DateTime end_date = DateTime(
                                  deadline.year,
                                  deadline.month,
                                  deadline.day,
                                  endtime.hour,
                                  endtime.minute);

                              //5- list of members emails
                              DocumentSnapshot project = await FirebaseFirestore
                                  .instance
                                  .collection('projects')
                                  .doc(widget.id)
                                  .get();

                              CollectionReference users =
                                  await FirebaseFirestore.instance
                                      .collection('User');

                              var project_members =
                                  project.data()['teamMembers'];
                              print(project_members);
                              List members_emails = [];

                              var len = project_members.length;

                              for (var i = 0; i < len; i++) {
                                DocumentSnapshot result =
                                    await users.doc(project_members[i]).get();

                                members_emails.add(result.data()['email']);
                              }

                              print(members_emails);

                              await FirebaseFirestore.instance
                                  .collection('projects')
                                  .doc(widget.id)
                                  .collection("project_events")
                                  .doc() //check the output
                                  .set({
                                    'name': event_name,
                                    'description': event_description,
                                    'startdate': start_date,
                                    'enddate': end_date,
                                  })
                                  .then((value) =>
                                      print("Event Added to the the project"))
                                  .catchError((error) =>
                                      print("Failed to add event: $error"));

                              var res = await addEvent(event_name, start_date,
                                  end_date, members_emails);

                              if (res) {
                                Fluttertoast.showToast(
                                    msg: "Event added Successfully",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.blueAccent,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Failed to add event",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.blueAccent,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                              setState(() {});

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
      ),
    );
  }
}
