import 'package:cocode/features/viewProject/skills.dart';
import 'package:cocode/features/viewProject/viewProjectOld.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'teamMembersData.dart';
import 'teamMembers.dart';
import 'skills.dart';

class viewProject extends StatefulWidget {
  var id;
  viewProject({Key key, @required this.id}) : super(key: key);
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
              appBar: AppBar(
                leading: BackButton(
                  color: Colors.white,
                  onPressed: () => (Navigator.pop(context)),
                ),
                backgroundColor: Color(0xff2A4793),
                title: Text(data['projectName']),
                bottom: TabBar(
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
                  ProjectDetails(data),
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

  ProjectDetails(this.data);

  @override
  Widget build(BuildContext context) {
    String deadline;
    data['deadline'] == ''
        ? deadline = 'not assigned yet'
        : deadline = data['deadline'].toString();
    String startdate;
    data['startdate'] == ''
        ? startdate = 'not assigned yet'
        : startdate = data['startdate'];

    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        CircleAvatar(
            radius: 60,
            backgroundColor:
                Color(0xffF57862)), // to be transparent if there is no logo
        SizedBox(
          height: 30,
        ),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Text('project name: ' + data['projectName'])),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                          'project descripion: ' + data['projectDescripion']),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text('start date:' + startdate)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text('dead line:' + deadline)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text('status: ' + data['status'])),
                  ),
                  Center(
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      color: Colors.lightGreen,
                      textColor: Colors.white,
                      onPressed: () {},
                      child: Text('Join'),
                    ),
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
