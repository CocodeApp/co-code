import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocode/buttons/RoundeButton.dart';
import 'package:flutter/material.dart';

class teamMembersNumber extends StatefulWidget {
  String number;
  var id;
  teamMembersNumber({
    Key key,
    @required this.number,
    @required this.id,
  });
  @override
  _teamMembersNumberState createState() => _teamMembersNumberState();
}

class _teamMembersNumberState extends State<teamMembersNumber> {
  TextEditingController membersCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text("Change team members number",
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
                    tag: 'team members number',
                    child: CircleAvatar(
                      backgroundColor: Color(0xff2A4793),
                      foregroundColor: Colors.white,
                      radius: 40,
                      child: Icon(
                        Icons.people,
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
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(width: 19),
                Flexible(
                  child: TextFormField(
                    onEditingComplete: () => print(membersCtrl.text),
                    onSaved: (newValue) => (print(membersCtrl.text)),
                    controller: membersCtrl,
                    validator: (value) {
                      widget.number = value;
                      print(value);
                      return null;
                    },
                    decoration: new InputDecoration(
                      focusColor: Color(0xffF57862),
                      hoverColor: Color(0xffF57862),
                      labelText:
                          "current team members number: " + widget.number,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50.0),
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 19),
              ],
            )),
            SizedBox(height: 20),
            RoundedButton(
                text: "Save",
                color: Colors.indigo,
                textColor: Colors.white,
                press: () async {
                  widget.number = membersCtrl.text;
                  print("wi" + widget.number);
                  await FirebaseFirestore.instance
                      .collection('projects')
                      .doc(widget.id)
                      .update({
                    'membersNum': membersCtrl.text,
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
