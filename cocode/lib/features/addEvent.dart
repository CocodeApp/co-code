import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'GoogleAuthClient.dart';

class signIn extends StatefulWidget {
  @override
  _signInState createState() => _signInState();
}

class _signInState extends State<signIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          child: Text("add event"),
          onPressed: () async {
            addEvent(
              "latifah",
              new DateTime(2020, 10, 23, 6, 8),
              new DateTime(2020, 10, 23, 6, 8),
              "riadh",
            );
          },
        ),
      ),
    );
  }

  Future addEvent(
    String summary,
    DateTime startTime,
    DateTime endTime,
    String location,
  ) async {
    final googleSignIn = GoogleSignIn.standard(scopes: [
      CalendarApi.CalendarScope
    ]); //sign in the user to take permission
    final GoogleSignInAccount account =
        await googleSignIn.signIn(); //user account
    print("User account $account");
    final authHeaders = await account.authHeaders;
    final authenticateClient =
        GoogleAuthClient(authHeaders); //authntecated google client

    Event event = Event(); //event object to be inserted
    event.summary = summary; //summary or event title

    EventDateTime start = new EventDateTime(); //Setting start time
    start.dateTime = DateTime(2020, 10, 23, 7, 20);
    start.timeZone = "GMT+3:00";
    event.start = start;

    EventDateTime end = new EventDateTime(); //setting end time
    end.timeZone = "GMT+03:00";
    end.dateTime =
        start.dateTime = start.dateTime = DateTime(2020, 10, 23, 10, 20);

    event.end = end;
    // Map<dynamic, dynamic> map = {"email": "latifah.a.alomar@gmail.com"};
    // event.attendees = [EventAttendee.fromJson(map)]; //list of attendens

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
}
