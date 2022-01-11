import 'package:even_better/UserVerification/Helpers/account_creation.dart';
import 'package:even_better/UserVerification/sign_up.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'Helpers/verification_rest_api.dart';

class ValidateOtp extends StatefulWidget {
  const ValidateOtp({
    required this.roseUsername,
    Key? key,
  }) : super(key: key);
  final String roseUsername;

  @override
  State<ValidateOtp> createState() => _ValidateOtpState();
}

class _ValidateOtpState extends State<ValidateOtp> {
  final TextEditingController codeController = TextEditingController();
  var validOtp = true;
  late Future<AlbumBool> futureAlbum;

  void checkEmailValidated() {
    print("Checking email validate");
    createAlbumIsEmailValidated(widget.roseUsername).then((isVerifiedAlbum) {
      var isVerified = isVerifiedAlbum.message;
      print(isVerified);
      if (!isVerified) {
        modalErrorHandler("User is not verified", context, "not verified :(");
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SignUp(
                      roseUsername: widget.roseUsername,
                    )));
      }
    }).catchError((error) {
      modalErrorHandler(error, context, "database conenction error");
    });

    //verify account with RoseFire
    // futureAlbum = createAlbumValidateOtp(code);
    // futureAlbum.then((album) => setState(() {
    //worth to check if == "false" ?
    validOtp = true;
    //album.message == "true";

    // }));

//for testing
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
            Text(
              "A confirmation link has been sent to your email.\nClick it to continue",
            ),
            Container(
                margin: const EdgeInsets.only(top: 40),
                child: ElevatedButton(
                    onPressed: checkEmailValidated,
                    child: const Text("Confirm Email Validation"))),
          ],
        ),
      ),
    );
  }
}
