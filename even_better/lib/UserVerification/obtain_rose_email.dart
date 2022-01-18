import 'package:even_better/UserVerification/Helpers/account_creation.dart';
import 'package:even_better/UserVerification/validate_rose_email.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'Helpers/labeled_text_field.dart';
import 'Helpers/verification_rest_api.dart';

class ObtainRoseEmail extends StatefulWidget {
  const ObtainRoseEmail({
    Key? key,
  }) : super(key: key);

  @override
  State<ObtainRoseEmail> createState() => _ObtainRoseEmailState();
}

class _ObtainRoseEmailState extends State<ObtainRoseEmail> {
  final TextEditingController usernameController = TextEditingController();
  var validEmail = true;
  late Future<AlbumSendEmail> futureAlbum;

//resending is true if the user clicked resend email to call this function
  void _registerRose(username, resending) {
    //verify account with .csv webscraped file
    createAlbumValidateRose(username).then((validAlbum) {
      if (validAlbum.message) {
        createAlbumSendEmail(username).then((album) {
          if (!resending) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ValidateRoseEmail(
                        roseUsername: username, registerRose: _registerRose)));
          }
        }).catchError((error) {
          //modal!
          modalErrorHandler(error, context, "error sending email");
          print("error sending email: " + error);
        });
      } else {
        //MODAL
        modalErrorHandler("contact ... if this is not you", context,
            "Rose email already in use");
      }
    }).catchError((error) {
      //MODAL
      modalErrorHandler(error, context, "error validating rose email");
    });

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
            Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Text("Enter your Rose-Hulman Username")),
            LabeledTextField(
              label: "(exclude @rose-hulman.edu)",
              textEditingController: usernameController,
              isPassword: false,
              isSignUpPassword: false,
              onSubmit: (String val) {},
            ),
            Container(
                margin: const EdgeInsets.only(top: 40),
                child: ElevatedButton(
                    onPressed: () {
                      _registerRose(usernameController.text, false);
                    },
                    child: const Text("Continue"))),
          ],
        ),
      ),
    );
  }
}
