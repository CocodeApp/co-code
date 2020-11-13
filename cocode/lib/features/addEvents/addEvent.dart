import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';

import '../../Auth.dart';
import 'GoogleAuthClient.dart';

Future<bool> addEvent(String summary, DateTime startTime, DateTime endTime,
    List attendeeslist) async {
  try {
    print("inside add event ");

    final googleSignIn =
        GoogleSignIn.standard(scopes: [CalendarApi.CalendarScope]);
    final GoogleSignInAccount account = await googleSignIn.signIn();
    print("User account $account");
    final authHeaders = await account.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);

    Event event = Event(); //event object to be inserted
    event.summary = summary; //summary or event title
    print("summary: " + event.summary);
    EventDateTime start = new EventDateTime(); //Setting start time
    start.dateTime = DateTime(startTime.year, startTime.month, startTime.day,
        startTime.hour, startTime.minute);
    start.timeZone = "GMT+3:00";
    event.start = start;
    print("start: " + event.start.toString());

    EventDateTime end = new EventDateTime(); //setting end time
    end.timeZone = "GMT+03:00";
    end.dateTime = DateTime(
        endTime.year, endTime.month, endTime.day, endTime.hour, endTime.minute);

    event.end = end;
    print("end: " + event.end.toString());

    List<EventAttendee> attendees = new List<EventAttendee>();
    //loop
    var len = attendeeslist.length;
    print("num of attendees:" + len.toString());
    Map<dynamic, dynamic> map;
    for (var i = 0; i < len; i++) {
      map = {"email": attendeeslist[i]};
      attendees.add(EventAttendee.fromJson(map));
    }

    map = {"email": Auth.getCurrentUserEmail()};
    attendees.add(EventAttendee.fromJson(map));
    //out of the loop
    event.attendees = attendees; //list of attendens
    print("attendees:" + event.attendees.toString());

    // Map<dynamic, dynamic> map = {"email": "latifah.a.alomar@gmail.com"};
    // EventAttendee.fromJson(map);

    // event.attendees.add() //list of attendens

    var calendar = CalendarApi(authenticateClient);
    String calendarId = "primary";
    calendar.events.insert(event, calendarId).then((value) {
      print("ADDEDDD_________________${value.status}");
      if (value.status == "confirmed") {
        return true;
      } else {
        return false;
      }
    });
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}
