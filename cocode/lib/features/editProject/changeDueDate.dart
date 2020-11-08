import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocode/buttons/RoundeButton.dart';
import 'package:cocode/features/postIdea/form.dart';
import 'package:cocode/services/datepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class changeDueDate extends StatefulWidget {
  var id;
  String startDate;
  String deadline;
  changeDueDate(
      {Key key,
      @required this.id,
      @required this.deadline,
      @required this.startDate});
  @override
  _changeDueDateState createState() => _changeDueDateState();
}

class _changeDueDateState extends State<changeDueDate> {
  String _date = "";
  @override
  void initState() {
    super.initState();
    _date = widget.deadline;
  }

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
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.grey[700],
                                        width: 1,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(30.0)),
                                onPressed: () {
                                  DatePicker.showDatePicker(context,
                                      theme: DatePickerTheme(
                                        containerHeight: 210.0,
                                      ),
                                      showTitleActions: true,
                                      minTime: DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day,
                                          DateTime.now().hour,
                                          DateTime.now().minute),
                                      maxTime: DateTime(
                                          DateTime.now().year + 10, 12, 31),
                                      onConfirm: (date) {
                                    print('confirm $date');

                                    setState(() {
                                      _date =
                                          '${date.year}/${date.month}/${date.day}';
                                    });
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.en);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 50.0,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.date_range,
                                                  size: 30.0,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 10),
                                                  child: Text(
                                                    " deadline : $_date",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0XAA2A4793),
                                                        fontSize: 15.0),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Text(
                                        "  Change",
                                        style: TextStyle(
                                            color: Color(0XDDF57862),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                ),
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            RoundedButton(
                text: "Save",
                color: Colors.indigo,
                textColor: Colors.white,
                press: () async {
                  print("m ldmzgmkfdmb");
                  print(_date);

                  // var parsedStart = DateTime.parse(widget.startDate);
                  // var parsDeadLine = DateTime.parse(_date);
                  // if (parsDeadLine.isBefore(parsedStart)) {
                  //   Fluttertoast.showToast(
                  //       msg: "Dead line can't be before start date",
                  //       gravity: ToastGravity.TOP,
                  //       timeInSecForIosWeb: 1,
                  //       backgroundColor: Colors.red[900],
                  //       textColor: Colors.white,
                  //       fontSize: 16.0);
                  // } else {
                  await FirebaseFirestore.instance
                      .collection('projects')
                      .doc(widget.id)
                      .update({
                    'deadline': _date,
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
