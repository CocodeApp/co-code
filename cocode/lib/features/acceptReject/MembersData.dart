import 'package:cocode/features/homePage/homePageView.dart';
import 'package:cocode/features/userProfile.dart/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MembersList extends StatefulWidget {
  var projectId;
  var leader;
  MembersList({Key key, @required this.projectId, this.leader}) : super(key: key);
  @override
  _MembersListState createState() => _MembersListState();
}

class _MembersListState extends State<MembersList> {
  List<String> tempMember;
  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> allmembers = new List<Map<String, String>>();
    Future<void> getTempList() async{
      Future<DocumentSnapshot> leaderRef = FirebaseFirestore.instance.collection("User").doc(widget.leader).collection("myProjects").doc(widget.projectId).get();
      await leaderRef.then((value) {
        var data = value.data();
        return tempMember = data["tempList"];
      }).catchError((e){
        print(e.toString());
      });
    }
    getTempList();
    print(tempMember.length);
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
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: ListTile(
                            //this widget contain the project details
                            title: Text("Username"),
                            subtitle: Text("User role"),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                    return profilePage(); //sa
                                  }));
                            },
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
                      Container(
                        alignment: Alignment.center,
                        height: 90.0,
                        margin: new EdgeInsets.only(left: 230.0, top: 30),
                        child: Row (
                          children: [
                            IconButton(
                              icon: Icon(Icons.check_circle),
                              color: Colors.green,
                              onPressed: () {  },),
                            IconButton(
                              icon: Icon(Icons.cancel),
                              color: Colors.red,
                              onPressed: () {  }, ),
                          ],
                        ),
                      ),
                    ],
                  ));
            },
          );
  }
}
