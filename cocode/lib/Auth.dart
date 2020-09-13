import 'dart:io';
import 'package:cocode/VerifyEmail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'ForgotPassword.dart';
import 'HomePage.dart';
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
//https://stackoverflow.com/questions/46601040/how-to-send-verification-mail-in-firebase-and-forgot-password-link-in-firebase-f
//https://medium.com/@levimatheri/flutter-email-verification-and-password-reset-db2eed893d1d
//https://stackoverflow.com/questions/57362166/flutter-navigate-back-to-selected-page
//https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html
//https://stackoverflow.com/questions/50818770/passing-data-to-a-stateful-widget
//https://pub.dev/packages/fluttertoast

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class Auth {
  static final auth = FirebaseAuth.instance;

  //is user currently logged In?
  static Future<bool> isLoggedIn() async {
    User user = auth.currentUser;

    if (user == null) {
      return false;
    }
    return true;
  }

  // Register new user
  static Future<void> registerUser(
    String userEmail,
    String userPassword,
    String displayName,
  ) async {
    await auth.createUserWithEmailAndPassword(
        email: userEmail, password: userPassword);
    await auth.currentUser.updateProfile(displayName: displayName);
    await auth.currentUser.sendEmailVerification();
  }

  //Log In user
  static Future<void> loginUser(String userEmail, String userPassword) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: userEmail, password: userPassword);
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

  //Logout Current user
  static Future<void> logout() async {
    await auth.signOut();
  }

  //get current user
  static Future<User> getCurrentUser() async {
    return auth.currentUser;
  }

  //get current user ID
  static String getCurrentUserID() {
    return auth.currentUser.uid;
  }

  //get current user email
  static String getCurrentUserEmail() {
    return auth.currentUser.email;
  }

  //method to direct
  static Future<Widget> directoryPage() async {
    return StreamBuilder<User>(
      stream: auth.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          if (Auth.isVerified()) {
            return HomePage();
          } else {
            return new VerifyEmail();
          }

          //auth.sendPasswordResetEmail(email:"email@email.com");

        } else {
          return new LoginPage();
        }
      },
    );
  }

  static Future<void> resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  static bool isVerified() {
    return auth.currentUser.emailVerified;
  }
}
