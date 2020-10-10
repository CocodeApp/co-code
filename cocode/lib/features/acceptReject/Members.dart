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
        backgroundColor: Color(0XFF2A4793),
        leading: BackButton(
          color: Colors.indigo,
          onPressed: () => (Navigator.pop(context)),
        ),
        title: Text(widget.header),
      ),
      body: MembersList(
        projectId: widget.projectId,
        leader: widget.leader,
      ),
    );
  }
}
