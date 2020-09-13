import 'package:flutter/material.dart';

class userProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            leading: Icon(Icons.arrow_back),
            title: Center(child: Text('Project Title')),
            backgroundColor: Color(0xff2A4793)),
        body: Column(
          children: [bio(), major(), interests(), Projects(), topSkills()],
        ),
      ),
    );
  }
}

class bio extends StatelessWidget {
  // this widget for the user bio
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
          ), //user avatar
          Text("the user bio should goes here"),
        ],
      ),
      clipBehavior: Clip.antiAlias,
    );
  }
}

class major extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Icon(Icons.school),
          Column(
            children: [
              //column for the major and uni
              Text("the Uni goes here"),
              Text('the najor goes her')
            ],
          )
        ],
      ),
    );
  }
}

class interests extends StatelessWidget {
  //user interst goes here
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Icon(
            Icons.favorite,
            color: Colors.red,
          ),
          Text("a list of interests should be here")
        ],
      ),
    );
  }
}

class Projects extends StatelessWidget {
  // user Previous Projects
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text("Previous Projects"),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
              ),
              Text('Project name')
            ],
          )
        ],
      ),
    );
  }
}

class topSkills extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: [
        Text("Top skills"),
        Row(
          children: [
            CircleAvatar(
              radius: 20,
            ),
            Text('Project name')
          ],
        )
      ],
    ));
  }
}
