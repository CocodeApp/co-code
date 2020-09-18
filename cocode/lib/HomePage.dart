import 'package:cocode/VerifyEmail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Auth.dart';
import 'LoginPage.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(title: Text('Home Screen')),
          floatingActionButton: FloatingActionButton.extended(
            label: Text('Sign out'),
            onPressed: () async {
              await Auth.logout();
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return new LoginPage();
              }));
            },
          ),
          body: Text("You're logged in to " + Auth.getCurrentUserID()),
        ));
  }
}

/*if () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                      return HomePage();
                                    }));
                                  } else {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                      return VerifyEmail(email: email);
                                    }));
                                  }
                                  */
