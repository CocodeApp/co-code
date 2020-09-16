import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddUser extends StatelessWidget {
  final String fullName;
  final String company;
  final int age;

  AddUser(this.fullName, this.company, this.age);
  static CollectionReference persons =
      FirebaseFirestore.instance.collection('person');

  static Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    //return persons
    //.add({
    // 'name': "nora", // John Doe
    //  })
    //  .then((value) => print("User Added"))
    //  .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection

    return FlatButton(
      onPressed: addUser,
      child: Text(
        "Add User",
      ),
    );
  }
}
