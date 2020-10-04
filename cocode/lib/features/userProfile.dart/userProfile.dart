import 'package:cocode/buttons/indicator.dart';
import 'package:flutter/material.dart';
import 'package:cocode/Auth.dart';
import 'package:cocode/features/Login/LoginPage.dart';
import 'package:cocode/features/registertion/MoreInfoPage.dart';
import 'package:cocode/features/homePage/projectScreen.dart';
import 'package:cocode/features/userProjects/myProjectsPage.dart';
import 'EditProfilePage.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class profilePage extends KFDrawerContent {
  final String userId;
  @override
  profilePage({this.userId});

  _profilePageState createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  String currentName = Auth.getCurrentUsername();
  String email = Auth.getCurrentUserEmail();

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('User');

    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(Auth.getCurrentUserID()).get(),
        builder: (context, snapshot) {
          if (snapshot.data == null) return indicator();

          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data.data() == null) return indicator();
            Map<String, dynamic> data = snapshot.data.data();
            return Scaffold(
                backgroundColor: Color(0xffF8F8FA),
                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
                    onPressed: widget.onMenuPressed,
                  ),
                  centerTitle: true,
                  backgroundColor: Color(0xff2A4793),
                  title: Text(
                    '@' + currentName, // user name at top of the page
                    textAlign: TextAlign.center,
                  ),
                ),
                body: SafeArea(
                  child: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Container(
                        //first part the blue one
                        color: Colors.blue[200],
                        height: 0.38 * MediaQuery.of(context).size.height,
                        child: Padding(
                            padding: EdgeInsets.only(
                              // image position
                              left: 30.0,
                              right: 30.0,
                              top: 0.03 * MediaQuery.of(context).size.height,
                            ),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      //// profile imeag size
                                      height: 0.13 *
                                          MediaQuery.of(context).size.height,
                                      width: 0.22 *
                                          MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  "imeges/man.png")) //// profile imeag MUST be from database
                                          ),
                                    ),
                                    SizedBox(
                                      width: 0.04 *
                                          MediaQuery.of(context).size.width,
                                    ),
                                    Column(
                                      //user F L name
                                      children: <Widget>[
                                        Text(
                                          data['firstName'] +
                                              " " +
                                              data[
                                                  'lastName'] // must be from database
                                          ,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 0.093 *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              '📧 ' + email,
                                              style: TextStyle(
                                                  color: Color(0xff2A4793),
                                                  fontSize: 0.02 *
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  // here is the bio
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.all(10.0),
                                      padding: const EdgeInsets.all(10.0),
                                      alignment: Alignment.center,

                                      /// max length must be 43
                                      child: Expanded(
                                        child: Text(
                                          data['bio'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                    //here is profile edit it must be for loged in user only
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      RaisedButton(
                                        onPressed: () {
                                          // go to edite profile
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return new EditProfilePage();
                                              },
                                            ),
                                          );
                                        },
                                        color: Colors.deepOrangeAccent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    30.0)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.1),

                                          ///borderRadius: BorderRadius.circular(20.0),
                                          child: Text(
                                            "Edit Profile",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ),
                                    ])
                              ],
                            )),
                      ),
                      //second part the white one
                      Padding(
                        padding: EdgeInsets.only(top: 230),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30.0),
                              topLeft: Radius.circular(30.0),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 30.0, top: 25, bottom: 20),
                                  child: Text(
                                    "My Projects",
                                    style: TextStyle(
                                        color: Color(0xff2A4793),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                SizedBox(height: 3),
                                Container(
                                  height: 0.18 *
                                      MediaQuery.of(context)
                                          .size
                                          .height, //size of project image
                                  child: ListView(
                                    //list of projects
                                    scrollDirection: Axis.horizontal,
                                    children: <Widget>[
                                      SizedBox(width: 20),
                                      Material(
                                          // this part will be showing for each project
                                          color: Colors.white70,
                                          child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return new ProjectScreen(); // this must lead to the projects that user in
                                                    },
                                                  ),
                                                );
                                              },
                                              child: Stack(
                                                // list of projects from data base
                                                alignment:
                                                    const Alignment(0, 0),
                                                children: [
                                                  Container(
                                                    //project logo from database
                                                    height: 0.30 *
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    width: 0.350 *
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      child: Image.asset(
                                                        'imeges/logo-2.png', //project logo
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    // project name from database
                                                    padding:
                                                        const EdgeInsets.all(
                                                            9.0),
                                                    decoration:
                                                        new BoxDecoration(
                                                            color: new Color
                                                                    .fromARGB(
                                                                120,
                                                                71,
                                                                150,
                                                                236)),
                                                    child: new Text(
                                                        'project name ', // project name
                                                        maxLines: 1,
                                                        style: new TextStyle(
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        )),
                                                  ),
                                                ],
                                              ))),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  // Skills and Skills Levels
                                  padding:
                                      EdgeInsets.only(left: 27.0, right: 22.0),
                                  // space betwen skils and view
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Skills and Skills Levels ",
                                        style: TextStyle(
                                            color: Color(0xff2A4793),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        // for Edit Skills
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return new ProjectScreen(); // this must lead to the edit char page
                                              },
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Edit Skills",
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 17),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  height: 120,
                                  // here must tbe skills and level Must be tacking from edit skills page
                                  child: ListView(
                                    scrollDirection: Axis.vertical,
                                    children: <Widget>[
                                      skillAndLevel("CSS", "90"),
                                      skillAndLevel("Javascript", "20"),
                                      skillAndLevel("Dart", "50"),
                                      skillAndLevel("Illustrator", "70"),
                                      SizedBox(
                                        width: 10,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ));
          }
        });
  }

  skillAndLevel(String skillName, String level) {
    var skil = int.parse(level);
    var percent = skil * 0.01;
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15.0),
            child: new LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 150,
              animation: true,
              lineHeight: 20.0,
              leading: new Text(skillName + '   '),
              animationDuration: 2000,
              percent: percent,
              center: Text(level + "%"),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Colors.blue[200],
            ),
          ),
        ],
      ),
    );
  }
}

/*these methods are in hamePageData files
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

     */

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
