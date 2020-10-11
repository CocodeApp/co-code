import 'package:flutter/material.dart';

class posts extends StatefulWidget {
  @override
  _postsState createState() => _postsState();
}

class _postsState extends State<posts> {
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
        title: Text(
          'posts',
          style: TextStyle(color: Colors.indigo),
        ),
      ),
    );
  }
}
