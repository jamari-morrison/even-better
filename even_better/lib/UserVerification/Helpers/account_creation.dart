import 'package:even_better/fb_services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../confirm_name.dart';
import "./verification_rest_api.dart";

final FirebaseAuth _auth = FirebaseAuth.instance;

//intermediary functions that communicate with FirebaseAuth. Could merge these together if we wanted to

void modalErrorHandler(error, context, title) {
  print(error);
  //pop up modal to show failure!

  Widget cancelButton = TextButton(
    child: const Text("DISMISS"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  var errorMessage = error.toString();
  //for parsing the firebase error responses.. probably want to do these on our own eventually
  if (errorMessage.contains("] ")) {
    errorMessage = errorMessage.split("] ")[1];
  }
  // var errorMessage = error.toString().contains("] ")
  //     ? error.toString()
  //     : error.toString().split("] ")[1];

  print("message! : " + errorMessage);
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(errorMessage),
    actions: [cancelButton],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void requestLoginEB(String username, String password, context) async {
  //verify account with our FireBase

  print("Even better username: ${username}\n password: ${password}");
  _auth
      .signInWithEmailAndPassword(email: username, password: password)
      .then((val) {
    // loginEB(username, password).then
    Navigator.pop(context);
  }).catchError((error) {
    modalErrorHandler(error, context, "Login Failure");
  });
}

void requestSignUpEB(String username, String roseUsername, String password,
    name, context) async {
  //verify account with our FireBase
  AuthService fbAuth = AuthService();

  _auth
      .createUserWithEmailAndPassword(email: username, password: password)
      .then((val) {
    if (val.user?.email == username) {
      createAlbumSignUpEB(username, roseUsername, name).then((value) {
        //pop to the homescreen
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        //push the name confirm page
      }).catchError((error) {
        //delete the the account that fb created since we can't connect to the
        //database to finish creating the account
        //if this then fails, there's no saving us.
        fbAuth.deleteAccount();

        modalErrorHandler(error, context, "Database connection error");
      });
    }
  }).catchError((error) {
    modalErrorHandler(error, context, "Account Creation Failure");
  });

  //pop away the current path!
}
