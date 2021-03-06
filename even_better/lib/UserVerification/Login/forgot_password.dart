import 'package:even_better/UserVerification/Helpers/account_creation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../Helpers/labeled_text_field.dart';

GlobalKey _scaffold = GlobalKey();

class ForgotPassword extends StatelessWidget {
  final BuildContext mainContext;
  ForgotPassword({Key? key, required this.mainContext}) : super(key: key);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController usernameController = TextEditingController();

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        title: const Text(MyApp.appTitle),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: const Text("Enter your Even Better email")),
            LabeledTextField(
              label:
                  "The email you used to sign up, which is probably not your rose-hulman email",
              textEditingController: usernameController,
              isPassword: false,
              isSignUpPassword: false,
              onSubmit: (String val) {},
            ),
            Container(
                margin: const EdgeInsets.only(top: 40),
                child: ElevatedButton(
                    onPressed: () {
                      resetPassword(usernameController.text).then((value) {
                        Navigator.of(context).pop();
                        //inform the user of success!
                        modalErrorHandler(
                            "Check your email for a link to change your password",
                            mainContext,
                            "Email Sent");
                      }).catchError((err) {
                        modalErrorHandler(
                            err, context, "failed to send reset email");
                      });
                    },
                    child: const Text("Send Reset Email"))),
          ],
        ),
      ),
    );
  }
}
