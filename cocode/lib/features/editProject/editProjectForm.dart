import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kf_drawer/kf_drawer.dart';

import '../../Auth.dart';
import 'changeDueDate.dart';
import 'projectInfo.dart';
import 'uploadPhoto.dart';
import 'changeSkills.dart';
import 'changeStartDate.dart';

//Storing Account Info
class updateProject extends StatefulWidget {
  var id;
  updateProject({
    Key key,
    @required this.id,
  });
  @override
  _updateProjectState createState() => _updateProjectState();
}

class _updateProjectState extends State<updateProject> {
  List<dynamic> skills;
  String startDate;
  String dueDate;
  bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  Widget build(BuildContext context) {
    CollectionReference projects =
        FirebaseFirestore.instance.collection('projects');
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigo,
        title: Text(
          "editProject",
          textAlign: TextAlign.center,
        ),
        leading: BackButton(
          color: Colors.deepOrangeAccent,
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: projects.doc(widget.id).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data.data();

            projectInfo.skills = this.skills = data['requiredSkills'];
            projectInfo.startDate = this.startDate = data['startdate'];
            projectInfo.dueDate = this.dueDate = data['deadline'];
            return Scaffold(
                backgroundColor: Colors.white,
                body: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(
                      children: <Widget>[
                        Card(
                          child: ListTile(
                              leading: GestureDetector(
                                child: Hero(
                                    tag: 'startDate',
                                    child: CircleAvatar(
                                      backgroundColor: Colors.indigo,
                                      foregroundColor: Colors.white,
                                      radius: 20,
                                      child: Icon(
                                        Icons.calendar_today,
                                        color: Colors.white,
                                        size: 30.0,
                                      ),
                                    )),
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return changeStartDate();
                                  }));
                                },
                              ),
                              dense: false,
                              title: Text('startDate',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.grey)),
                              subtitle: Text(this.startDate,
                                  style: TextStyle(
                                      fontSize: 17.0, color: Colors.black87)),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          new changeStartDate()),
                                ).then((value) {
                                  setState(() {
                                    //قيمة الستارت ديت بعد التغيير
                                    // this.startDate = AccountInfo.username;
                                  });
                                });
                              }),
                        ),
                        Card(
                          child: ListTile(
                            leading: GestureDetector(
                              child: Hero(
                                tag: 'due date',
                                child: CircleAvatar(
                                  backgroundColor: Colors.indigo,
                                  child: Icon(
                                    Icons.calendar_today,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return changeDueDate();
                                }));
                              },
                            ),
                            dense: false,
                            title: Text('due date',
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.grey)),
                            subtitle: Text(this.dueDate,
                                style: TextStyle(
                                    fontSize: 17.0, color: Colors.black87)),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new changeDueDate()),
                              ).then((value) {
                                setState(() {
                                  //نجد
                                  //وش بيصير بعد التغيير
                                  // this.firstname = AccountInfo.firstname;
                                  // this.lastname = AccountInfo.lastname;
                                });
                              });
                            },
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: GestureDetector(
                              child: Hero(
                                  tag: 'skills',
                                  child: CircleAvatar(
                                    backgroundColor: Colors.indigo,
                                    child: Icon(
                                      Icons.assignment,
                                      color: Colors.white,
                                      size: 30.0,
                                    ),
                                    foregroundColor: Colors.white,
                                  )),
                            ),
                            dense: false,
                            title: Text('skills',
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.grey)),
                            subtitle: Text(this.skills.isEmpty ? "" : skills[0],
                                style: TextStyle(
                                    fontSize: 17.0, color: Colors.black87)),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   new MaterialPageRoute(
                              //       builder: (context) => new changeSkills()),
                              // ).then((value) {
                              //   setState(() {
                              //     //نجد
                              //     // this.email = AccountInfo.email;
                              //   });
                              // });
                            },
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: GestureDetector(
                              child: Hero(
                                  tag: 'logo',
                                  child: CircleAvatar(
                                    //نجد
                                    //المفروض هنا يكون فيه الصورة من الداتا بيس
                                    backgroundImage:
                                        AssetImage("imeges/logo-2.png"),
                                    radius: 20,
                                  )),
                            ),
                            dense: false,
                            title: Text('uploade logo',
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.grey)),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () async {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new uploadLogo()),
                              ).then((value) {
                                setState(() {
                                  //نجد
                                  // this.email = AccountInfo.email;
                                });
                              });
                            },
                          ),
                        ),
                      ],
                    )));
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
          else
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
    );
  }
}
