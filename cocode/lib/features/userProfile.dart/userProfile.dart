import 'package:cocode/buttons/indicator.dart';
import 'package:cocode/features/viewProject/viewProject.dart';
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
  String id = Auth.getCurrentUserID();

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('User');

    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(Auth.getCurrentUserID()).get(),
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.data == null) return indicator();

          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data.data() == null) return indicator();
            Map<String, dynamic> data = snapshot.data.data();
            CollectionReference userProjects = FirebaseFirestore.instance
                .collection('User')
                .doc(id)
                .collection('myProjects');
            List<dynamic> skills = data['skills'];
            return Scaffold(
                backgroundColor: Color(0xffF8F8FA),
                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.deepOrangeAccent,
                    ),
                    onPressed: widget.onMenuPressed,
                  ),
                  centerTitle: true,
                  backgroundColor: Color(0xff2A4793),
                  title: Text(
                    '@' + currentName, // user name at top of the page
                    textAlign: TextAlign.center,
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.deepOrangeAccent,
                      ),
                      tooltip: 'Edit Profile',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return new EditProfilePage();
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
                body: SafeArea(
                  child: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Container(
                        //first part the blue one
                        color: Color(0xffD1DDED),
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
                                  // here is the bio MUST BE 140 LETTER
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      padding: const EdgeInsets.all(10.0),
                                      alignment: Alignment.center,

                                      /// max length must be 43
                                      child: new Column(
                                        children: <Widget>[
                                          new Text(
                                            data['bio'] == null
                                                ? ''
                                                : data['bio'],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: 15),
                                    Text(
                                      data['major'] == null
                                          ? ''
                                          : 'Major: ' + data['major'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 125,
                                          height: 10,
                                        ),
                                        Text(
                                          data['university'] == null
                                              ? ''
                                              : 'University: ' +
                                                  data['university'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
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
                                  padding: EdgeInsets.only(top: 25, bottom: 20),
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
                                      SizedBox(width: 8),
                                      Material(
// this part will be showing for each project
                                        color: Colors.white70,
                                        child: StreamBuilder<QuerySnapshot>(
                                          stream: userProjects.snapshots(),
// ignore: missing_return
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (snapshot.data == null)
                                              return Container(
                                                //// latefa
                                                child: Text(
                                                  currentName +
                                                      "did not join any projects yet !", // this massage must be static
                                                  style: TextStyle(
                                                      color: Colors
                                                          .redAccent, //// latefa
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                                  textAlign: TextAlign.center,
                                                ),
                                              );
                                            if (snapshot.hasData) {
                                              var doc = snapshot.data.docs;
                                              return ListView.builder(
                                                itemCount: doc.length,
                                                itemBuilder: (context, index) {
                                                  Map data = doc[index].data();
                                                  return InkWell(
//stream list v
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) {
                                                            return new viewProject(
                                                                id: doc[
                                                                    index]); //// latefa     // this must lead to the projects that user in
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    child: Column(
// list of projects from data base
                                                      children: [
                                                        Container(
//project logo from database
                                                          height: 0.12 *
                                                              MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height,
                                                          width: 0.350 *
                                                              MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                            child: Image.asset(
                                                              'imeges/logo-2.png', //project logo
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          data['projectName'],
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 17,
                                                            color: Colors
                                                                .deepOrangeAccent,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          },
                                        ),
                                      ),
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
                                        "Skills and Levels ",
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
                                // ListView.builder(
                                //     itemCount: skills.length,
                                //     itemBuilder: (context, index) {
                                //       return (skillAndLevel(
                                //           skills[index]['name'],
                                //           skills[index]['value']));
                                //     }),
                                Column(
                                  children: [
                                    skillsList(skills),
                                    // here must tbe skills and level Must be tacking from edit skills page

                                    // skillAndLevel("CSS", "90"),
                                    // skillAndLevel("Javascript", "20"),
                                    // skillAndLevel("Dart", "50"),
                                    // skillAndLevel("Illustrator", "70"),
                                    SizedBox(
                                      width: 10,
                                    )
                                  ],
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
              width: MediaQuery.of(context).size.width - 75,
              animation: true,
              lineHeight: 25.0,
              animationDuration: 2000,
              percent: percent,
              trailing: Row(
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    level + '%',
                    style: TextStyle(
                      color: Colors.indigo,
                    ),
                  ),
                ],
              ),
              center: Text(
                skillName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Colors.blue[200],
            ),
          ),
        ],
      ),
    );
  }

  Widget skillsList(List skills) {
    print('hhheeee');
    print(skills[0]);
    for (int i = 0; i < skills.length; i++) {
      Map<String, dynamic> skill = skills[i];
      return skillAndLevel(skill['name'], skill['value']);
    }
  }
}
