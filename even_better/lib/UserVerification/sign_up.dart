import 'package:flutter/material.dart';

import '../main.dart';
import './Helpers/labeled_text_field.dart';
import 'Helpers/account_creation.dart';

class SignUp extends StatefulWidget {
  const SignUp({
    required this.roseUsername,
    required this.name,
    Key? key,
  }) : super(key: key);

  final String name;
  final String roseUsername;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isValidToSignUp() {
    return verifyPasswords() && listRequirements(passwordController.text) == "";
  }

  bool verifyPasswords() {
    listRequirements(passwordController.text);
    setState(() {});
    return passwordController.text == verifyPasswordController.text;
  }

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController verifyPasswordController =
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
            LabeledTextField(
              label: "Username",
              textEditingController: usernameController,
              isPassword: false,
              isSignUpPassword: false,
              onSubmit: (String val) {},
            ),
            Container(
              margin: const EdgeInsets.only(top: 35),
              child: LabeledTextField(
                isPassword: true,
                label: "Password",
                textEditingController: passwordController,
                isSignUpPassword: true,
                onSubmit: (String val) {
                  setState(() {});
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 35),
              child: LabeledTextField(
                label: "Re-enter Password",
                isPassword: true,
                textEditingController: verifyPasswordController,
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
                    onPressed: isValidToSignUp()
                        ? () {
                            requestSignUpEB(
                                usernameController.text,
                                widget.roseUsername,
                                passwordController.text,
                                widget.name,
                                context);
                            //save the rose email here!!
                          }
                        : null,
                    child: const Text("Sign Up"))),
          ],
        ),
      ),
    );
  }
}
