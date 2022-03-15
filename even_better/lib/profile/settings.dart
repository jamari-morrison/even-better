import 'package:even_better/UserVerification/Helpers/account_creation.dart';
import 'package:even_better/profile/deletion_revalidate.dart';
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
            ElevatedButton(
                child: const Text(
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
                child: const Text(
                  'delete account',
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
                          builder: (context) => DeletionRevalidate(auth)));
                }),
          ],
        ),
      ),
    );
  }
}
