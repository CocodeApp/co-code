import 'package:cocode/features/posts/posts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocode/Auth.dart';

// ignore: must_be_immutable, camel_case_types
class channels extends StatefulWidget {
  var projectId;
  bool isSuper;
  channels({Key key, @required this.projectId, @required this.isSuper})
      : super(key: key);
  @override
  _channelsState createState() => _channelsState();
}

// ignore: camel_case_types
class _channelsState extends State<channels> {
  CollectionReference projects =
      FirebaseFirestore.instance.collection('projects');
  String user = Auth.getCurrentUserID();
  ValueNotifier<String> supervisor = new ValueNotifier<String>("");
  @override
  Widget build(BuildContext context) {
    projects.doc(widget.projectId).get().then((snapshot) {
      supervisor.value = snapshot.data()['supervisor'];
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.deepOrangeAccent,
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Channels',
          style: TextStyle(color: Colors.indigo),
        ),
      ),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: projects
                    .doc(widget.projectId)
                    .collection('messages')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
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
                  } // has no data if closing
                  List channels = snapshot.data.docs;
                  return channelsList(channels);
                }),
          ),
          ValueListenableBuilder(
            builder: (BuildContext context, value, Widget child) {
              return supervisor.value == user
                  ? FloatingActionButton(
                      backgroundColor: Colors.deepOrangeAccent,
                      child: Icon(Icons.add),
                      onPressed: () {
                        addChannel();
                      })
                  : SizedBox();
            },
            valueListenable: supervisor,
          ),
        ]),
      ),
    ); // StreamBuilder
  }

  Widget channelsList(List channels) {
    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: channels.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Chat(
                        projectId: widget.projectId,
                        channleId: channels[index].id),
                  ));
            },
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
                            padding: const EdgeInsets.fromLTRB(25, 5, 0, 5),
                            child: Text(
                              channels[index].data()['name'],
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
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
                )),
          );
          // Container(
          //   height: 120.0,
          //   margin: const EdgeInsets.symmetric(
          //     vertical: 16.0,
          //     horizontal: 24.0,
          //   ),
          //   child: Stack(children: [
          //     Container(
          //       clipBehavior: Clip.hardEdge,
          //       alignment: Alignment.center,
          //       height: 124.0,
          //       decoration: new BoxDecoration(
          //         color: new Color(0xFFD1DDED),
          //         shape: BoxShape.rectangle,
          //         borderRadius: new BorderRadius.circular(8.0),
          //         boxShadow: <BoxShadow>[
          //           new BoxShadow(
          //             color: Colors.black12,
          //             blurRadius: 10.0,
          //             offset: new Offset(0.0, 10.0),
          //           ),
          //         ],
          //       ),
          //       child: InkWell(
          //         splashColor: Colors.blue.withAlpha(30),
          //         onTap: () {
          //           Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                 builder: (context) => Chat(
          //                     projectId: widget.projectId,
          //                     channleId: channels[index].id),
          //               ));
          //         },
          //         child: ListTile(
          //           title: Text(
          //             channels[index].data()['name'],
          //             textAlign: TextAlign.center,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ]),
          // );
        });
  }

  Future<void> addChannel() async {
    CollectionReference channels = FirebaseFirestore.instance
        .collection('projects')
        .doc(widget.projectId)
        .collection('messages');
    final nameController = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add new channel'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Channel name:'),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'e.g. Development',
                  ),
                  controller: nameController,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Add'),
              onPressed: () {
                channels.add({'name': nameController.text});
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}

// class addButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
