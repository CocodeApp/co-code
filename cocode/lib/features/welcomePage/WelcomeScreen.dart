import 'package:cocode/features/Login/LoginPage.dart';
import 'package:cocode/features/registertion/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'Background.dart';
import 'package:cocode/buttons/RoundeButton.dart';

class CommonThings {
  static Size size;
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }
}

class body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CommonThings.size = MediaQuery.of(context)
        .size; // this size provide us total height and width of screenSize
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: CommonThings.size.height * 0.1),
            Text(
              "Co-Code",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: CommonThings.size.height * 0.5),
            RoundedButton(
              //login button
              text: "LOGIN",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return new LoginPage();
                    },
                  ),
                );
              },
            ),
            SizedBox(height: CommonThings.size.height * 0.03),
            RoundedButton(
              // register button
              text: "REGISTER",
              color: Colors.blue[200],
              textColor: Colors.black,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return new RegisterPage();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
