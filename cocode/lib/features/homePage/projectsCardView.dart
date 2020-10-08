import 'package:cocode/features/viewProject/viewProject.dart';
import 'package:flutter/material.dart';
import 'package:spring_button/spring_button.dart';

Widget topCardWidget(String imagePath, String title) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          color: Color(0xffD1DDED),
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(image: AssetImage(imagePath)),
        ),
      ),
      SizedBox(height: 15),
      Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 25),
      ),
      SizedBox(height: 10),
    ],
  );
}

Widget bottomCardWidget(String description, String ID, BuildContext context) {
  return Scrollbar(
    child: ListView(
      children: [
        Text(description, style: TextStyle(color: Colors.white, fontSize: 16)),
        Align(
            alignment: Alignment.centerLeft,
            child: SpringButton(
              SpringButtonType.OnlyScale,
              row(
                "view details",
                Color(0xffF57862),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => viewProject(id: ID),
                    ));
              },
            ))
      ],
    ),
  );
}

Widget row(String text, Color color) {
  //styling the botton
  return Padding(
      padding: EdgeInsets.all(12.5),
      child: Container(
        height: 30,
        width: 90,
        child: Center(
          child: Text(
            'view details',
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
        decoration: BoxDecoration(
          color: Color(0xffF57862),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              spreadRadius: 1,
            ),
          ],
        ),
      ));
}
