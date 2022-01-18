import 'package:even_better/post/feed_screen.dart';
import 'package:flutter/material.dart';
import '../UserVerification/firsttime.dart';
import 'home/home.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    // when user logs in, a user object will be stored in this variable, set to null if logged out.
    final user = Provider.of<MyUser?>(context, listen: true);

    print("${user}  [Wrapper]");
    // return either home or authenticate widget
    // return const FirstTime();
    if (user == null) {
      print('first time page [Wrapper]');
      return FirstTime();
    } else {
      print('home page [Wrapper]');

      return FeedScreen();
    }
  }
}
