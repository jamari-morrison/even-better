import 'package:even_better/UserVerification/Helpers/account_creation.dart';
import 'package:even_better/UserVerification/Signup/sign_up.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../Helpers/verification_rest_api.dart';
import 'confirm_name.dart';

class ValidateRoseEmail extends StatefulWidget {
  const ValidateRoseEmail({
    required this.roseUsername,
    required this.registerRose,
    Key? key,
  }) : super(key: key);
  final String roseUsername;
  final Function registerRose;

  @override
  State<ValidateRoseEmail> createState() => _ValidateRoseEmailState();
}

class _ValidateRoseEmailState extends State<ValidateRoseEmail> {
  final TextEditingController codeController = TextEditingController();
  late Future<AlbumBool> futureAlbum;

  void checkEmailValidated() {
    createAlbumIsEmailValidated(widget.roseUsername).then((isVerifiedAlbum) {
      var isVerified = isVerifiedAlbum.message;

      if (!isVerified) {
        modalErrorHandler("User is not verified", context, "not verified :(");
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConfirmName(
                      roseUsername: widget.roseUsername,
                    )));
      }
    }).catchError((error) {
      modalErrorHandler(error, context, "database conenction error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyApp.appTitle),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const Text(
              "A confirmation link has been sent to your email.\nClick it to continue",
            ),
            Container(
                margin: const EdgeInsets.only(top: 40),
                child: ElevatedButton(
                    onPressed: checkEmailValidated,
                    child: const Text("Confirm Email Validation"))),
            Container(
                margin: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                    onPressed: () {
                      widget.registerRose(widget.roseUsername, true);
                    },
                    child: const Text("Resend Email"))),
          ],
        ),
      ),
    );
  }
}
