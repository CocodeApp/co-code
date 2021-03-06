import 'package:cloud_functions/cloud_functions.dart';
import 'package:cocode/features/homePage/homePageView.dart';
import 'package:cocode/features/userProfile.dart/userProfile.dart';
import 'package:cocode/features/viewProject/viewProject.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MembersList extends StatefulWidget {
  var projectId;
  var leader;
  MembersList({Key key, @required this.projectId, this.leader})
      : super(key: key);
  @override
  _MembersListState createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {
  ValueNotifier<List> tempMember = ValueNotifier<List>([]);
  String role;
  String projectName;
  String projectImg;
  @override
  Widget build(BuildContext context) {
    bool noApplicants = false;
    Future<void> getTempList() async {
      Future<DocumentSnapshot> project = FirebaseFirestore.instance
          .collection("projects")
          .doc(widget.projectId)
          .get();
      await project.then((value) {
        var data = value.data();
        projectImg = data['image'];
      });
      Future<DocumentSnapshot> leaderRef = FirebaseFirestore.instance
          .collection("User")
          .doc(widget.leader)
          .collection("myProjects")
          .doc(widget.projectId)
          .get();
      await leaderRef.then((value) {
        var data = value.data();
        role = data['role'];
        projectName = data['projectName'];
        if (data["tempList"] != null) {
          tempMember.value = data["tempList"];
        } else
          noApplicants = true;
        print(widget.projectId);
      }).catchError((e) {
        print(e.toString());
      });
    }

    getTempList();

    Widget getuserwidget(int index, String id) {
      return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection("User").doc(id).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              if (noApplicants) return Container();
              Map<String, dynamic> data = snapshot.data.data();
              String first = data['firstName'];
              String last = data['lastName'];
              String imgUrl = data['image'];

              String fullName = first + " " + last;
              print(first);
              return Container(
                height: 120.0,
                margin: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                ),
                child: new Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: 90.0,
                      margin: new EdgeInsets.only(left: 40.0, top: 30),
                      decoration: new BoxDecoration(
                        color: new Color(0xFFD1DDED),
                        shape: BoxShape.rectangle,
                        borderRadius: new BorderRadius.circular(8.0),
                        boxShadow: <BoxShadow>[
                          new BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                            offset: new Offset(0.0, 10.0),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40.0),
                        child: ListTile(
                          title: Text(fullName),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return profilePage(
                                userId: id,
                                previousPage: MembersList(),
                              ); //go to the users page
                            }));
                          },
                        ),
                      ),
                    ),
                    Container(
                        margin: new EdgeInsets.symmetric(vertical: 10.0),
                        alignment: FractionalOffset.bottomLeft,
                        child: CircleAvatar(
                          backgroundImage: imgUrl == null
                              ? new AssetImage("imeges/man.png")
                              : NetworkImage(imgUrl),
                          backgroundColor: Colors.white,
                          radius: 40,
                        )),
                    Container(
                      alignment: Alignment.center,
                      height: 90.0,
                      margin: new EdgeInsets.only(left: 230.0, top: 30),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.check_circle),
                            color: Colors.green,
                            onPressed: () async {
                              if (role == "Idea Owner") {
                                //add the supervisor
                                FirebaseFirestore.instance
                                    .runTransaction((transaction) async {
                                  DocumentSnapshot freshsnap = await transaction
                                      .get(FirebaseFirestore.instance
                                          .collection('projects')
                                          .doc(widget.projectId));
                                  transaction.update(freshsnap.reference, {
                                    'supervisor': id,
                                  });
                                });
                                //add the members new temp list to new supervisor
                                FirebaseFirestore.instance
                                    .collection('User')
                                    .doc(id)
                                    .collection('myProjects')
                                    .doc(widget.projectId)
                                    .set({
                                      'image': projectImg,
                                      'projectName':
                                          projectName, //to fill later
                                      'role': "supervisor",
                                      'tempList': [],
                                    })
                                    .then((value) =>
                                        print("project Added to the user"))
                                    .catchError((error) =>
                                        print("Failed to add project: $error"));

                                //sending notification

                                await getToken(id).then((value) async {
                                  var callable = FirebaseFunctions.instance
                                      .httpsCallable('notifyAccepted');
                                  if (value != null) {
                                    print("it exist !!!!!!!!!!!!!!!!!!!");
                                    await callable.call(<String, dynamic>{
                                      'applicatant': value,
                                      'project': projectName,
                                      'role': 'supervisor'
                                    }).catchError((onError) {
                                      print(onError.toString());
                                    });
                                  }
                                });

                                //clean the list "not important"
                                FirebaseFirestore.instance
                                    .runTransaction((transaction) async {
                                  DocumentSnapshot freshsnap = await transaction
                                      .get(FirebaseFirestore.instance
                                          .collection('User')
                                          .doc(widget.leader)
                                          .collection('myProjects')
                                          .doc(widget.projectId));
                                  transaction.update(freshsnap.reference,
                                      {'tempList': FieldValue.delete()});
                                });
                                //nav to project page and remove applicants button
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return viewProject(
                                    id: widget.projectId,
                                    tab: "member",
                                    previouspage: "list of applicants",
                                  );
                                }));
                              } else {
                                //add team member
                                FirebaseFirestore.instance
                                    .runTransaction((transaction) async {
                                  DocumentSnapshot freshsnap = await transaction
                                      .get(FirebaseFirestore.instance
                                          .collection('projects')
                                          .doc(widget.projectId));
                                  List l = [id];
                                  transaction.update(freshsnap.reference, {
                                    'teamMembers': FieldValue.arrayUnion(l)
                                  });
                                });
                                //remove it from the temp list
                                FirebaseFirestore.instance
                                    .runTransaction((transaction) async {
                                  DocumentSnapshot freshsnap = await transaction
                                      .get(FirebaseFirestore.instance
                                          .collection('User')
                                          .doc(widget.leader)
                                          .collection('myProjects')
                                          .doc(widget.projectId));
                                  transaction.update(freshsnap.reference, {
                                    'tempList': FieldValue.arrayRemove([id])
                                  });
                                });
                                //add the project to the user
                                FirebaseFirestore.instance
                                    .collection('User')
                                    .doc(id)
                                    .collection('myProjects')
                                    .doc(widget.projectId)
                                    .set({
                                      'image': projectImg,
                                      'projectName':
                                          projectName, //to fill later
                                      'role': "team member",
                                    })
                                    .then((value) =>
                                        print("project Added to the user"))
                                    .catchError((error) =>
                                        print("Failed to add project: $error"));
                                //notify user
                                await getToken(id).then((value) async {
                                  var callable = FirebaseFunctions.instance
                                      .httpsCallable('notifyAccepted');
                                  if (value != null) {
                                    print("it exist !!!!!!!!!!!!!!!!!!!");
                                    await callable.call(<String, dynamic>{
                                      'applicatant': value,
                                      'project': projectName,
                                      'role': 'member'
                                    }).catchError((onError) {
                                      print(onError.toString());
                                    });
                                  }
                                });

                                //remove it from tempmember
                                tempMember.value.removeAt(index);
                                tempMember.notifyListeners();
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.cancel),
                            color: Colors.red,
                            onPressed: () {
                              //remove from list builder
                              tempMember.value.removeAt(index);
                              tempMember.notifyListeners();
                              //remove it from database
                              FirebaseFirestore.instance
                                  .runTransaction((transaction) async {
                                DocumentSnapshot freshsnap = await transaction
                                    .get(FirebaseFirestore.instance
                                        .collection('User')
                                        .doc(widget.leader)
                                        .collection('myProjects')
                                        .doc(widget.projectId));
                                transaction.update(freshsnap.reference, {
                                  'tempList': FieldValue.arrayRemove([id])
                                });
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return Text("   ");
          });
    }

    return ValueListenableBuilder(
        valueListenable: tempMember,
        builder: (BuildContext context, List<dynamic> nums, Widget child) {
          return ListView.builder(
            itemCount: tempMember.value.length,
            itemBuilder: (context, index) {
              print(index);
              return getuserwidget(index, tempMember.value[index]);
            },
          );
        });
  }

  static Future<List<String>> getToken(userId) async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;

    List<String> token = [];
    await _db
        .collection('User')
        .doc(userId)
        .collection('tokens')
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((doc) {
        token.add(doc.id.toString());
      });
    });

    return token;
  }
}
