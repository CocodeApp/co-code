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
    // members.add(widget.projectData['ideaOwner']);
    // if (widget.projectData['supervisor'] != "") {
    //   members.add(widget.projectData['supervisor']);
    // }
    return ListView.builder(
      itemCount: members.length, //here
      itemBuilder: (context, index) {
        return InkWell(
          //A rectangular area of a Material that responds to touch.
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            //view Profile goes here
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
                //this widget contain the project details
                leading: CircleAvatar(
                    radius: 30, backgroundColor: Color(0xffF57862)),
                title: Text(members[index]),
                subtitle: members[index] == widget.projectData['supervisor']
                    ? Text('supervisor')
                    : members[index] == widget.projectData['ideaOwner']
                        ? Text('idea owner')
                        : Text('team member')),
          ),
        );
      },
    );
  }
}
