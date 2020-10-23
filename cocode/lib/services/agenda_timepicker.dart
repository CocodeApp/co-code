import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:cocode/features/addEvents/addEventForm.dart';

class mytimepicker extends StatefulWidget {
  String lable;
  final Function(DateTime) onDateChange;

  mytimepicker(this.lable, this.onDateChange);
  @override
  State<StatefulWidget> createState() => _datepickerstate();
}
//https://medium.com/enappd/building-a-flutter-datetime-picker-in-just-15-minutes-6a4b13d6a6d1

class _datepickerstate extends State<mytimepicker> {
  String _date;
  _datepickerstate();

  @override
  void initState() {
    super.initState();
    _date = "Not Set Yet";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              DatePicker.showTimePicker(context,
                  theme: DatePickerTheme(
                    containerHeight: 210.0,
                  ),
                  showTitleActions: true, onConfirm: (date) {
                if (widget.lable.compareTo("endTime") == 0) {
                  endtime = date;
                } else {
                  print("else");
                  starttime = date;
                }
                print('confirm $date');
                _date = '${date.hour}:${date.minute}';

                setState(() {});
              }, currentTime: DateTime.now(), locale: LocaleType.en);
            },
            child: Container(
              alignment: Alignment.center,
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.access_time,
                              size: 30.0,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10),
                              child: Text(
                                widget.lable + " : " + _date,
                                style: TextStyle(
                                    color: Color(0XAA2A4793), fontSize: 15.0),
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
    );
  }
}
