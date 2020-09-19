import 'package:flutter/material.dart';
import 'package:cocode/Auth.dart';
import 'package:cocode/LoginPage.dart';
import 'package:cocode/features/homePage/projectScreen.dart';
import 'package:cocode/features/userProjects/myProjectsPage.dart';

class profilePage extends StatefulWidget {
  @override
  _profilePageState createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2A4793),
        title: Text(
          'user profile',
          textAlign: TextAlign.center,
        ),
      ),
      body: Text(''),
      //these methods are in hamePageData files
      floatingActionButton: FloatingActionButton(
        //for adding new Idea
        onPressed: () async {
          await Auth.logout();

          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return LoginPage();
          }));
        },
        child: Text('logout'),
        backgroundColor: Color(0xffF57862),
      ),
    );
  }
}
// class userProfile extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//             leading: Icon(Icons.arrow_back),
//             title: Center(child: Text('Project Title')),
//             backgroundColor: Color(0xff2A4793)),
//         body: Column(
//           children: [bio(), major(), interests(), Projects(), topSkills()],
//         ),
//       ),
//     );
//   }
// }

// class bio extends StatelessWidget {
//   // this widget for the user bio
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 50,
//           ), //user avatar
//           Text("the user bio should goes here"),
//         ],
//       ),
//       clipBehavior: Clip.antiAlias,
//     );
//   }
// }

// class major extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Row(
//         children: [
//           Icon(Icons.school),
//           Column(
//             children: [
//               //column for the major and uni
//               Text("the Uni goes here"),
//               Text('the najor goes her')
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

// class interests extends StatelessWidget {
//   //user interst goes here
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Row(
//         children: [
//           Icon(
//             Icons.favorite,
//             color: Colors.red,
//           ),
//           Text("a list of interests should be here")
//         ],
//       ),
//     );
//   }
// }

// class Projects extends StatelessWidget {
//   // user Previous Projects
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Column(
//         children: [
//           Text("Previous Projects"),
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 20,
//               ),
//               Text('Project name')
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

// class topSkills extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//         child: Column(
//       children: [
//         Text("Top skills"),
//         Row(
//           children: [
//             CircleAvatar(
//               radius: 20,
//             ),
//             Text('Project name')
//           ],
//         )
//       ],
//     ));
//   }
// }
