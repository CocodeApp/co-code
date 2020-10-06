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
          return SizedBox(
            width: 100,
            child: Card(
              elevation: 0,
              child: ClipPath(
                child: Container(
                  width: 100,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 15, 0, 0),
                    child: Text(
                      skills[index],
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  height: 60,
                  decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(
                              color: index % 2 == 0
                                  ? Colors.indigo
                                  : Colors.deepOrangeAccent,
                              width: 5))),
                ),
                clipper: ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3))),
              ),
            ),
          );
        });
  }
}
