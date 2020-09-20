import 'package:flutter/material.dart';
import 'teamMembersData.dart';
import 'viewProject.dart';

class teamMembers extends StatefulWidget {
  Map<String, dynamic> projectData;
  teamMembers({Key key, @required this.projectData}) : super(key: key);
  @override
  _teamMembersState createState() => _teamMembersState();
}

class _teamMembersState extends State<teamMembers> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: teamMembersList(
          projectData: widget.projectData,
        ),
      ),
    );
  }
}
