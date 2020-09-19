import 'dart:io';
import 'package:cocode/features/homePage/projectScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cocode/features/homePage/projectScreen.dart';
import 'LoginPage.dart';

//sources
//https://firebase.flutter.dev/docs/auth/usage/
//https://stackoverflow.com/questions/61931976/how-to-manage-firebase-authentication-state-in-flutter
//https://flutter.dev/docs/cookbook/navigation/hero-animations
//https://firebase.google.com/docs/reference/cpp/class/firebase/future
//https://stackoverflow.com/questions/56113778/how-to-handle-firebase-auth-exceptions-on-flutter
//https://stackoverflow.com/questions/59377277/undefined-class-authresult-in-flutter
//https://stackoverflow.com/questions/54000825/how-to-get-the-current-user-id-from-firebase-in-flutter
//https://stackoverflow.com/questions/53844052/how-to-make-an-alertdialog-in-flutter
//https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/authStateChanges.html
//https://stackoverflow.com/questions/54469191/persist-user-auth-flutter-firebase
//https://stackoverflow.com/questions/53424916/textfield-validation-in-flutter
//https://stackoverflow.com/questions/51883112/how-to-use-circularprogressindicator-in-flutter
//https://stackoverflow.com/questions/59050143/how-to-verify-an-email-in-firebase-auth-in-flutter
//https://firebase.google.com/docs/firestore

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class Auth {
  static final auth = FirebaseAuth.instance;

  static Future<bool> isLoggedIn() async {
    User user = auth.currentUser;
    if (user == null) {
      return false;
    }
    return true;
  }

  static Future<void> registerUser(
      String userEmail, String userPassword) async {
    await auth.createUserWithEmailAndPassword(
        email: userEmail, password: userPassword);
  }

  static Future<void> loginUser(String userEmail, String userPassword) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: userEmail, password: userPassword);
      //await user.sendEmailVerification();
    } catch (e) {
      authProblems errorType;
      if (Platform.isAndroid) {
        switch (e.message) {
          case 'There is no user record corresponding to this identifier. The user may have been deleted.':
            errorType = authProblems.UserNotFound;
            break;
          case 'The password is invalid or the user does not have a password.':
            errorType = authProblems.PasswordNotValid;
            break;
          case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
            errorType = authProblems.NetworkError;
            break;
          // ...
          default:
            print('Case ${e.message} is not yet implemented');
        }
      } else if (Platform.isIOS) {
        switch (e.code) {
          case 'Error 17011':
            errorType = authProblems.UserNotFound;
            break;
          case 'Error 17009':
            errorType = authProblems.PasswordNotValid;
            break;
          case 'Error 17020':
            errorType = authProblems.NetworkError;
            break;
          // ...
          default:
            print('Case ${e.message} is not yet implemented');
        }
      }

      return AlertDialog(
        title: Text("Error:"),
        content: Text('The error is $errorType'),
        actions: [],
      );
    }
  }

  static Future<void> logout() async {
    await auth.signOut();
  }

  static Future<User> getCurrentUser() async {
    return auth.currentUser;
  }

  static String getCurrentUserID() {
    return auth.currentUser.uid;
  }

  static Future<Widget> directoryPage() async {
    return StreamBuilder<User>(
      stream: auth.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData && (!snapshot.data.isAnonymous)) {
          return ProjectScreen();
        }

        return LoginPage();
      },
    );
  }
}
