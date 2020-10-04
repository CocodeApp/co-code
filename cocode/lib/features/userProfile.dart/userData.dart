import 'package:flutter/material.dart';
import 'package:cocode/Auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'userModel.dart';

Future<Map> userData() async {
  String email = Auth.getCurrentUserEmail();
  String userName = Auth.getCurrentUserEmail();
  String ID = Auth.getCurrentUserID();
  String firstName = '';
  String lastName = '';
  String major = '';
  String university = '';
  var data;

  var document = await Firestore.instance.collection('User').document(ID);
  document.get().then((document) {
    var data = document.data();
    var returend = {
      'firstName': data['firstName'],
      'lastName': lastName,
      'major': major,
      'university': university
    };
    return returend;
  });

  CollectionReference users = FirebaseFirestore.instance.collection('User');
  FutureBuilder<DocumentSnapshot>(
      future: users.doc(ID).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          firstName = data['firstName'];
          lastName = data['lastName'];
          major = data['major'];
          university = data['university'];
          data = {
            'firstName': firstName,
            'lastName': lastName,
            'major': major,
            'university': university
          };
        }
      });

  return data;
}
