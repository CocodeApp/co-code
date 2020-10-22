import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/auth_io.dart';

class addEvent extends StatefulWidget {
  @override
  _addEventState createState() => _addEventState();
}

class _addEventState extends State<addEvent> {
  @override
  Widget build(BuildContext context) {
    final _credentials = new ServiceAccountCredentials.fromJson(r'''
{
  "private_key_id": "b0b2ad334e8fc7a9d503b8e65ed524bd60995461",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDO0xLw4zqBq5mj\nxijXaHlBUp3QYEvw+1y5WHqLyQZczW9zgResQmAlU+m9WebeIqaKc3wo4My1phm2\n43TRKT8ZEIocH6PaBeuR2mNwm+4Z7tDRIqx524FKkgGA4RLWBIQNVenRe/lwx/dI\nET0SDSIVry3AmIIUO4bfnzJ9Vt3ljKBZQmOviMMVJQvxYG4C1lySmZMxXM9iUkkT\nLjnG4ZEJrFhhFzwFiBkPI1MGP/x7rDs3xcMpqGLKpxjrfC6bwIKvONqmpCmskm09\nqUctzwvAQRaBOBpbkr8E9Iji+Rgqxgh6C9KsqoUifVP5a5B6XcxZ/vihJk/kzoZA\n40B63ZfLAgMBAAECggEAIQcI28nVgnaGMuaGiBuJXXqVc/yks+dX/8sWyrK/3tr5\nhL7lKl9xHhTf2xp7qRZsdOiLN7XqSsmrCo8ZDPuitVx0SZht4HeYjjKLNaTY6XA/\nDV6Vn2IDrAZT0iJfESkocz64d3juNOnh3bLPB05slnzieAKCpzt4RsaT1/sitTCt\nvunrsOKBWpRWEBaN8KsIbRbXjBJrLnJGb/gvV09xyCPHXwtjQw9QBCJvebR8PywU\n/X+PMd3vbTjwSmBknIkBvCjV5L/nJvmxGdrvTm3tTDbcqq91J3CCnkmeNDXmbYTM\ndTxlrwTK8r+FID7ufB9pPOxgZDi5XkL/ubIiDedDuQKBgQDmkWHz+5xLmfw/uhGg\nye6d1w03H9zsYFbM+ESTDS6SsRwSQAZNv6raK5aSLGd/SGUGtZT9s/fHAsrXQvWj\ntQlUdq5PeZXXXqI4Qm6rIpOHAa+TEhfeU1EMASd5fmg4HviYb83sAnaN39+lfyaE\nfCyRL97IOb25XO1G6CcvIKjXqQKBgQDloz3mh0oJpc2T9PQfcY7vl1OkiYH1sxI5\ndEqYnH9j3uEU57KvndNJvR9MZj4NvQlKHkCne/LkOzYHe0ej/PKwN20tMYmPYAgB\nhpvTvuILsa+EpM2h7azmTY7w2EcVjqcem38nUXU3nfFtkB/fSd2v1j67y13u0wQe\nDMxEbT3MUwKBgAbqqZOWIrQp5GVNAaZfKGdXwi+7Jvd4VGJFuFjo9lK0OXFatlWy\nwD9XO2cbKeeplk5DODr8IRy5OriGa7QDhEoiXUxJC3OwhRFG/ObpXJ+aL1gsHMcw\nnKfNiQ+d+SZl13NLN1QzJrdO1fiy/cbPqs6YLwi2orhiz0NnR3WkdywxAoGAUtqp\nVOnvXrfCCuZQxp+UcQHqne03RM1NgAljeNjOZdxe3coTgKWzPGHOTyR8szxHg8SS\nk1t3cb2jauOiH5r+fXIiJDJBbce6W8KTqryuloWPzI4h25ED1zyYnHGMhEyqI7L7\nF9aeMmj8WQmtVkUyhWUJ0Xw48hiU3brEYNQBfh0CgYEAk+vZQAx8xQVDtQ90mXJF\nLfOHdrxATnsGoLevBaXdI75iy9i5eYjtF5cGKB+6CcjqtzsoIUCNKejo980chEb6\nEWXivtjNLFqik8o14nm0LoT5yIS1E18izicYLwX+IOEFoaAoOLkkmneRyjA8SC0B\nYBjdywypUIeX3OSAxKnnygI=\n-----END PRIVATE KEY-----\n",
  "client_email": "co-code-f2f18@appspot.gserviceaccount.com",
  "client_id":  "107944211822142345691",
  "type": "service_account"
}
''');
    const _SCOPES = const [CalendarApi.CalendarScope];

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
                <String, Object>{
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