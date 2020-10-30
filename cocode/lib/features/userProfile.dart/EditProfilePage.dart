import 'package:cocode/buttons/indicator.dart';
import 'package:cocode/features/accountSettings/changeUsername.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../AccountInfo.dart';
import '../../Auth.dart';

class EditProfilePage extends StatefulWidget {
  @override
  EditProfile createState() => EditProfile();
}

class EditProfile extends State<EditProfilePage> {
  String university = "";
  String major = '';
  String id = Auth.getCurrentUserID();
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('User');
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(id).get(),
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
            university = data['university'];
            major = data['major'];

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.deepOrangeAccent,
                  ),
                  // onPressed: widget.onMenuPressed,
                ),
                centerTitle: true,
                backgroundColor: Colors.white,
                title: Text(
                  "Edit Profile",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xff2A4793)),
                ),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                        CircleAvatar(
                          backgroundImage: AssetImage('imeges/man.png'),// must be the same from database
                        ),
                          Text("Hi nice to see you here"),
                        ],
                      ),
                    ),
                  ),
          Expanded(
          flex: 2,
                child:  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(
                      children: <Widget>[
                        Card(
                          child: ListTile(
                              leading: GestureDetector(
                                child: Hero(
                                    tag: 'username',
                                    child: CircleAvatar(
                                      backgroundColor: Colors.indigo,
                                      foregroundColor: Colors.white,
                                      radius: 20,
                                      child: Icon(
                                        Icons.alternate_email,
                                        color: Colors.white,
                                        size: 30.0,
                                      ),
                                    )),
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                        return ChangeUsername();
                                      }));
                                },
                              ),
                              dense: false,
                              title: Text('Username',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey)),
                              subtitle: Text(id,
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      color: Colors.black87)),
                              trailing:
                              Icon(Icons.keyboard_arrow_right),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                      new ChangeUsername()),
                                ).then((value) {
                                  setState(() {
                                    id = AccountInfo.username;
                                  });
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
          ),],
              ),
            );
          }
        });
  }
}
