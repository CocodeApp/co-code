import 'package:cocode/buttons/indicator.dart';
import 'package:cocode/features/viewProject/viewProject.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:cocode/Auth.dart';
import 'EditProfilePage.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'editProfile.dart';

class profilePage extends KFDrawerContent {
  var userId;
  Widget
      previousPage; //I need to know what previous is it to detrmine dispplay arrow back button or menu button on appbar
  profilePage({Key key, @required this.userId, this.previousPage});
  @override
  _profilePageState createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  String currentName = "";
  String projectImg;
  String email = '';
  String id = Auth.getCurrentUserID();
  String imageURL;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('User');
    print(widget.previousPage);
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(widget.userId).get(),
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot == null) return indicator();

          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            CollectionReference userProjects = FirebaseFirestore.instance
                .collection('User')
                .doc(id)
                .collection('myProjects');
            List<dynamic> skills = data['skills'];

            currentName = data['firstName'] + " " + data['lastName'];
            email = data['email'];
            imageURL = data['image'];

            return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  leading: widget.previousPage != null || id != widget.userId
                      ? BackButton(
                          color: Colors.deepOrangeAccent,
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: Colors.deepOrangeAccent,
                          ),
                          onPressed: widget.onMenuPressed,
                        ),
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  title: Text(
                    '@' + data['userName'], // user name at top of the page
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xff2A4793)),
                  ),
                  actions: <Widget>[
                    id == widget.userId
                        ? IconButton(
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
                                    return new editProfile();
                                  },
                                ),
                              ).then((value) {
                                setState(() {});
                              });
                            },
                          )
                        : Container(),
                  ],
                ),
                body: SafeArea(
                  child: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      blueArea(context, data),
                      //second part the white one
                      Padding(
                        padding: EdgeInsets.only(
                          top: 280,
                        ),
                        child: Container(
                          padding: EdgeInsets.only(bottom: 20),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                          ),
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 25, bottom: 20, left: 27),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "My Projects",
                                        style: TextStyle(
                                            color: Color(0xff2A4793),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  projects(context, userProjects),
                                  SizedBox(height: 20),
                                  Padding(
                                    // Skills and Skills Levels
                                    padding: EdgeInsets.only(
                                        left: 27.0, right: 22.0),
                                    // space betwen skils and view
                                    child: skillsWidget(context),
                                  ),
                                  SizedBox(height: 20),
                                  skillsListView(skills),
                                  SizedBox(width: 10)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ));
          }
          return indicator();
        });
  }

  Widget skillsListView(List skills) {
    if (skills == null) {
      return Container(
        child: Text(
          currentName +
              " did not add any skill yet !", // this massage must be static
          style: TextStyle(
              color: Colors.redAccent, //// latefa
              fontWeight: FontWeight.bold,
              fontSize: 15),
          textAlign: TextAlign.center,
        ),
      );
    }
    return Container(
      constraints: BoxConstraints(minHeight: 150.0, maxHeight: 150),
      child: ListView.builder(
        itemCount: skills.length,
        itemBuilder: (context, index) {
          return skillAndLevel(skills[index]['name'], skills[index]['value']);
        },
      ),
    );
  }

  Row skillsWidget(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          "Skills",
          style: TextStyle(
              color: Color(0xff2A4793),
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        SizedBox(
          width: 230,
        ),
        GestureDetector(
          // for Edit Skills
          onTap: () {},
          child: Text(
            "", //edit skills
            style: TextStyle(color: Colors.grey, fontSize: 17),
          ),
        )
      ],
    );
  }

  Widget projects(BuildContext context, CollectionReference userProjects) {
    return FutureBuilder<QuerySnapshot>(
      future: userProjects.get(),
// ignore: missing_return
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return DotsIndicator(
            dotsCount: 5,
          );
        }
        var doc = snapshot.data.docs;

        if (doc.length == 0) {
          return Container(
            child: Text(
              currentName +
                  " did not join any projects yet !", // this massage must be static
              style: TextStyle(
                  color: Colors.deepOrangeAccent, //// latefa
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (snapshot.hasData) {
          return Container(
            padding: const EdgeInsets.only(left :20, right: 20),
            constraints: BoxConstraints(minHeight: 10.0, maxHeight:100,),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: doc.length,
              itemBuilder: (context, index) {
                Map data = doc[index].data();
                FirebaseFirestore.instance
                    .collection('projects')
                    .doc(doc[index].id);
                  Map<String, dynamic> daa = data;
                  projectImg = daa['image'];
               // print("this is projectImg "+projectImg);// only first image
                return Row(
                  children: [
                    SizedBox(width: 15),
                    InkWell(
//stream list v
                    onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return new viewProject(
                          id: doc[index].id,
                          tab: "ideaOwner",
                          previouspage: "",
                        ); //// latefa     // this must lead to the projects that user in
                      },
                    ),
                  );
                },
                child: Column(
// list of projects from data base
                children: [
                ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child:Container(
                height: 70.0,
                width: 80.0,
                decoration: BoxDecoration(
                image: DecorationImage(
                image:projectImg == null
                ? AssetImage('imeges/logo-2.png')
                    : NetworkImage(projectImg),

                fit: BoxFit.fill,
                ),
                shape: BoxShape.rectangle,
                ),
                )

                ),
                  SizedBox(width: 10),
                Text(
                data['projectName'],
                style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.deepOrangeAccent,
                ),
                ),
                ],
                ),

                ),
                  ],
                );
              },
            ),
          );
        }
      },
    );
  }

  Container blueArea(BuildContext context, Map<String, dynamic> data) {
    if (data == null) return Container();

    return Container(
      //first part the blue one
      width: MediaQuery.of(context).size.width * 0.9998,
      height: 0.41 * MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: new LinearGradient(
            colors: <Color>[ //7928D1##
              const Color(0xFF2F80ED), const Color(0xFF56CCF2)],
            stops: <double>[0.1, 0.7],
            begin: Alignment.bottomLeft, end: Alignment.topRight
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),

      child: Padding(
          padding: EdgeInsets.only(
            // image position
            left: 15.0,
            top: 0.03 * MediaQuery.of(context).size.height,
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 0.018 * MediaQuery.of(context).size.width,
                  ),
                  Container(
                    //// profile imeag size
                    height: 0.13 * MediaQuery.of(context).size.height,
                    width: 0.22 * MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue[200].withOpacity(0.7),
                            spreadRadius: 4,
                            blurRadius: 7,
                            offset: Offset(0,2), // changes position of shadow
                          ),
                        ],
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: imageURL == null
                              ? AssetImage('imeges/man.png')
                              : NetworkImage(data['image']),
                        ) //// profile imeag MUST be from database
                        ),
                  ),
                  SizedBox(
                    width: 0.04 * MediaQuery.of(context).size.width,
                  ),
                  Column(
                    //user F L name
                    children: <Widget>[
                      Text(
                        data['firstName'] +
                            " " +
                            data['lastName'] // must be from database
                        ,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                0.083 * MediaQuery.of(context).size.width * 0.8,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Text(
                            '📧 ' + data['email'],
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize:
                                    0.02 * MediaQuery.of(context).size.height),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                // here is the bio MUST BE 140 LETTER
                children: <Widget>[
                  Container(/// max length must be 43
                    width: MediaQuery.of(context).size.width * 0.9,
                  //  padding: const EdgeInsets.only(left:3.0,),
                    //alignment: Alignment.center,
                   child: new Text(
                      data['bio'] == null ? '' : data['bio'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                children: [

                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      data['major'] == null ? '' : 'Major: ' + data['major'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 5),
              Align(
                alignment: Alignment.center,
                child: Text(
                  data['university'] == null
                      ? ''
                      : 'University: ' + data['university'],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ),
              SizedBox(height: 5),

            ],
          )),
    );
  }

  skillAndLevel(String skillName, String level) {
    var skil = double.parse(level);
    var percent = skil * 0.01;
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration( boxShadow: [
                    BoxShadow(
                      color: Colors.blue[200].withOpacity(0.7),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0,2), // changes position of shadow
                    ),],),
                  child: new LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width - 95,
                    animation: true,
                    lineHeight: 25.0,
                    animationDuration: 2000,
                    percent: percent,

                    center: Text(
                      skillName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: Colors.blue[400],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  level.substring(0,level.length-2) + '%',
                  style: TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

          ),
          ],
      ),
    );
  }
}
