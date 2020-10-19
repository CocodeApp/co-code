import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_functions/cloud_functions.dart';

class addEvent extends StatefulWidget {
  @override
  _addEventState createState() => _addEventState();
}

class _addEventState extends State<addEvent> {
  @override
  Widget build(BuildContext context) {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'addEventToCalendar',
    );

    return Scaffold(
      body: Center(
        child: FlatButton(
          child: Text('add event'),
          onPressed: () async {
            try {
              final HttpsCallableResult result = await callable.call(
                <String, dynamic>{
                  "eventName": "test",
                  "description": "This is a sample description",
                  "startTime": "2020-12-01T10:00:00",
                  "endTime": "2020-12-01T13:00:00"
                },
              );
              print(result.data);
            } on CloudFunctionsException catch (e) {
              print('caught firebase functions exception');
              print(e.code);
              print(e.message);
              print(e.details);
            } catch (e) {
              print('caught generic exception');
              print(e);
            }
          },
        ),
      ),
    );
  }
}
