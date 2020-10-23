import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocode/Auth.dart';

// ignore: camel_case_types
class Chat extends StatefulWidget {
  var projectId;
  var channleId;
  Chat({Key key,@required this.projectId,@required this.channleId}) : super(key: key);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  String userName = Auth.getCurrentUsername();


  Future<void> callback() async {

    if (messageController.text.length > 0) {
      await firestore.collection('projects').doc(widget.projectId)
          .collection('messages').doc(widget.channleId).
      collection('chat').add({
        'text': messageController.text,
        'from': userName,
        'date': DateTime.now().toIso8601String().toString(),
      });
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var channel = firestore.collection('projects').doc(widget.projectId)
        .collection('messages').doc(widget.channleId).get();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.deepOrangeAccent,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text( "channel",
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
            .collection('projects').doc(widget.projectId)
            .collection('messages').doc(widget.channleId).
        collection('chat')
                    .orderBy('date')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  // if (snapshot.hasError) {
                  //   return Text("Something went wrong");
                  //  }
                  // if (snapshot.connectionState == ConnectionState.done) {
                  //   Map<String, dynamic> data = snapshot.data.data();
                  // }
                  List<DocumentSnapshot> docs = snapshot.data.docs;

                  List<Widget> messages = docs
                      .map((doc) => Message(

                    from: doc.data()['from'],
                    text: doc.data()['text'],
                    currentUser:
                    userName == doc.data()['from'],
                  ))
                      .toList();

                  return ListView(
                    controller: scrollController,
                    children: <Widget>[
                      ...messages,
                    ],
                  );
                },
              ),
            ),
            // send massage container

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],),
              height:
              0.1*MediaQuery.of(context).size.height,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 0.05*MediaQuery.of(context).size.width,
                  ),
                  Expanded(
                    child: TextField(
                      onSubmitted: (value) => callback(),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10),
                        hintText: "Enter a Message...",
                        border: const OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                      ),
                      controller: messageController,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  SendButton(
                    callback: callback,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// here button color setting
class SendButton extends StatelessWidget {
  final VoidCallback callback;

  const SendButton({Key key, this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(13.0),
      textColor: Colors.indigo,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(15.0)),
      splashColor: Colors.blueAccent,
      color: Colors.deepOrangeAccent,
      onPressed: callback,
      child: Icon(Icons.send),
    );
  }
}

// massages duration
class Message extends StatelessWidget {
  final String from; // user how sent the massage
  final String text; // body of the massage

  final bool currentUser;

  const Message({Key key, this.from, this.text, this.currentUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment:
        currentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding:   currentUser ? EdgeInsets.only(
              right:0.03*MediaQuery.of(context).size.width,):  EdgeInsets.only(left:0.03*MediaQuery.of(context).size.width, ),
            child:Text(
              from,
            ),
          ),

          Material(
            color: currentUser ? Colors.teal[100] : Colors.blue[100],
            borderRadius: BorderRadius.circular(10.0),
            elevation: 6.0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Text(
                text,
              ),
            ),
          )
        ],
      ),
    );
  }
}
