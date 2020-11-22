import 'package:cocode/features/viewProject/viewProject.dart';
import 'package:flutter/material.dart';
import 'MembersData.dart';

class Members extends StatefulWidget {
  var projectId;
  var leader;

  var header;
  Members({Key key, @required this.projectId, this.leader, this.header})
      : super(key: key);
  @override
  _MembersState createState() => _MembersState();
}

class _MembersState extends State<Members> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.deepOrangeAccent,
          onPressed: () =>
              (Navigator.pop(context, MaterialPageRoute(builder: (_) {
            return viewProject(
              id: widget.projectId,
              tab: "member",
              previouspage: "list of applicants",
            );
          }))),
        ),
        title: Text(widget.header, style: TextStyle(color: Colors.indigo)),
      ),
      body: MembersList(
        projectId: widget.projectId,
        leader: widget.leader,
      ),
    );
  }
}
