import 'dart:io';

import 'package:cocode/features/homePage/homePageView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'features/verifyEmail/VerifyEmail.dart';
import 'features/welcomePage/WelcomeScreen.dart';

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
//https://regexr.com/3e48o
//https://gist.github.com/rahulbagal/4a06a997497e6f921663b69e5286d859
//https://stackoverflow.com/questions/37859582/how-to-catch-a-firebase-auth-specific-exceptions
//https://pub.dev/packages/fluttertoast
//https://github.com/abuanwar072/Welcome-Login-Signup-Page-Flutter
//https://stackoverflow.com/questions/58584092/textfieldblocbuilder-in-forms-not-working-when-text-field-is-tapped-on
//https://stackoverflow.com/questions/49040679/flutter-how-to-make-a-textfield-with-hinttext-but-no-underline
//https://stackoverflow.com/questions/54143526/flutter-outline-input-border
//https://stackoverflow.com/questions/50122394/not-able-to-change-textfield-border-color
//https://stackoverflow.com/questions/62210807/firebase-rules-and-flutter-how-to-check-for-username-availability
//https://stackoverflow.com/questions/57546946/overflow-issue-in-flutter
//https://stackoverflow.com/questions/55360628/create-async-validator-in-flutter
//https://stackoverflow.com/questions/55328838/flutter-firestore-add-new-document-with-custom-id
//https://firebase.flutter.dev/docs/firestore/usage/
//https://stackoverflow.com/questions/59654736/trying-to-implement-loading-spinner-while-loading-data-from-firestore-with-flutt

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

//This class is responsible for all operations related to authorization
class Auth {
  static final auth = FirebaseAuth.instance;
  static final store = FirebaseFirestore.instance;
  static CollectionReference users =
      FirebaseFirestore.instance.collection('User');

  //is user currently logged In?
  static bool isLoggedIn() {
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
    await auth.signInWithEmailAndPassword(
        email: userEmail, password: userPassword);
  }

  //Logout Current user
  static Future<void> logout() async {
    await auth.signOut();
  }

  //get the current user
  static Future<User> getCurrentUser() async {
    return auth.currentUser;
  }

  //get current user ID
  static String getCurrentUserID() {
    return auth.currentUser.uid;
  }

  static String getCurrentUsername() {
    return auth.currentUser.displayName;
  }

  //get current user email
  static String getCurrentUserEmail() {
    return auth.currentUser.email;
  }

  //get current user email
  static Future<String> getCurrentFirstname() async {
    DocumentSnapshot result = await users.doc(getCurrentUserID()).get();
    String x = result.data()['firstName'];
    return x;
  }

  //get current user email

  //method to direct either to login page or home page based on login status
  static Future<Widget> directoryPage() async {
    return StreamBuilder<User>(
      stream: auth.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          if (Auth.isVerified()) {
            return homePageView();
          } else {
            return new VerifyEmail();
          }

          //auth.sendPasswordResetEmail(email:"email@email.com");

        } else {
          return new WelcomeScreen(); //LoginPage();
        }
      },
    );
  }

// reset password
  static Future<void> resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

// did the user verify his account email?
  static bool isVerified() {
    return auth.currentUser.emailVerified;
  }

  // send verification email
  static Future<void> sendVerificationEmail() async {
    await auth.currentUser.sendEmailVerification();
  }

//return the type of error
  static String AuthErrorMessage(FirebaseAuthException e) {
    authProblems errorType;
    String warnMessage;
    if (Platform.isAndroid) {
      switch (e.code) {
        case 'ERROR_INVALID_CUSTOM_TOKEN':
          errorType = authProblems.UserNotFound;
          warnMessage =
              "The custom token format is incorrect. Please check the documentation.";
          break;

        case "ERROR_CUSTOM_TOKEN_MISMATCH":
          warnMessage = "The custom token corresponds to a different audience.";
          break;

        case "ERROR_INVALID_CREDENTIAL":
          warnMessage =
              "The supplied auth credential is malformed or has expired.";
          break;

        case "ERROR_INVALID_EMAIL":
          warnMessage = "The email address is badly formatted.";
          break;

        case "ERROR_WRONG_PASSWORD":
          warnMessage =
              "The password is invalid or the user does not have a password.";
          break;

        case "ERROR_USER_MISMATCH":
          warnMessage =
              "The supplied credentials do not correspond to the previously signed in user.";
          break;

        case "ERROR_REQUIRES_RECENT_LOGIN":
          warnMessage =
              "This operation is sensitive and requires recent authentication. Log in again before retrying this request.";
          break;

        case "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL":
          warnMessage =
              "An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.";
          break;

        case "ERROR_EMAIL_ALREADY_IN_USE":
          warnMessage =
              "The email address is already in use by another account.";
          break;

        case "ERROR_CREDENTIAL_ALREADY_IN_USE":
          warnMessage =
              "This credential is already associated with a different user account.";
          break;

        case "ERROR_USER_DISABLED":
          warnMessage =
              "The user account has been disabled by an administrator.";
          break;

        case "ERROR_USER_TOKEN_EXPIRED":
          warnMessage =
              "The user\\'s credential is no longer valid. The user must sign in again.";
          break;

        case "ERROR_USER_NOT_FOUND":
          warnMessage =
              "There is no user record corresponding to this identifier. The user may have been deleted.";
          break;

        case "ERROR_INVALID_USER_TOKEN":
          warnMessage =
              "The user\\'s credential is no longer valid. The user must sign in again.";
          break;

        case "ERROR_OPERATION_NOT_ALLOWED":
          warnMessage =
              "This operation is not allowed. You must enable this service in the console.";
          break;

        case "ERROR_WEAK_PASSWORD":
          warnMessage =
              "The password is invalid it must 6 characters at least.";
          break;

        default:
          warnMessage = "${e.message}";
      }
    }

    return warnMessage;
  }

  //validate password
  static String validatePassword(String password) {
    bool empty = password == null || password.isEmpty;
    bool hasMinLength = password.length >= 8;
    bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
    bool hasSpecialCharacters =
        password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (empty) {
      return 'passsword can\'t be empty!';
    }
    if (!hasMinLength) {
      return 'Make it 8 characters or more!';
    }
    if (!hasDigits) {
      return 'add at least 1 number';
    }
    if (!hasUppercase) {
      return 'Add at least 1 uppercase letter';
    }
    if (!hasLowercase) {
      return 'Add at least 1 lowercase letter';
    }
    if (!hasSpecialCharacters) {
      return 'Add at least 1 special character';
    }
    return null;
  }

  //validate email
  static String validateEmail(String email) {
    bool empty = email == null || email.isEmpty;

    bool validemail =
        email.contains(new RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'));

    if (empty) {
      return 'email can\'t be empty';
    }
    if (!validemail) {
      return 'not a valid email';
    }

    return null;
  }

  static Future<bool> checkUsernameAvailability(String val) async {
    final result =
        await store.collection("User").where('userName', isEqualTo: val).get();

    return result.docs.isEmpty;
  }

  static Future<bool> checkemailAvailability(String val) async {
    final result =
        await store.collection("User").where('email', isEqualTo: val).get();

    return result.docs.isEmpty;
  }

  static Future<String> updateEmail(String newEmail) async {
    try {
      await auth.currentUser.updateEmail(newEmail);
    } catch (e) {
      return AuthErrorMessage(e);
    }

    return null;
  }

  static Future<DocumentSnapshot> getcurrentUserInfo() async {
    return await users.doc(Auth.getCurrentUserID()).get();
  }
}
