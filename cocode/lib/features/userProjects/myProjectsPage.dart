import 'package:flutter/material.dart';
import 'package:cocode/features/homePage/projectScreen.dart';
import 'package:cocode/features/userProfile.dart/userProfile.dart';

class userProjects extends StatefulWidget {
  @override
  _userProjectsState createState() => _userProjectsState();
}

class _userProjectsState extends State<userProjects> {
  @override
  int _index = 0;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('my projects'),
        backgroundColor: Color(0xff2A4793),
      ),
      body: Text(""),
    );
  }
}

// class myProjectsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//             title: Text('My projects'), backgroundColor: Color(0xff2A4793)),
//         body: IdeaCard(),
//       ),
//     );
//   }
// }

// class IdeaCard extends StatelessWidget {
//   IdeaCard({Key key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//         height: 100.5,
//         child: Card(
//           child: InkWell(
//               splashColor: Colors.blue.withAlpha(30),
//               onTap: () {
//                 //VIEW PROJECT DETAILS GOES HERE
//               },
//               child: const ListTile(
//                 leading: CircleAvatar(
//                   backgroundColor: Color(0xffF57862),
//                   radius: 30,
//                 ),
//                 title: Text("title"),
//                 subtitle: Text("description goes here"),
//               )),
//         ));
//   }
// }
