import 'package:flutter/material.dart';

import '../main.dart';
import 'Helpers/labeled_text_field.dart';
import 'Helpers/account_creation.dart';
import 'forgot_password.dart';

class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
              label: "Even Better Username",
              textEditingController: usernameController,
              isPassword: false,
              isSignUpPassword: false,
              onSubmit: (String val) {},
            ),
            Container(
              margin: const EdgeInsets.only(top: 35),
              child: LabeledTextField(
                  label: "Even Better Password",
                  textEditingController: passwordController,
                  isPassword: true,
                  isSignUpPassword: false,
                  onSubmit: (String val) {}),
            ),
            Container(
                margin: const EdgeInsets.only(top: 40),
                child: ElevatedButton(
                    onPressed: () {
                      requestLoginEB(usernameController.text,
                          passwordController.text, context);
                    },
                    child: const Text("Login"))),
            Container(
                margin: const EdgeInsets.only(top: 40),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPassword()));
                    },
                    child: const Text("Forgot Password?"))),
          ],
        ),
      ),
    );
  }
}
