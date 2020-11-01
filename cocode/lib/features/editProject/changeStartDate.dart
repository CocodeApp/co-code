import 'package:cocode/buttons/RoundeButton.dart';
import 'package:cocode/services/datepicker.dart';
import 'package:flutter/material.dart';

class changeStartDate extends StatefulWidget {
  @override
  _changeStartDateState createState() => _changeStartDateState();
}

class _changeStartDateState extends State<changeStartDate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text("Change due date",
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
                    tag: 'due date',
                    child: CircleAvatar(
                      backgroundColor: Color(0xff2A4793),
                      foregroundColor: Colors.white,
                      radius: 40,
                      child: Icon(
                        Icons.calendar_today,
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
              child: Container(
                width: 330.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: 330.0,
                        child: mydatepicker("dead line", (DateTime deadLine) {
                          setState(() {
                            //نجد
                            // var startdate = deadLine;
                          });
                        })),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            RoundedButton(
                text: "Save",
                color: Colors.indigo,
                textColor: Colors.white,
                press: () {
                  //najd
                  // fAfter = _editNameFormBloc._firstnameFieldBloc.value;
                  // lAfter = _editNameFormBloc._lastnameFieldBloc.value;

                  // hasChanged = (fBefore != fAfter) || (lBefore != lAfter);
                  // if (isEnabled && hasChanged)
                  //   _editNameFormBloc.submit();
                  // else
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
