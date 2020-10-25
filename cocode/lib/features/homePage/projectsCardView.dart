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
            alignment: Alignment.center,
            child: OutlineButton(
              borderSide: BorderSide(color: Colors.deepOrangeAccent),
              child: Text('view details',
                  style: TextStyle(color: Colors.deepOrangeAccent)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => viewProject(
                        id: ID,
                        tab: "ideaOwner",
                        previouspage: "",
                      ),
                    ));
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.deepOrangeAccent)),
            ))
      ],
    ),
  );
}
