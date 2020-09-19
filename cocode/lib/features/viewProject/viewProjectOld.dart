import 'package:cocode/features/viewProject/skills.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'teamMembersData.dart';
import 'teamMembers.dart';
import 'skills.dart';

class viewProject extends StatelessWidget {
  var id;
  viewProject({this.id});
  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('projects');
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(id).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            Widget cardWidget = ProjectDetails(data);
            return Scaffold(
              appBar: AppBar(
                leading: BackButton(
                  color: Colors.white,
                  onPressed: () => (Navigator.pop(context)),
                ),
                backgroundColor: Color(0xff2A4793),
                title: Text(data['projectName']),
              ),
              body: ListView(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.business_center),
                          iconSize: 40,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => skills(
                                    projectData: data,
                                  ),
                                ));
                          },
                        ),
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors
                              .lightGreen, // to be transparent if there is no logo
                        ),
                        IconButton(
                          icon: Icon(Icons.people),
                          iconSize: 40,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => teamMembers(
                                    projectData: data,
                                  ),
                                ));
                          },
                        ),
                      ]),
                  teamMembers(
                    projectData: data,
                  ),
                ],
              ),
            );
          }

          return Scaffold(
              body: Column(
            children: [
              Center(child: CircularProgressIndicator()),
            ],
          ));
        });
  }
}

class ProjectDetails extends StatelessWidget {
  Map<String, dynamic> data;

  ProjectDetails(this.data);

  @override
  Widget build(BuildContext context) {
    DateTime deadline = data['deadline'].toDate();
    DateTime startdate = data['startdate'].toDate();

    return Column(
      children: [
        SizedBox(
          width: 350,
          height: 350,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            shadowColor: Colors.grey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['projectName']),
                  Text(data['projectDescripion']),
                  Text(startdate.toString()),
                  Text(deadline.toString()),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    color: Colors.lightGreen,
                    textColor: Colors.white,
                    onPressed: () {},
                    child: Text('Join'),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
} // there is some missing details , see our class diagram for more info
