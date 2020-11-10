import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slimy_card/slimy_card.dart';
import 'projectsCardView.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class needTeamMember extends StatefulWidget {
  @override
  _needTeamMemberState createState() => _needTeamMemberState();
}

class _needTeamMemberState extends State<needTeamMember> {
  SlimyCard slimy;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('projects')
            .orderBy('projectName', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: Card(
                child: Container(
                  width: 80,
                  height: 80,
                  padding: EdgeInsets.all(12.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
          List needMembers = new List<QueryDocumentSnapshot>();
          for (int i = 0; i < snapshot.data.docs.length; i++) {
            if (snapshot.data.docs[i] == null) {
              return Center(
                child: Card(
                  child: Container(
                    width: 80,
                    height: 80,
                    padding: EdgeInsets.all(12.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }
            var x = snapshot.data.docs[i].data();
            if (x['supervisor'] != '') {
              needMembers.add(snapshot.data.docs[i]);
            }
          }
          return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: needMembers.length, //the length of our collection
              itemBuilder: (context, index) {
                DocumentSnapshot Projectdata = snapshot.data.docs[index];
                Map getDocs = needMembers[index].data();
                var ID = needMembers[index].id;

                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SlimyCard(
                    color: Color(0xFFD1DDED),
                    width: 300,
                    topCardHeight: 250,
                    bottomCardHeight: 150,
                    borderRadius: 15,
                    topCardWidget: topCardWidget(
                      getDocs['image'] == null
                          ? "imeges/logo-5.png"
                          : getDocs['image'],
                      getDocs['projectName'],
                    ),
                    bottomCardWidget: Tooltip(
                      message: 'project description',
                      child: bottomCardWidget(
                          getDocs['projectDescripion'], ID, context),
                    ),
                    slimeEnabled: true,
                  ),
                );
              });
        });
  }
}

class needSupervisor extends StatefulWidget {
  Widget bottom;
  Widget top;
  @override
  _needSupervisorState createState() => _needSupervisorState();
}

class _needSupervisorState extends State<needSupervisor> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      //becuase firestore return data in a stream we need a stream builder to read this data
      stream: Firestore.instance
          .collection('projects')
          .orderBy('projectName', descending: true)
          .snapshots(), //our collection
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: Card(
              child: Container(
                width: 80,
                height: 80,
                padding: EdgeInsets.all(12.0),
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        List needSupervisor = new List<QueryDocumentSnapshot>();
        for (int i = 0; i < snapshot.data.docs.length; i++) {
          if (snapshot.data.docs[i] == null) return CircularProgressIndicator();
          var x = snapshot.data.docs[i].data();
          if (x['supervisor'] == '') {
            needSupervisor.add(snapshot.data.docs[i]);
          }
        }

        return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: needSupervisor.length, //the length of our collection
            itemBuilder: (context, index) {
              DocumentSnapshot Projectdata = snapshot.data.docs[index];
              Map getDocs = needSupervisor[index].data();
              var ID = needSupervisor[index].id;

              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: new SlimyCard(
                  color: Color(0xFFD1DDED),
                  width: 300,
                  topCardHeight: 250,
                  bottomCardHeight: 150,
                  borderRadius: 15,
                  topCardWidget: topCardWidget(
                    "imeges/logo-5.png",
                    getDocs['projectName'],
                  ),
                  bottomCardWidget: Tooltip(
                    message: 'project description',
                    child: bottomCardWidget(
                        getDocs['projectDescripion'], ID, context),
                  ),
                  slimeEnabled: true,
                ),
              );
            });
      },
    );
  }
}
