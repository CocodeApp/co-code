import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocode/Auth.dart';

// ignore: camel_case_types
class posts extends StatefulWidget {
  static const String id = "CHAT";

  const posts({Key key}) : super(key: key);
  @override
  _postsState createState() => _postsState();
}

class _postsState extends State<posts> {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  String userName = Auth.getCurrentUsername();

  Future<void> callback() async {
    if (messageController.text.length > 0) {
      await firestore.collection('messages').add({
        'text': messageController.text,
        'from': userName, //////////////////////يجيب الايمبل ممكن اغيرها و تصير اليوزر نيم
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
          'Posts',
          style: TextStyle(color: Colors.indigo),
        ),
      ), //ناقص احط خط فوق هذي الكونتينر نفس حق البروفايل اللي سوته لطيفه

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('messages')
                    .orderBy('date')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

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
              height:
                  70, //ناقص احط خط فوق هذي الكونتينر نفس حق البروفايل اللي سوته لطيفه
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 10,
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
          Text(
            from,
          ),
          Material(
            color: currentUser ? Colors.teal[200] : Colors.blue[200],
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
