import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class event extends StatelessWidget {
  Map<String, dynamic> eventDetails;

  event({
    Key key,
    @required this.eventDetails,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String eventName = eventDetails['name'];
    String eventDescription = eventDetails['description'];

    DateTime startdatetime =
        DateTime.tryParse(eventDetails['startdate'].toDate().toString());
    DateTime enddatetime =
        DateTime.tryParse(eventDetails['enddate'].toDate().toString());
    String startdate = DateFormat.yMMMMd().format(startdatetime);
    String enddate = DateFormat.yMMMMd().format(enddatetime);
    String starttime = DateFormat.jm().format(startdatetime);
    String endtime = DateFormat.jm().format(enddatetime);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
          child: BackButton(
            //change
            color: Colors.indigo,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: const Color(0xffd3deed),
      body: Stack(
        children: <Widget>[
          //white window
          Transform.translate(
            offset: Offset(0.0, 100.0),
            child: Container(
              width: 455.0,
              height: 679.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: const Color(0xffffffff),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x3d000000),
                    offset: Offset(10, 10),
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          //name
          Transform.translate(
            offset: Offset(55.2, 150.0),
            child: SizedBox(
              width: 274.0,
              child: Column(
                children: [
                  Text(
                    eventDetails['name'],
                    style: TextStyle(
                      fontFamily: 'Microsoft Sans Serif',
                      fontSize: 35,
                      color: const Color(0xff656d78),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 2,
                  ),
                ],
              ),
            ),
          ),

          Transform.translate(
            offset: Offset(25.2, 290.0),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 10.0,
                    ),
                    Icon(Icons.assignment, size: 35.0),
                    SizedBox(
                      width: 10.0,
                    ),
                    SizedBox(
                      width: 284.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'event description : ',
                            style: TextStyle(
                              fontFamily: 'Microsoft PhagsPa',
                              fontSize: 15,
                              color: const Color(0xff000000),
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            eventDetails['description'],
                            style: TextStyle(
                              fontFamily: 'Microsoft PhagsPa',
                              fontSize: 15,
                              color: const Color(0xff656d78),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50.0,
                ),
                SizedBox(
                  width: 384.0,
                  child: Row(
                    children: [
                      Icon(Icons.alarm, size: 35.0),
                      SizedBox(
                        width: 5.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'event dates : ',
                            style: TextStyle(
                              fontFamily: 'Microsoft PhagsPa',
                              fontSize: 15,
                              color: const Color(0xff000000),
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            'From ' +
                                startdate +
                                ' at ' +
                                starttime +
                                '\n' +
                                'To ' +
                                enddate +
                                ' at ' +
                                endtime,
                            style: TextStyle(
                              fontFamily: 'Microsoft PhagsPa',
                              fontSize: 15,
                              color: const Color(0xff656d78),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const String _svg_ic2bg4 =
    '<svg viewBox="20.3 20.0 13.5 23.6" ><path transform="translate(9.0, 13.81)" d="M 15.32109355926514 18 L 24.2578125 9.0703125 C 24.91875076293945 8.409375190734863 24.91875076293945 7.340624809265137 24.2578125 6.686718940734863 C 23.59687423706055 6.025781631469727 22.52812576293945 6.032812595367432 21.8671875 6.686718940734863 L 11.7421875 16.8046875 C 11.10234355926514 17.44453048706055 11.08828163146973 18.47109413146973 11.69296836853027 19.13203048706055 L 21.86015701293945 29.3203125 C 22.19062614440918 29.65078163146973 22.62656402587891 29.8125 23.05546951293945 29.8125 C 23.484375 29.8125 23.92031288146973 29.65078163146973 24.25078201293945 29.3203125 C 24.91172027587891 28.65937423706055 24.91172027587891 27.59062576293945 24.25078201293945 26.93671798706055 L 15.32109355926514 18 Z" fill="#0d122f" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
