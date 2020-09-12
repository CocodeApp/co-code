import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Auth.dart';
import 'LoginPage.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Screen')),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Sign out'),
        onPressed: () async {
          await Auth.logout();

          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return LoginPage();
          }));
        },
      ),
      body: Text("You're logged in to " + Auth.getCurrentUserID()),
    );
  }
}
