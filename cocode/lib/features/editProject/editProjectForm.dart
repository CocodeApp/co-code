import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kf_drawer/kf_drawer.dart';

import '../../Auth.dart';
import 'changeDueDate.dart';
import 'changeTeamMemberNum.dart';
import 'projectInfo.dart';
import 'uploadPhoto.dart';
import 'changeSkills.dart';
import 'changeStartDate.dart';
import 'package:toggle_switch/toggle_switch.dart';

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
  TextEditingController membersCtrl = new TextEditingController();
  String membersNum = "";
  CollectionReference projects =
      FirebaseFirestore.instance.collection('projects');
  IconData lock;
  String status;
  int index;
  List<String> stringslist = new List<String>();

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  Widget build(BuildContext context) {
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

            stringslist.forEach((value) {
              print(value);
            });
            projectInfo.startDate = this.startDate = data['startdate'];
            projectInfo.dueDate = this.dueDate = data['deadline'];
            projectInfo.membersNum = this.membersNum = data['membersNum'];
            this.status = data['status'];
            if (status == 'open') {
              index = 0;
              lock = Icons.lock_open;
            } else {
              index = 1;
              lock = Icons.lock_outline;
            }

            return Scaffold(
                backgroundColor: Colors.white,
                body: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(
                      children: <Widget>[
                        uploadLogo(context),
                        start(context),
                        deadLine(context),
                        updateSkills(context),
                        teammemberNum(),
                        Container(
                          height: 80,
                          child: Card(
                            child: Row(
                              children: [
                                SizedBox(width: 15),
                                CircleAvatar(
                                  backgroundColor: Colors.indigo,
                                  foregroundColor: Colors.white,
                                  radius: 20,
                                  child: Icon(
                                    lock,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                ),
                                SizedBox(width: 20),
                                Text('project status'),
                                SizedBox(width: 80),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      border: Border.all(color: Colors.indigo)),
                                  child: ToggleSwitch(
                                    initialLabelIndex: this.index,
                                    minWidth: 60.0,
                                    cornerRadius: 20.0,
                                    activeBgColor: Colors.indigo,
                                    activeFgColor: Colors.white,
                                    inactiveBgColor: Colors.white,
                                    inactiveFgColor: Colors.indigo,
                                    labels: ['open', 'close'],
                                    onToggle: (index) async {
                                      setState(() {
                                        index == 0
                                            ? lock = Icons.lock_open
                                            : lock = Icons.lock_outline;
                                      });
                                      await FirebaseFirestore.instance
                                          .collection('projects')
                                          .doc(widget.id)
                                          .update({
                                        'status': index == 0 ? "open" : "close",
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
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

  Card teammemberNum() {
    return Card(
      child: ListTile(
        leading: GestureDetector(
          child: Hero(
            tag: 'tem members number',
            child: CircleAvatar(
              backgroundColor: Colors.indigo,
              child: Icon(
                Icons.people,
                color: Colors.white,
                size: 30.0,
              ),
              foregroundColor: Colors.white,
            ),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return teamMembersNumber(number: membersNum, id: widget.id);
            }));
          },
        ),
        dense: false,
        title: Text('team members number',
            style: TextStyle(fontSize: 14.0, color: Colors.grey)),
        subtitle: Text(this.membersNum,
            style: TextStyle(fontSize: 17.0, color: Colors.black87)),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
          Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new teamMembersNumber(
                    number: this.membersNum, id: widget.id)),
          ).then((value) {
            setState(() {
              //نجد
              //وش بيصير ب����������د التغيير
              // this.firstname = AccountInfo.firstname;
              // this.lastname = AccountInfo.lastname;
            });
          });
        },
      ),
    );
  }

  Card updateSkills(BuildContext context) {
    List<dynamic> tobedisplay;

    return Card(
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
            style: TextStyle(fontSize: 14.0, color: Colors.grey)),
        subtitle: Text(this.skills.isEmpty ? "" : skills[0] + " ...",
            style: TextStyle(fontSize: 17.0, color: Colors.black87)),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
          Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) =>
                    new changeSkills(id: widget.id, skills: this.skills)),
          ).then((value) {
            setState(() {});
          });
        },
      ),
    );
  }

  Card deadLine(BuildContext context) {
    return Card(
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
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return changeDueDate(
                id: widget.id,
                deadline: dueDate,
              );
            }));
          },
        ),
        dense: false,
        title: Text('due date',
            style: TextStyle(fontSize: 14.0, color: Colors.grey)),
        subtitle: Text(this.dueDate,
            style: TextStyle(fontSize: 17.0, color: Colors.black87)),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
          Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new changeDueDate(
                      id: widget.id,
                      deadline: dueDate,
                    )),
          ).then((value) {
            setState(() {
              //نجد
              //وش بيصير ب����������د التغيير
              // this.firstname = AccountInfo.firstname;
              // this.lastname = AccountInfo.lastname;
            });
          });
        },
      ),
    );
  }

  Card start(BuildContext context) {
    return Card(
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
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return changeStartDate(
                  id: widget.id,
                  startdate: startDate,
                );
              }));
            },
          ),
          dense: false,
          title: Text('startDate',
              style: TextStyle(fontSize: 14.0, color: Colors.grey)),
          subtitle: Text(this.startDate,
              style: TextStyle(fontSize: 17.0, color: Colors.black87)),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new changeStartDate(
                        id: widget.id,
                        startdate: startDate,
                      )),
            ).then((value) {
              setState(() {});
            });
          }),
    );
  }

  Card uploadLogo(BuildContext context) {
    return Card(
      child: ListTile(
        leading: GestureDetector(
          child: Hero(
              tag: 'logo',
              child: CircleAvatar(
                //نجد
                //المفروض هنا يكون فيه الصورة من الداتا بيس
                backgroundImage: AssetImage("imeges/logo-2.png"),
                radius: 20,
              )),
        ),
        dense: false,
        title: Text('uploade logo',
            style: TextStyle(fontSize: 14.0, color: Colors.grey)),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () async {
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new upLoadLogo()),
          ).then((value) {
            setState(() {
              //نجد
              // this.email = AccountInfo.email;
            });
          });
        },
      ),
    );
  }
}
