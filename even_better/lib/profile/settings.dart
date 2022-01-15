import 'package:even_better/UserVerification/Helpers/account_creation.dart';
import 'package:even_better/profile/helpers/settings_rest_password.dart';
import 'package:even_better/profile/password_change.dart';
import 'package:flutter/material.dart';

import '../fb_services/auth.dart';
import './helpers/settings_rest_api.dart';

class Settings extends StatelessWidget {
  final AuthService auth;

  const Settings(this.auth, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings",
            style: TextStyle(
              fontFamily: 'Billabong',
              fontSize: 35.0,
            )),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
        child: ListView(
          // physics: const NeverScrollableScrollPhysics(),
          children: [
            ElevatedButton.icon(
                icon: const Icon(Icons.person),
                label: const Text(
                  'logout',
                  style: TextStyle(
                    fontFamily: 'EB',
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  await auth.signOut();
                  Navigator.pop(context);
                }),
            ElevatedButton(
                child: const Text(
                  'change password',
                  style: TextStyle(
                    fontFamily: 'EB',
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChangePassword()));
                }),
            ElevatedButton(
              onPressed: () {
                Widget cancelButton = TextButton(
                  child: Text("CANCEL"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                );
                Widget continueButton = TextButton(
                  child: Text("DELETE"),
                  onPressed: () {
                    //do the deletions!
                    print(auth.userEmail);
                    createAlbumDeleteAccount(auth.userEmail).then((album) {
                      auth.deleteAccount().then((value) {
                        auth.signOut();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }).catchError((error) {
                        //other modal goes here
                        print(error);
                        modalErrorHandler(error, context,
                            "Even Better Account Deletion Failure");
                      });
                    }).catchError((error) {
                      print(error);
                      //modal here
                      modalErrorHandler(
                          error, context, "Firebase Account Deletion Failure");
                    });
                    //TODO: Error handling here
                  },
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
              },
              child: Text('Delete Account'),
            )
          ],
        ),
      ),
    );
  }
}
