import 'package:flutter/material.dart';
import 'viewProject.dart';
import 'teamMembers.dart';

class skills extends StatefulWidget {
  Map<String, dynamic> projectData;
  skills({Key key, @required this.projectData}) : super(key: key);
  @override
  _skillsState createState() => _skillsState();
}

class _skillsState extends State<skills> {
  @override
  Widget build(BuildContext context) {
    List skills = widget.projectData['requiredSkills'];
    print(skills[0]);

    return ListView.builder(
      itemCount: skills.length, //here
      itemBuilder: (context, index) {
        return Container(
          height: 50.0,
          margin: new EdgeInsets.all(10.0),
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
          child: ListTile(
            //this widget contain the project details

            title: Center(
                child: Text(skills[index],
                    style: new TextStyle(fontWeight: FontWeight.bold))),
          ),
        );
      },
    );
  }
}
