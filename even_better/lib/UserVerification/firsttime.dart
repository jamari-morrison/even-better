import 'package:even_better/UserVerification/obtain_rose_email.dart';
import 'package:flutter/material.dart';

import 'Helpers/account_creation.dart';
import 'login.dart';
import '../main.dart';
import 'sign_up.dart';
import 'Helpers/verification_rest_api.dart';

class FirstTime extends StatefulWidget {
  const FirstTime({Key? key}) : super(key: key);

  @override
  State<FirstTime> createState() => _FirstTimeState();
}

class _FirstTimeState extends State<FirstTime> {
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          MyApp.appTitle,
          style: TextStyle(
            fontFamily: 'Billabong',
            fontSize: 35.0,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontFamily: 'EB',
                      fontSize: 25.0,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
              ElevatedButton(
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontFamily: 'EBX',
                      fontSize: 25.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ObtainRoseEmail()));
                  }),
              // ElevatedButton(
              //     child: const Text("Invite Friends"),
              //     onPressed: () {
              //       Navigator.push(context,
              //           MaterialPageRoute(builder: (context) => const Login()));
              //     }),
            ],
          ),
        ),
      ),
    );
  }
}
