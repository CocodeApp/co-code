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
      List needMembers = new List<QueryDocumentSnapshot>();
      for (int i = 0; i < snapshot.data.docs.length; i++) {
        var x = snapshot.data.docs[i].data();
        if (x['supervisor'] != '') {
          needMembers.add(snapshot.data.docs[i]);
        }
      }
      if (!snapshot.hasData) {
        return Center(
            child: CircularProgressIndicator()); //if there is no data yet
      }

      return ListView.builder(
        itemCount: needMembers.length, //the length of our collection
        itemBuilder: (context, index) {
          DocumentSnapshot Projectdata = snapshot.data.docs[index];
          Map getDocs = needMembers[index].data();

          //to map the data in evrey project
          return InkWell(
            //A rectangular area of a Material that responds to touch.
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              var ID = needMembers[index].id;

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => viewProject(id: ID),
                  ));
              //VIEW PROJECT DETAILS GOES HERE
            },
            child: ListTile(
              //this widget contain the project details
              leading:
                  CircleAvatar(radius: 30, backgroundColor: Color(0xffF57862)),
              title: Text(getDocs['projectName']),
              subtitle: Text(getDocs['projectDescripion']),
            ),
          );
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
      List needSupervisor = new List<QueryDocumentSnapshot>();
      for (int i = 0; i < snapshot.data.docs.length; i++) {
        var x = snapshot.data.docs[i].data();
        if (x['supervisor'] == '') {
          needSupervisor.add(snapshot.data.docs[i]);
        }
      }
      if (!snapshot.hasData) {
        return Center(
            child: CircularProgressIndicator()); //if there is no data yet
      }

      return ListView.builder(
        //dynamic list for the broject in the data base
        itemCount: needSupervisor.length, //the length of our collection
        itemBuilder: (context, index) {
          DocumentSnapshot Projectdata = snapshot.data.docs[index];
          Map getDocs =
              needSupervisor[index].data(); //to map the data in evrey project
          return InkWell(
            //A rectangular area of a Material that responds to touch.
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              var ID = needSupervisor[index].id;

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => viewProject(id: ID),
                  ));
              //VIEW PROJECT DETAILS GOES HERE
            },
            child: ListTile(
              //this widget contain the project details
              leading:
                  CircleAvatar(radius: 30, backgroundColor: Color(0xffF57862)),
              title: Text(getDocs['projectName']),
              subtitle: Text(getDocs['projectDescripion']),
            ),
          );
        },
      );
    },
  );
}
