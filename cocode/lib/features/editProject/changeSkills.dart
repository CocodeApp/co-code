import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocode/buttons/RoundeButton.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class changeSkills extends StatefulWidget {
  List<dynamic> skills;
  var id;
  changeSkills({@required this.skills, @required this.id});
  @override
  _changeSkillsState createState() => _changeSkillsState();
}

class _changeSkillsState extends State<changeSkills> {
  final ValueNotifier<List<String>> skillsNotifier =
      ValueNotifier<List<String>>([]);
  TextEditingController eCtrl = new TextEditingController();
  TextEditingController membersCtrl = new TextEditingController();
  @override
  void initState() {
    super.initState();

    widget.skills.forEach((dynamic value) {
      skillsNotifier.value.add(value);
    });
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
          child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Container(
                width: 250.0,
                child: GestureDetector(
                  child: Hero(
                    tag: 'skills',
                    child: CircleAvatar(
                      backgroundColor: Color(0xff2A4793),
                      foregroundColor: Colors.white,
                      radius: 40,
                      child: Icon(
                        Icons.assignment,
                        color: Colors.white,
                        size: 50.0,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                )),
            SizedBox(height: 20),
            Center(
              child: ValueListenableBuilder(
                valueListenable: skillsNotifier,
                builder:
                    (BuildContext context, List<String> nums, Widget child) {
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
                              return Card(
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
                                              color: Color(0xffF57862),
                                              width: 3))),
                                  child: ListTile(
                                    leading: Icon(Icons.assignment),
                                    title: Text(skillsNotifier.value[Index]),
                                    trailing: IconButton(
                                        icon: Icon(Icons.delete),
                                        color: Color(0XAAF57862),
                                        onPressed: () {
                                          skillsNotifier.value.removeAt(Index);
                                          skillsNotifier.notifyListeners();
                                        }),
                                  ),
                                ),
                              );
                            },
                          ),
                          Theme(
                            data: ThemeData(
                              primaryColor: Color(0xff2A4793),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      focusColor: Color(0XCC2A4793),
                                      hoverColor: Color(0XFF2A4793),
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        if (eCtrl.text == "" ||
                                            eCtrl.text.trim().isEmpty) {
                                          Fluttertoast.showToast(
                                              msg: "skill field can't be empty",
                                              gravity: ToastGravity.TOP,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red[900],
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        } else {
                                          skillsNotifier.value.add(
                                            eCtrl.text,
                                          );
                                          eCtrl.clear();
                                          skillsNotifier.notifyListeners();
                                        }
                                      }),
                                  hintText: "Add a New Skill",
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
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            RoundedButton(
                text: "Save",
                color: Colors.indigo,
                textColor: Colors.white,
                press: () async {
                  await FirebaseFirestore.instance
                      .collection('projects')
                      .doc(widget.id)
                      .update({
                    'requiredSkills': skillsNotifier.value,
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
      )),
    );
  }
}
