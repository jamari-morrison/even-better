import 'dart:async';

import 'package:even_better/post/feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
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
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    initPlatform();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    EasyLoading.showSuccess('Welcome!');
    // EasyLoading.removeCallbacks();
  }

  @override
  Widget build(BuildContext context) {
    // when user logs in, a user object will be stored in this variable, set to null if logged out.
    final user = Provider.of<MyUser?>(context, listen: true);

    print("${user}  [Wrapper]");
    // return either home or authenticate widget
    // return const FirstTime();
    if (user == null) {
      print('first time page [Wrapper]');
      return FirstTime(mainContext: context);
    } else {
      print('home page [Wrapper]');

      return FeedScreen();
    }
  }

  Future<void> initPlatform() async {
    await OneSignal.shared.setAppId("68f951ef-3a62-4c97-89dc-7ef962b29bc6");
    await OneSignal.shared.getDeviceState().then((value) => {
      print(value!.userId)
    });
  }
}
