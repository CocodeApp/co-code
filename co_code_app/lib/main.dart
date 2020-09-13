import 'package:flutter/material.dart';
import 'postIdeaForm.dart';
import 'homePage.dart' as home;
import 'myProjectsPage.dart' as projects;
import 'viewProject.dart' as view;

void main() {
  runApp(home.homePage());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(appBar: AppBar(), body: home.IdeaCard()));
  }
}
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Co-Code',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: PostIdeaFormPage(title: 'Post Idea'),
//     );
//   }
// }
