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

              title: Center(child: Text(skills[index])),
            ),
          ),
        );
      },
    );
  }
}
