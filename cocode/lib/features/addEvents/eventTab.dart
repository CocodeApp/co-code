import 'package:cocode/features/addEvents/viewEvent.dart';
import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:googleapis/androidpublisher/v3.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class eventTab extends StatelessWidget {
  Map<String, dynamic> eventDetails;

  eventTab({
    Key key,
    @required this.eventDetails,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String eventName = eventDetails['name'];

    //https://stackoverflow.com/questions/50632217/dart-flutter-converting-timestamp

    DateTime startdate =
        DateTime.tryParse(eventDetails['startdate'].toDate().toString());
    final day = DateFormat.d().format(startdate);
    final month = DateFormat.MMM().format(startdate).toUpperCase();
    final year = DateFormat.y().format(startdate);

    //DateTime startdate =DateTime.fromMillisecondsSinceEpoch(int.tryParse(seconds) * 1000);

    return Card(
      elevation: 5.0,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return event(
              eventDetails: eventDetails,
            );
          }));
        },
        child: Stack(
          children: <Widget>[
            Container(
              width: 375.0,
              height: 99.0,
              decoration: BoxDecoration(),
            ),
            Transform.translate(
              offset: Offset(77.5, 14.5),
              child: SvgPicture.string(
                _svg_g4h265,
                allowDrawingOutsideViewBox: true,
              ),
            ),
            Transform.translate(
              offset: Offset(80.0, 20.0),
              child: Container(
                width: 238.0,
                height: 62.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                  ),
                  color: const Color(0xa1d1dded),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(9.0, 14.0),
              child: Container(
                width: 68.0,
                height: 74.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(14.0, 25.0),
              child: SizedBox(
                width: 56.0,
                height: 51.0,
                child: Stack(
                  children: <Widget>[
                    Pinned.fromSize(
                      bounds: Rect.fromLTWH(0.0, 36.0, 56.0, 15.0),
                      size: Size(56.0, 51.0),
                      pinLeft: true,
                      pinRight: true,
                      pinBottom: true,
                      fixedHeight: true,
                      child: Text(
                        month + '-' + year,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 12,
                          color: const Color(0xff9097a2),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Pinned.fromSize(
                      bounds: Rect.fromLTWH(11.0, 0.0, 34.0, 36.0),
                      size: Size(56.0, 51.0),
                      pinTop: true,
                      fixedWidth: true,
                      fixedHeight: true,
                      child: Text(
                        day,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 30,
                          color: const Color(0xff9097a2),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(95.6, 42.0),
              child: SizedBox(
                width: 125.0,
                child: Text(
                  eventName,
                  style: TextStyle(
                    fontFamily: 'Microsoft Sans Serif',
                    fontSize: 16,
                    color: const Color(0xff656d78),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const String _svg_g4h265 =
    '<svg viewBox="77.5 14.5 1.0 73.0" ><path transform="translate(77.5, 14.5)" d="M 1 0 L 0 73" fill="none" fill-opacity="0.65" stroke="#d1dded" stroke-width="5" stroke-opacity="0.65" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_elo4wy =
    '<svg viewBox="0.5 99.5 375.0 1.0" ><path transform="translate(0.5, 99.5)" d="M 0 0 L 375 0" fill="none" stroke="#707070" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
