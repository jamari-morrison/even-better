import 'package:flutter/material.dart';

import './Helpers/firebase.dart';
import 'login.dart';
import '../main.dart';
import 'sign_up.dart';
import './Helpers/rest_api.dart';

class FirstTime extends StatefulWidget {
  const FirstTime({Key? key}) : super(key: key);

  @override
  State<FirstTime> createState() => _FirstTimeState();
}

class _FirstTimeState extends State<FirstTime> {
  String error = '';

  void _registerRose(username, password, context) {
    //verify account with RoseFire
    registerRose(username, password);

//for testing
    var credentialsValid = true;

    if (credentialsValid) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SignUp(
                    roseUsername: username,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyApp.appTitle),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Login(
                                label1: "Even Better Username",
                                label2: "Even Better Password",
                                submitFunction: requestLoginEB)));
                  },
                  child: const Text("Login")),
              ElevatedButton(
                  child: const Text("Sign Up"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Login(
                                  label1: "Rose-Hulman Username",
                                  label2: "Rose-Hulman Password",
                                  submitFunction: _registerRose,
                                )));
                  }),
              ElevatedButton(
                  child: const Text("Invite Friends"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Login(
                                  label1: "Rose-Hulman Username",
                                  label2: "Rose-Hulman Password",
                                  submitFunction: _registerRose,
                                )));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
