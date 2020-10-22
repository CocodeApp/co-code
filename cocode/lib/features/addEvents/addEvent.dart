import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';

import 'GoogleAuthClient.dart';

class signIn extends StatefulWidget {
  @override
  _signInState createState() => _signInState();
}

class _signInState extends State<signIn> {
  @override
  Widget build(BuildContext context) {
    Future<void> signIn() async {
      final googleSignIn =
          GoogleSignIn.standard(scopes: [CalendarApi.CalendarScope]);
      final GoogleSignInAccount account = await googleSignIn.signIn();
      print("User account $account");
      final authHeaders = await account.authHeaders;
      final authenticateClient = GoogleAuthClient(authHeaders);
      final driveApi = CalendarApi(authenticateClient);
      Event event = Event();
      event.summary = "test";
      EventDateTime start = new EventDateTime(); //Setting start time
      start.dateTime = new DateTime(2020 - 10 - 23, 6, 30);
      start.timeZone = "GMT+05:00";
      event.start = start;

      EventDateTime end = new EventDateTime(); //setting end time
      end.timeZone = "GMT+05:00";
      end.dateTime = start.dateTime = new DateTime(2020 - 10 - 23, 7, 30);
      event.end = end;
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

    return Scaffold(
      body: Center(
        child: FlatButton(
          child: Text("sign"),
          onPressed: () async {
            signIn();
          },
        ),
      ),
    );
  }
}
