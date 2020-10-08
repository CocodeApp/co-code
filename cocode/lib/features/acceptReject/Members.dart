import 'package:cocode/features/viewProject/viewProject.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF2A4793),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              color: Color(0XFF000000),
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return viewProject(id: widget.projectId, tab: widget.leader);
                })); //check
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Text("applicants list"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MembersList(
            projectId: widget.projectId,
            leader: widget.leader,
          ),
        ),
      ),
    );
  }
}
