import 'package:cocode/buttons/RoundeButton.dart';
import 'package:flutter/material.dart';

class changeSkills extends StatefulWidget {
  @override
  _changeSkillsState createState() => _changeSkillsState();
}

class _changeSkillsState extends State<changeSkills> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    leading: Container(),
                    centerTitle: true,
                    backgroundColor: Colors.white,
                    title: Text("Change Bio",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xff2A4793))),
                  ),
                  body: Center(
                      child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 100),
                        Container(
                          //box
                          height: 100,
                          width: 250.0,
                          child: ListView(),
                        ),
                        SizedBox(height: 20),
                        RoundedButton(
                            text: "Save",
                            color: Colors.indigo,
                            textColor: Colors.white,
                            press: () {
                           
                            }),
                        SizedBox(height: 20),
                        RoundedButton(
                          text: "Cancel",
                          color: Colors.blue[100],
                          textColor: Colors.black,
                          press: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  )),
                );
  }
}