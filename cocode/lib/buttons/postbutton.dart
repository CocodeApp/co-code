import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class postbutton extends StatelessWidget {
  postbutton({@required this.onPressed});
  final GestureTapCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 80.0,
      fillColor: const Color(0xfff57862),
      splashColor: const Color(0xff2980b9),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 50.0,
        ),
        child: Text(
          "POST",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      onPressed: onPressed,
      shape: const StadiumBorder(),
    );
  }
}
