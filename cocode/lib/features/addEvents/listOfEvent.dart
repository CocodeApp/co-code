import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocode/features/addEvents/addEvent.dart';
import 'package:flutter/material.dart';

import 'addEventForm.dart';
import 'eventTab.dart';

class ListOfEvents extends StatelessWidget {
  String projectId;

  bool isSuper;

  ListOfEvents({
    Key key,
    @required this.isSuper,
    @required this.projectId,
  }) : super(key: key); //accept project id
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isSuper
          ? RawMaterialButton(
              shape: const StadiumBorder(),
              splashColor: Color(0xaaf57862),
              fillColor: Colors.indigo,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.add_outlined,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      'add event',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return AddEventFormPage(id: projectId);
                }));
              }, 
            )
          : FloatingActionButton(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              onPressed: null,
            ),
      appBar: AppBar(
        elevation: 0,
        leading: BackButton(
          color: Colors.indigo,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          'project events',
          style: TextStyle(color: Colors.indigo),
        ),
      ),
      backgroundColor: const Color(0xffffffff),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('projects')
              .doc(projectId)
              .collection('project_events')
              .orderBy('startdate')
              .snapshots(),
          builder: (context, snapshot) {
            //if(snapshot)
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.documents[index];
                    return eventTab(eventDetails: ds.data());
                  });
            }
          }),
    );
  }
}
