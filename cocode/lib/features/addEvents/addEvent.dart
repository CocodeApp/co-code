import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';

import 'GoogleAuthClient.dart';

class addEvent extends StatefulWidget {
  @override
  _addEventState createState() => _addEventState();
}

class _addEventState extends State<addEvent> {
  @override
  Widget build(BuildContext context) {
    Future<void> addEvent(String summary, DateTime startTime, DateTime endTime,
        String location, List attendees) async {
      final googleSignIn =
          GoogleSignIn.standard(scopes: [CalendarApi.CalendarScope]);
      final GoogleSignInAccount account = await googleSignIn.signIn();
      print("User account $account");
      final authHeaders = await account.authHeaders;
      final authenticateClient = GoogleAuthClient(authHeaders);

      Event event = Event(); //event object to be inserted
      event.summary = summary; //summary or event title

      EventDateTime start = new EventDateTime(); //Setting start time
      start.dateTime = DateTime(2020, 10, 23, 7, 20);
      start.timeZone = "GMT+3:00";
      event.start = start;

      EventDateTime end = new EventDateTime(); //setting end time
      end.timeZone = "GMT+03:00";
      end.dateTime = DateTime(2020, 10, 23, 7, 20);

      event.end = end;

      // Map<dynamic, dynamic> map = {"email": "latifah.a.alomar@gmail.com"};
      //EventAttendee.fromJson(map)

      // event.attendees.add() //list of attendens

      event.location = location;

      var calendar = CalendarApi(authenticateClient);
      String calendarId = "primary";
      calendar.events.insert(event, calendarId).then((value) {
        print("ADDEDDD_________________${value.status}");
        if (value.status == "confirmed") {
          print('Event added in google calendar');
        } else {
          print("Unable to add event in google calendar");
        }
      });
    }

    // return Scaffold(
    //   body: Center(
    //     child: FlatButton(
    //       child: Text("add event"),
    //       onPressed: () async {
    //         addEvent();
    //       },
    //     ),
    //   ),
    // );
  }
}
