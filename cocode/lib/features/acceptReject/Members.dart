import 'package:flutter/material.dart';
import 'MembersData.dart';

class Members extends StatefulWidget {
  var projectId;
  var leader;
  Members({Key key, @required this.projectId, this.leader}) : super(key: key);
  @override
  _MembersState createState() => _MembersState();
}

class _MembersState extends State<Members> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MembersList(
          projectId: widget.projectId,
          leader: widget.leader,
        ),
      ),
    );
  }
}
