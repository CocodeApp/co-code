import 'package:cocode/features/homePage/homePageView.dart';
import 'package:flutter/material.dart';
import 'form.dart';

class PostIdeaFormPage extends StatefulWidget {
  PostIdeaFormPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<PostIdeaFormPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //reference: https://github.com/flutter/samples/tree/master/experimental/form_app
    //
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.deepOrangeAccent,
        ),
        title: Text(
          widget.title,
          style: TextStyle(color: Color(0XFF2A4793)),
        ),
        elevation: 0,
      ),
      body: Center(child: form()),
    );
  }
}
