import 'package:cocode/buttons/RoundeButton.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../Auth.dart';

class changeSkills extends StatefulWidget {
  List<dynamic> skills;
  var id;
  changeSkills({Key key, @required this.skills, @required this.id});
  @override
  _changeSkillsState createState() => _changeSkillsState();
}

class _changeSkillsState extends State<changeSkills> {
  double _currentSliderValue = 0;
  final ValueNotifier<List<Map<String, String>>> skillsNotifier =
      ValueNotifier<List<Map<String, String>>>([]);
  TextEditingController eCtrl = new TextEditingController();
  @override
  void initState() {
    if (widget.skills != null) {
      widget.skills.forEach((value) {
        skillsNotifier.value
            .add({'name': value['name'], 'value': value['value']});
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text("Change skills",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xff2A4793))),
      ),
      body: Center(
        child: Container(
          child: ListView(
            children: [
              SizedBox(height: 100),
              skillBuilder(),
              SizedBox(height: 20),
              RoundedButton(
                  text: "Save",
                  color: Colors.indigo,
                  textColor: Colors.white,
                  press: () async {
                    String uID = Auth.getCurrentUserID();
                    await FirebaseFirestore.instance
                        .collection('User')
                        .doc(uID)
                        .update({
                      'skills': skillsNotifier.value,
                    });
                    Navigator.of(context).pop();
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
        ),
      ),
    );
  }

  Widget skillBuilder() {
    return Container(
      child: ValueListenableBuilder(
        valueListenable: skillsNotifier,
        builder: (context, List<Map<String, dynamic>> skills, Widget child) {
          return Material(
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Wrap(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: skillsNotifier.value.length,
                    itemBuilder: (context, Index) {
                      return Container(
                        height: 60,
                        child: Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                          color: Color(0xffF57862), width: 3))),
                              child: Stack(
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Positioned(
                                      left: 2,
                                      top: 15,
                                      child: Icon(
                                        Icons.assignment,
                                        color: Colors.grey[700],
                                      )),
                                  Positioned(
                                      left: 35,
                                      top: 15,
                                      child: Text(
                                          skillsNotifier.value[Index]['name'])),
                                  Positioned(
                                    left: 150,
                                    child: Slider(
                                      activeColor: Colors.indigo,
                                      inactiveColor: Colors.indigo[100],
                                      value: double.parse(
                                          skillsNotifier.value[Index]['value']),
                                      min: 0,
                                      max: 100,
                                      divisions: 10,
                                      label: skillsNotifier.value[Index]
                                          ['value'],
                                      onChanged: (double value) {
                                        setState(() {
                                          skillsNotifier.value[Index]['value'] =
                                              value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    left: 320,
                                    child: IconButton(
                                        icon: Icon(Icons.delete),
                                        color: Color(0XAAF57862),
                                        onPressed: () {
                                          skillsNotifier.value.removeAt(Index);
                                          skillsNotifier.notifyListeners();
                                        }),
                                  ),
                                  Text('')
                                ],
                              )),
                        ),
                      );
                    },
                  ),
                  Theme(
                    data: ThemeData(
                      primaryColor: Color(0xff2A4793),
                    ),
                    child: newSkill(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget newSkill() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: EdgeInsets.all(15.0),
          child: Container(
            width: 100,
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Skill name",
                contentPadding: EdgeInsets.all(13.0),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffF57862),
                    width: 10.0,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(50.0),
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              controller: eCtrl,
              validator: (value) {
                if (eCtrl.text.trim().isEmpty) {
                  return "skill field can't be empty";
                }
                return null;
              },
            ),
          ),
        ),
        Container(
          width: 200,
          child: Slider(
            activeColor: Colors.indigo,
            inactiveColor: Colors.indigo[100],
            value: _currentSliderValue,
            min: 0,
            max: 100,
            divisions: 10,
            label: _currentSliderValue.round().toString(),
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
              });
            },
          ),
        ),
        IconButton(
            focusColor: Color(0XCC2A4793),
            hoverColor: Color(0XFF2A4793),
            icon: Icon(Icons.add),
            onPressed: () {
              if (eCtrl.text == "" || eCtrl.text.trim().isEmpty) {
                Fluttertoast.showToast(
                    msg: "skill field can't be empty",
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red[900],
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                skillsNotifier.value.add({
                  'name': eCtrl.text,
                  'value': _currentSliderValue.toString()
                });
                eCtrl.clear();
                skillsNotifier.notifyListeners();
              }
            })
      ],
    );
  }
}
