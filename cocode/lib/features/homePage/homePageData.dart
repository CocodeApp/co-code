import 'package:cocode/features/viewProject/viewProject.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocode/features/viewProject/viewProject.dart';

needTeamMember() {
  return StreamBuilder<QuerySnapshot>(
    //becuase firestore return data in a stream we need a stream builder to read this data
    stream:
        Firestore.instance.collection('projects').snapshots(), //our collection
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.data == null) return CircularProgressIndicator();
      List needMembers = new List<QueryDocumentSnapshot>();
      for (int i = 0; i < snapshot.data.docs.length; i++) {
        if (snapshot.data.docs[i] == null) return CircularProgressIndicator();
        var x = snapshot.data.docs[i].data();
        if (x['supervisor'] != '') {
          needMembers.add(snapshot.data.docs[i]);
        }
      }

      return ListView.builder(
        itemCount: needMembers.length, //the length of our collection
        itemBuilder: (context, index) {
          DocumentSnapshot Projectdata = snapshot.data.docs[index];
          Map getDocs = needMembers[index].data();

          return new Container(
              height: 120.0,
              margin: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 24.0,
              ),
              child: new Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: 124.0,
                    margin: new EdgeInsets.only(left: 70.0),
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
                      //     //A rectangular area of a Material that responds to touch.
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        var ID = needMembers[index].id;

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  viewProject(id: ID, tab: "member"),
                            ));
                        //VIEW PROJECT DETAILS GOES HERE
                      },
                      child: ListTile(
                        //this widget contain the project details

                        title: Text(
                          getDocs['projectName'],
                          textAlign: TextAlign.center,
                        ),
                        subtitle: Text(
                          getDocs['projectDescripion'],
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: new EdgeInsets.symmetric(vertical: 16.0),
                    alignment: FractionalOffset.centerLeft,
                    child: new Image(
                      image: new AssetImage("imeges/logo-3.png"),
                      height: 92.0,
                      width: 92.0,
                    ),
                  ),
                ],
              ));
        },
      );
    },
  );
}

needSupervisor() {
  return StreamBuilder<QuerySnapshot>(
    //becuase firestore return data in a stream we need a stream builder to read this data
    stream:
        Firestore.instance.collection('projects').snapshots(), //our collection
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.data == null) return CircularProgressIndicator();
      List needSupervisor = new List<QueryDocumentSnapshot>();
      for (int i = 0; i < snapshot.data.docs.length; i++) {
        if (snapshot.data.docs[i] == null) return CircularProgressIndicator();
        var x = snapshot.data.docs[i].data();
        if (x['supervisor'] == '') {
          needSupervisor.add(snapshot.data.docs[i]);
        }
      }

      return ListView.builder(
        //dynamic list for the broject in the data base
        itemCount: needSupervisor.length, //the length of our collection
        itemBuilder: (context, index) {
          DocumentSnapshot Projectdata = snapshot.data.docs[index];
          Map getDocs = needSupervisor[index].data();
          return new Container(
              height: 120.0,
              margin: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 24.0,
              ),
              child: new Stack(
                children: <Widget>[
                  Container(
                    clipBehavior: Clip.hardEdge,
                    alignment: Alignment.center,
                    height: 124.0,
                    margin: new EdgeInsets.only(left: 75.0),
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
                      //     //A rectangular area of a Material that responds to touch.
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        var ID = needSupervisor[index].id;

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  viewProject(id: ID, tab: "supervisor"),
                            ));
                        //VIEW PROJECT DETAILS GOES HERE
                      },
                      child: ListTile(
                        //this widget contain the project details

                        title: Text(
                          getDocs['projectName'],
                          textAlign: TextAlign.center,
                        ),
                        subtitle: Text(
                          getDocs['projectDescripion'],
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: new EdgeInsets.symmetric(vertical: 16.0),
                    alignment: FractionalOffset.centerLeft,
                    child: new Image(
                      image: new AssetImage("imeges/logo-2.png"),
                      height: 92.0,
                      width: 92.0,
                    ),
                  ),
                ],
              )); //to map the data in evrey project
        },
      );
    },
  );
}
