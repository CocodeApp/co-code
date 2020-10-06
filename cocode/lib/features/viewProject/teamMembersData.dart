import 'package:cocode/features/homePage/homePageView.dart';
import 'package:cocode/features/userProfile.dart/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class teamMembersList extends StatefulWidget {
  Map<String, dynamic> projectData;
  teamMembersList({Key key, @required this.projectData}) : super(key: key);
  @override
  _teamMembersListState createState() => _teamMembersListState();
}

class _teamMembersListState extends State<teamMembersList> {
  @override
  Widget build(BuildContext context) {
    List members = widget.projectData['teamMembers'];
    List<Map<String, String>> allmembers = new List<Map<String, String>>();
    Map<String, String> singleMap = {
      "Role": "Idea Owner",
      "Id": widget.projectData['ideaOwner']
    };
    allmembers.add(singleMap);
    if (widget.projectData['supervisor'] != "") {
      allmembers
          .add({"Role": "Supervisor", "Id": widget.projectData['supervisor']});
    }
    for (int i = 0; members.length > i; i++) {
      allmembers.add({"Role": "Team member", "Id": members[i]});
    }

    Widget getuserFullNamewidget(String id) {
      return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection("User").doc(id).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = snapshot.data.data();
              String first = data['firstName'];
              String last = data['lastName'];
              String fullName = first + " " + last;
              print(first);
              return Text(fullName);
            }
            return Text("  ");
          });
    }

    return ListView.builder(
      itemCount: allmembers.length, //here
      itemBuilder: (context, index) {
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
                  child: InkWell(
                    //A rectangular area of a Material that responds to touch.
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      //view Profile goes here
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: ListTile(
                        //this widget contain the project details

                        title: getuserFullNamewidget(allmembers[index]["Id"]),
                        subtitle: Text(allmembers[index]["Role"]),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return profilePage(); //sa
                          }));
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: new EdgeInsets.symmetric(vertical: 10.0),
                  alignment: FractionalOffset.bottomLeft,
                  child: new Image(
                    image: new AssetImage("imeges/man.png"),
                    height: 70.0,
                    width: 70.0,
                  ),
                ),
              ],
            ));
      },
    );
  }
}
