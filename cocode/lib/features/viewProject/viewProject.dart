import 'package:cocode/features/acceptReject/Members.dart';
import 'package:cocode/features/userProfile.dart/userProfile.dart';
import 'package:cocode/features/homePage/homePageView.dart';
import 'package:cocode/features/viewProject/skills.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Auth.dart';
import 'teamMembersData.dart';
import 'teamMembers.dart';
import 'skills.dart';

class viewProject extends StatefulWidget {
  var id;

  String tab;
  viewProject({Key key, @required this.id, this.tab}) : super(key: key);
  @override
  _viewProjectState createState() => _viewProjectState();
}

class _viewProjectState extends State<viewProject> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('projects');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.id).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                leading: BackButton(
                  color: Colors.indigo,
                  onPressed: () => (Navigator.pop(context)),
                ),
                backgroundColor: Colors.white,
                title: Text(
                  data['projectName'],
                  style: TextStyle(color: Colors.indigo),
                ),
                bottom: TabBar(
                  indicatorColor: Colors.deepOrangeAccent,
                  labelColor: Colors.indigo,
                  tabs: [
                    Tab(
                      text: "project details",
                    ),
                    Tab(
                      text: 'project members',
                    ),
                    Tab(
                      text: 'needed skills',
                    )
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  ProjectDetails(widget.id, data, widget.tab),
                  teamMembersList(
                    projectData: data,
                  ),
                  skills(
                    projectData: data,
                  )
                ],
              ),
            ),
          );
        }

        return Scaffold(
            body: Column(
          children: [
            Center(child: CircularProgressIndicator()),
          ],
        ));
      },
    );
  }
} // there is some missing details , see our class diagram for more info

class ProjectDetails extends StatelessWidget {
  Map<String, dynamic> data;
  var id;

  String tab;
  //firestore

  ProjectDetails(this.id, this.data, this.tab);

  @override
  Widget build(BuildContext context) {
    //before building the widget
    //get leader'sid
    //get the current project
    //get temp list
    //if the user exist,return flase, otherwise true
    //depending on the previous bool change the button
    //after building the widget
    /*1 */
    //if they clicked join , will execute apply "means bool = true"
    //add their id to the list and update the firestore
    /*2 */
    //if they clicked applied, will execute Notapply "means bool = false"
    //remove their id from the list and update the firestore
    String leaderRole = (tab == "member") ? 'supervisor' : 'ideaOwner';

    final ValueNotifier<bool> wantToApply = ValueNotifier<bool>(true);
    final ValueNotifier<bool> show = ValueNotifier<bool>(true);

    Future<void> hideapplyButton() async {
      CollectionReference project =
          FirebaseFirestore.instance.collection('projects');
      await project.doc(id).get().then((value) {
        List listofmembers = value.data()['teamMembers'];
        String currentSuper = value.data()['supervisor'];
        String currentOwner = value.data()['ideaOwner'];
        String user = Auth.getCurrentUserID();
        if (listofmembers.contains(Auth.getCurrentUserID()) ||
            currentSuper.compareTo(user) == 0 ||
            currentOwner.compareTo(user) == 0) {
          return false;
        } else
          return true;
      }).catchError((e) {
        print(e.toString());
      });
    }

    Future<void> checkApplying() async {
      CollectionReference leaderprofile = FirebaseFirestore.instance
          .collection('User')
          .doc(data[leaderRole])
          .collection('myProjects');

      await leaderprofile.doc(id).get().then((value) {
        List listofapplicants = value.data()['tempList'];
        if (listofapplicants.contains(Auth.getCurrentUserID())) {
          wantToApply.value = false;
        } else
          wantToApply.value = true;
      }).catchError((e) {
        print(e.toString());
      });
    }

    checkApplying();

    void apply() {
      //add the user to the list
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshsnap = await transaction.get(FirebaseFirestore
            .instance
            .collection('User')
            .doc(data[leaderRole])
            .collection('myProjects')
            .doc(id));
        List l = [Auth.getCurrentUserID()];
        await transaction.update(
            freshsnap.reference, {'tempList': FieldValue.arrayUnion(l)});
      });

      print("apply");
      //change wantToApply value to false
      wantToApply.value = false;
    }

    void NotApply() {
      //remove the user from the list
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshsnap = await transaction.get(FirebaseFirestore
            .instance
            .collection('User')
            .doc(data[leaderRole])
            .collection('myProjects')
            .doc(id));
        await transaction.update(freshsnap.reference, {
          'tempList': FieldValue.arrayRemove([Auth.getCurrentUserID()])
        });
      });

      //change wantToApply value to true
      wantToApply.value = true;
    }

    String deadline;
    data['deadline'] == ''
        ? deadline = 'not assigned yet'
        : deadline = data['deadline'].toString();
    String startdate;
    data['startdate'] == ''
        ? startdate = 'not assigned yet'
        : startdate = data['startdate'];

    return SingleChildScrollView(
        child: ListView(
      children: [
        SizedBox(
          height: 30,
        ),
        CircleAvatar(
          backgroundImage: AssetImage("imeges/logo-2.png"),
          radius: 60,
        ), // to be transparent if there is no logo
        SizedBox(
          height: 30,
        ),
        SizedBox(
          width: 350,
          height: 350,
          child: Card(
            color: new Color(0xFFdfe7f2),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            shadowColor: Colors.grey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        data['projectName'],
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Open Sans',
                            fontSize: 30),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Text(
                        data['projectDescripion'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontFamily: 'Open Sans',
                            fontSize: 20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20.0,
                          height: 5.0,
                        ),
                        Icon(
                          Icons.calendar_today,
                          size: 25.0,
                          color: Colors.blueGrey[800],
                        ),
                        SizedBox(
                          width: 20.0,
                          height: 5.0,
                        ),
                        Text(
                          'From   ' + startdate + '\nTo       ' + deadline,
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Open Sans',
                              fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20.0,
                        height: 5.0,
                      ),
                      Icon(
                        Icons.group_add,
                        size: 30.0,
                        color: Colors.blueGrey[800],
                      ),
                      SizedBox(
                        width: 15.0,
                        height: 5.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text('Status  :  ' + data['status'],
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                    ],
                  ),
                  //here
                  FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('projects')
                          .doc(id)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text("Something went wrong");
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data = snapshot.data.data();
                          List listofmembers = data['teamMembers'];
                          String currentSuper = data['supervisor'];
                          String currentOwner = data['ideaOwner'];
                          String project = data['projectName'];
                          String user = Auth.getCurrentUserID();
                          String listofwhat = "";
                          if (currentSuper.compareTo(user) == 0)
                            listofwhat = "Team Members Applicants";
                          if (currentOwner.compareTo(user) == 0 &&
                              currentSuper ==
                                  "") //if they already have supervisor
                            listofwhat = "Supervisors Applicants";
                          if (listofmembers.contains(Auth.getCurrentUserID()) ||
                              currentSuper.compareTo(user) == 0 ||
                              currentOwner.compareTo(user) == 0) {
                            return Column(
                              children: <Widget>[
                                Center(
                                  child: RawMaterialButton(
                                    elevation: 80.0,
                                    fillColor: const Color(0XFF2A4793),
                                    splashColor: const Color(0xff2980b9),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10.0,
                                        horizontal: 50.0,
                                      ),
                                      child: Text(
                                        "Posts",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (_) {
                                        return profilePage(); //update
                                      }));
                                    },
                                    shape: const StadiumBorder(),
                                  ),
                                ),
                                Center(
                                  child: listofwhat != ""
                                      ? RawMaterialButton(
                                          elevation: 80.0,
                                          fillColor: const Color(0XFF2A4793),
                                          splashColor: const Color(0xff2980b9),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10.0,
                                              horizontal: 50.0,
                                            ),
                                            child: Text(
                                              listofwhat,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.0),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (_) {
                                              return Members(
                                                projectId: id,
                                                leader: user,
                                                header:
                                                    "Applicants in " + project,
                                              );
                                            }));
                                          },
                                          shape: const StadiumBorder(),
                                        )
                                      : SizedBox(
                                          width: 3.0,
                                          height: 3.0,
                                        ),
                                ),
                              ],
                            );
                          }
                        }
                        return Center(
                          child: ValueListenableBuilder(
                            builder: (BuildContext context, bool value,
                                Widget child) {
                              return wantToApply.value
                                  ? FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      color: Colors.lightGreen,
                                      textColor: Colors.white,
                                      onPressed: apply,
                                      child: Text('Join'),
                                    )
                                  : FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      color: Colors.blueGrey[200],
                                      textColor: Colors.grey[700],
                                      onPressed: NotApply,
                                      child: Text('Unjoin'),
                                    );
                            },
                            valueListenable: wantToApply,
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
} // there is some missing details , see our class diagram for more info
