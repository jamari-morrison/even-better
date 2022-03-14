import 'package:even_better/UserVerification/Helpers/account_creation.dart';
import 'package:even_better/UserVerification/Helpers/labeled_text_field.dart';
import 'package:even_better/fb_services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'helpers/settings_rest_api.dart';

class DeletionRevalidate extends StatefulWidget {
  final AuthService auth;
  const DeletionRevalidate(this.auth);

  @override
  State<DeletionRevalidate> createState() => _DeletionRevalidateState();
}

class _DeletionRevalidateState extends State<DeletionRevalidate> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  hasCredentials() {
    print("checking has creds");
    return usernameController.text.trim() != "" &&
        passwordController.text.trim() != "";
  }

  deleteAccount() async {
    print(FirebaseAuth.instance.currentUser);

    AuthCredential credential = EmailAuthProvider.credential(
        email: usernameController.text, password: passwordController.text);
    FirebaseAuth.instance.currentUser!
        .reauthenticateWithCredential(credential)
        .catchError((error) {
      modalErrorHandler(error, context, "incorrect credentials");
    }).then((_) {
      //   widget.auth.deleteAccount().then((_) {
      //     widget.auth.signOut();
      //     Navigator.of(context).pop();
      //     Navigator.of(context).pop();
      //   }).catchError((error) {
      //     //firebase deletion failed
      //   }).then((_) {
      //     createAlbumDeleteAccount(widget.auth.userEmail).catchError((error) {
      //     });
      //   });
      // });

      createAlbumDeleteAccount(widget.auth.userEmail).then((album) {
        widget.auth.deleteAccount().then((value) {
          widget.auth.signOut();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }).catchError((error) {
          print(error);
          modalErrorHandler(
              error, context, "Firebase Account Deletion Failure");
        }).catchError((error) {
          print(error);
          modalErrorHandler(
              error, context, "Even Better Account Deletion Failure");
        });
      });
    });
    //TODO: Error handling here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyApp.appTitle,
            style: TextStyle(
              fontFamily: 'Billabong',
              fontSize: 35.0,
            )),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(
              margin: const EdgeInsets.only(top: 35),
              child: LabeledTextField(
                isPassword: false,
                label: "Username",
                textEditingController: usernameController,
                isSignUpPassword: false,
                onSubmit: (String val) {
                  setState(() {});
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 35),
              child: LabeledTextField(
                isPassword: true,
                label: "Password",
                textEditingController: passwordController,
                isSignUpPassword: false,
                onSubmit: (String val) {
                  setState(() {});
                },
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 40),
                child: ElevatedButton(
                  onPressed: hasCredentials()
                      ? () {
                          Widget cancelButton = TextButton(
                            child: Text("CANCEL"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          );
                          Widget continueButton = TextButton(
                            child: Text("DELETE"),
                            onPressed:
                                //do the deletions!
                                hasCredentials()
                                    ? () {
                                        deleteAccount();
                                      }
                                    : null,
                          );

                          // set up the AlertDialog
                          AlertDialog alert = AlertDialog(
                            title: Text("Are you sure?"),
                            content: Text("Account Deletion is Permanent"),
                            actions: [
                              cancelButton,
                              continueButton,
                            ],
                          );

                          // show the dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                          // Navigator.pop(context);
                        }
                      : null,
                  child: Text('Delete Account'),
                ))
          ],
        ),
      ),
    );
  }
}
