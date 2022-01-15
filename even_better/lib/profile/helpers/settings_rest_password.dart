import 'package:even_better/UserVerification/Helpers/account_creation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void changePassword(String currentPassword, String newPassword, context) async {
  final user = FirebaseAuth.instance.currentUser;
  String? email = user?.email;
  //we don't have anonymous users , so email should never be null
  //but if it is somehow, do nothing
  if (email != null) {
    final cred =
        EmailAuthProvider.credential(email: email, password: currentPassword);

    user?.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {
        //pop back to the homescreen.
        //Probably worth inoforming the user that the password change was successful
        //TODO: clarify that popping to the acconut page is the desired behavior
        Navigator.pop(context);
        Navigator.pop(context);

        // can't use context after popping here. WHY NOT?
        //modalErrorHandler("success", context, "password updated");
        //Success, do something
      }).catchError((error) {
        //Error, show something
        modalErrorHandler(error, context, "Failed to update password");
      });
    }).catchError((err) {
      //Other Error, show something
      modalErrorHandler(err, context, "Failed to update password");
    });
  }
}
