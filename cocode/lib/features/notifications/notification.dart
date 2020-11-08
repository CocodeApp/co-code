import 'package:flutter/material.dart';
import 'package:cocode/buttons/indicator.dart';
import 'package:cocode/Auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kf_drawer/kf_drawer.dart';

class notification extends KFDrawerContent {
  @override
  _notificationState createState() => _notificationState();
}
String user = Auth.getCurrentUserID();
CollectionReference notifications = FirebaseFirestore.instance.collection('User').doc(user).collection('notifications');

class _notificationState extends State<notification> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: notifications.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if (snapshot.data == null) return indicator();
          var doc = snapshot.data.docs;
          return ListView.builder(
              itemCount: doc.length,
              itemBuilder: (context, index){
                Map data = doc[index].data();
                return InkWell(
                  // onTap: (){},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 2,
                      child: ClipPath(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(25, 5, 0, 5),
                                child: Text(
                                  data['title'],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.fromLTRB(25, 5, 0, 5),
                                child: Text(data['body'],
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
                    ),
                  ),
                );
              }
          );
        });
  }
}





