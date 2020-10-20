import 'package:cocode/features/posts/posts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocode/Auth.dart';

// ignore: camel_case_types
class channels extends StatefulWidget {
  var projectId;
  channels({Key key, @required this.projectId}) : super(key: key);
  @override
  _channelsState createState() => _channelsState();
}
final FirebaseFirestore firestore = FirebaseFirestore.instance;
class _channelsState extends State<channels> {
  ScrollController scrollController = ScrollController();
  String userName = Auth.getCurrentUsername();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.deepOrangeAccent,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Channels',
          style: TextStyle(color: Colors.indigo),
        ),
      ),

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('project').doc('projectId')
                    .collection('messages').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  List<DocumentSnapshot> docs = snapshot.data.docs;
                  List<Widget> channels = docs
                      .map((doc) => Channel(channelName: doc.data()['name'],))
                      .toList();

                  return ListView(
                    controller: scrollController,
                    children: <Widget>[
                      ...channels,
                    ],
                  );
                },
              ),
            ),
            FloatingActionButton(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              backgroundColor: Colors.deepOrangeAccent,
              onPressed: channelNameDialog(),
            ),
          ],
        ),
      ),
    );
  }
  channelNameDialog() async {
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        //contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                //onSubmitted: addChannel(),
                decoration: new InputDecoration(
                    labelText: 'Channel Name'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          SendButton(
            //callback: addChannel(),
              ),
          new FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }
  }
  Future<void> addChannel(String channelName) async {
    if (channelName.length > 0) {
      await firestore.collection('project').doc('projectId')
          .collection('messages').add({
        'name': channelName,
      });
    }

  }


class Channel extends StatelessWidget {
  final String channelName;
  Channel({Key key,  this.channelName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white54,
      child: Row(
        children: [
          Text("channelName"),
          IconButton(
            icon: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}



