import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocode/buttons/RoundeButton.dart';
// import 'package:cocode/features/accountSettings/changeProfileImage.dart';
import 'package:cocode/features/userProfile.dart/changeBio.dart';
import 'package:cocode/features/userProfile.dart/changeMajor.dart';
import 'package:cocode/features/userProfile.dart/changeSkills.dart';
import 'package:cocode/features/userProfile.dart/changeUniversity.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_bloc/form_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'dart:async';
import 'package:cocode/features/accountSettings/AccountInfo.dart';

import '../../Auth.dart';

//Storing Account Info
class editProfile extends KFDrawerContent {
  @override
  _editProfileState createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
  String bio;
  String major;
  String university;
  bool isLoading;
  String imageUrl;
  List<dynamic> skills;
  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  Widget build(BuildContext context) {
    String id = Auth.getCurrentUserID();
    CollectionReference users = FirebaseFirestore.instance.collection('User');

    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Color(0xff2A4793)),
          textAlign: TextAlign.center,
        ),
        leading: BackButton(
          color: Colors.deepOrangeAccent,
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(id).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data.data();
            AccountInfo.bio = this.bio = data['bio'];
            AccountInfo.major = this.major = data['major'];
            AccountInfo.university = this.university = data['university'];
            AccountInfo.image = this.imageUrl = data['image'];
            this.skills = data['skills'];

            return Scaffold(
                backgroundColor: Colors.white,
                body: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  uploadImage().then((value) {
                                    setState(() {});
                                  });
                                },
                                child: Center(
                                  child: imageUrl == null
                                      ? CircleAvatar(
                                          radius: 65.0,
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.photo_camera,
                                            size: 30,
                                          ),
                                        )
                                      : CircleAvatar(
                                          radius: 65.0,
                                          backgroundImage:
                                              NetworkImage(imageUrl),
                                        ),
                                ),
                              ),
                              Text("uploade logo ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ListView(
                                children: <Widget>[
                                  Card(
                                    child: ListTile(
                                        leading: GestureDetector(
                                          child: Hero(
                                              tag: 'university',
                                              child: CircleAvatar(
                                                backgroundColor: Colors.indigo,
                                                foregroundColor: Colors.white,
                                                radius: 20,
                                                child: Icon(
                                                  Icons.account_balance,
                                                  color: Colors.white,
                                                  size: 30.0,
                                                ),
                                              )),
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (_) {
                                              return changeUniversity();
                                            }));
                                          },
                                        ),
                                        dense: false,
                                        title: Text('University',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.grey)),
                                        subtitle: Text(this.university,
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
                                                    new changeUniversity()),
                                          ).then((value) {
                                            setState(() {
                                              this.university =
                                                  AccountInfo.university;
                                            });
                                          });
                                        }),
                                  ),
                                  Card(
                                    child: ListTile(
                                        leading: GestureDetector(
                                          child: Hero(
                                              tag: 'major',
                                              child: CircleAvatar(
                                                backgroundColor: Colors.indigo,
                                                foregroundColor: Colors.white,
                                                radius: 20,
                                                child: Icon(
                                                  Icons.local_library,
                                                  color: Colors.white,
                                                  size: 30.0,
                                                ),
                                              )),
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (_) {
                                              return changeMajor();
                                            }));
                                          },
                                        ),
                                        dense: false,
                                        title: Text('Major',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.grey)),
                                        subtitle: Text(this.major,
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
                                                    new changeMajor()),
                                          ).then((value) {
                                            setState(() {
                                              this.major = AccountInfo.major;
                                            });
                                          });
                                        }),
                                  ),
                                  Card(
                                    child: ListTile(
                                        leading: GestureDetector(
                                          child: Hero(
                                              tag: 'bio',
                                              child: CircleAvatar(
                                                backgroundColor: Colors.indigo,
                                                foregroundColor: Colors.white,
                                                radius: 20,
                                                child: Icon(
                                                  Icons.person,
                                                  color: Colors.white,
                                                  size: 30.0,
                                                ),
                                              )),
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (_) {
                                              return changeBio();
                                            }));
                                          },
                                        ),
                                        dense: false,
                                        title: Text('Bio',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.grey)),
                                        subtitle: Text(
                                            bio == null ? "" : this.bio,
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
                                                    new changeBio()),
                                          ).then((value) {
                                            setState(() {
                                              this.bio = AccountInfo.username;
                                            });
                                          });
                                        }),
                                  ),
                                  Card(
                                    child: ListTile(
                                      leading: GestureDetector(
                                        child: Hero(
                                          tag: 'my skills',
                                          child: CircleAvatar(
                                            backgroundColor: Colors.indigo,
                                            child: Icon(
                                              Icons.assignment,
                                              color: Colors.white,
                                              size: 30.0,
                                            ),
                                            foregroundColor: Colors.white,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                            return changeSkills(
                                                id: id, skills: this.skills);
                                          }));
                                        },
                                      ),
                                      dense: false,
                                      title: Text('my skills',
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.grey)),
                                      subtitle: Text("",
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
                                                  new changeSkills(
                                                    id: id,
                                                    skills: this.skills,
                                                  )),
                                        ).then((value) {
                                          setState(() {});
                                        });
                                      },
                                    ),
                                  ),

                                ],
                              )))
                    ]));
          } else if (!snapshot.hasData)
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
          else
            return Center(
              child: Card(
                child: Container(
                  width: 80,
                  height: 80,
                  padding: EdgeInsets.all(12.0),
                  child: Text("Oops.. no data!"),
                ),
              ),
            );
        },
      ),
    );
  }

  uploadImage() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;
    String id = Auth.getCurrentUserID();
    //Select Image
    image = await _picker.getImage(source: ImageSource.gallery);
    var file = File(image.path);

    if (image != null) {
      //Upload to Firebase
      var snapshot = await _storage
          .ref()
          .child('profileImage/' + id)
          .putFile(file)
          .onComplete;
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
        FirebaseFirestore.instance
            .collection('User')
            .doc(id)
            .update({'image': downloadUrl});
        AccountInfo.image = this.imageUrl;
      });
    } else {
      print('No Path Received');
    }
  }
}

class Avatar extends StatelessWidget {
  final String avatarUrl;
  final Function onTap;
  const Avatar({this.avatarUrl, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: avatarUrl == null
            ? CircleAvatar(
                radius: 65.0,
                backgroundColor: Colors.white70,
                child: Icon(
                  Icons.photo_camera,
                  size: 30,
                ),
              )
            : CircleAvatar(
                radius: 65.0,
                backgroundImage: NetworkImage(avatarUrl),
              ),
      ),
    );
  }
}
