import 'package:even_better/UserVerification/Helpers/account_creation.dart';
import 'package:even_better/UserVerification/Helpers/labeled_text_field.dart';
import 'package:even_better/profile/helpers/settings_rest_password.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword();

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool isValidToChangeCredentials() {
    return verifyPasswords() &&
        listRequirements(newPasswordController.text) == "";
  }

  bool verifyPasswords() {
    listRequirements(newPasswordController.text);
    setState(() {});
    return newPasswordController.text == verifyNewPasswordController.text;
  }

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController verifyNewPasswordController =
      TextEditingController();

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
                isPassword: true,
                label: "Old Password",
                textEditingController: oldPasswordController,
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
                label: "New Password",
                textEditingController: newPasswordController,
                isSignUpPassword: true,
                onSubmit: (String val) {
                  setState(() {});
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 35),
              child: LabeledTextField(
                label: "Re-enter New Password",
                isPassword: true,
                textEditingController: verifyNewPasswordController,
                isSignUpPassword: true,
                onSubmit: (String val) {
                  setState(() {});
                },
              ),
            ),
            verifyPasswords()
                ? const Text("")
                : Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: const Text("Passwords do not match",
                        style: TextStyle(
                          color: Colors.red,
                        )),
                  ),
            Container(
                margin: const EdgeInsets.only(top: 40),
                child: ElevatedButton(
                    onPressed: isValidToChangeCredentials()
                        ? () {
                            changePassword(oldPasswordController.text,
                                newPasswordController.text, context);
                          }
                        : null,
                    child: const Text("Set New Password"))),
          ],
        ),
      ),
    );
  }
}
