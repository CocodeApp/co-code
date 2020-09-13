import 'package:flutter/material.dart';

class viewProject extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.arrow_back),
          title: Text("project name"),
        ),
        body: Center(child: projectDetails()),
      ),
    );
  }
}

class projectDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // to maintain the card size
      height: 500,
      width: 400,
      child: Card(
        child: Column(
          //this column contain every project details
          children: [
            CircleAvatar(radius: 60), //project logo if any
            Text("description"),
            Text('start date :09-09-2020'),
            Text('expected date'),
            FlatButton(
              child: Text('join'),
            )
          ],
        ),
      ),
    );
  }
} // there is some missing details , see our class diagram for more info
