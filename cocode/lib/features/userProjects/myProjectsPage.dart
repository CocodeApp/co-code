import 'package:cocode/buttons/indicator.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:cocode/Auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slimy_card/slimy_card.dart';
import 'package:cocode/features/homePage/projectsCardView.dart';

class userProjects extends KFDrawerContent {
  @override
  _userProjectsState createState() => _userProjectsState();
}

class _userProjectsState extends State<userProjects> {
  @override
  String id = Auth.getCurrentUserID();

  Widget build(BuildContext context) {
    CollectionReference projects =
        Firestore.instance.collection('User').doc(id).collection('myProjects');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          'My projects',
          style: TextStyle(color: Colors.indigo),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.deepOrangeAccent,
          ),
          onPressed: widget.onMenuPressed,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: projects.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) return indicator();
          if (snapshot.hasData) {
            var doc = snapshot.data.docs;

            return ListView.builder(
              itemCount: doc.length,
              itemBuilder: (context, index) {
                Map data = doc[index].data();
                print(data['projectName']);
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 2,
                      child: ClipPath(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(25, 5, 0, 5),
                                child: Text(
                                  data['projectName'],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(25, 5, 0, 5),
                                child: Text(data['role'],
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              )
                            ],
                          ),
                          height: 60,
                          decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      color: index % 2 == 0
                                          ? Colors.indigo
                                          : Colors.deepOrangeAccent,
                                      width: 5))),
                        ),
                        clipper: ShapeBorderClipper(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3))),
                      ),
                    ));
              },
            );
          }
        },
      ),
    );
  }
}
