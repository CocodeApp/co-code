import 'package:flutter/material.dart';

class myProjectsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text('My projects'), backgroundColor: Color(0xff2A4793)),
        body: IdeaCard(),
      ),
    );
  }
}

class IdeaCard extends StatelessWidget {
  IdeaCard({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 100.5,
        child: Card(
          child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                //VIEW PROJECT DETAILS GOES HERE
              },
              child: const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(0xffF57862),
                  radius: 30,
                ),
                title: Text("title"),
                subtitle: Text("description goes here"),
              )),
        ));
  }
}
