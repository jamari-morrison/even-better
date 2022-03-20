import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BroadcastMessage extends StatefulWidget {
  const BroadcastMessage({
    Key? key,
  }) : super(key: key);

  @override
  State<BroadcastMessage> createState() => _BroadcastMessageState();

}

class _BroadcastMessageState extends State<BroadcastMessage> {

  Timer? _timer;
  bool _hasSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _hasSent ? Container(
            child: Column(
              children: [
                Text("Message sent!"),
                Text("The notification has been sent to all students!"),
                ElevatedButton(
                    child: Text("Acknowledge"),
                    onPressed: () async {Navigator.pop(context);})

              ],
            )) : Container(
            child: Column(
              children: [
                Text("Broadcast Message"),
                Text("Send a notification to all students on the app"),
                TextFormField(
                  decoration:  InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "MessageText",
                  ),
                ),
                ElevatedButton(
                    child: Text("Send"),
                    onPressed: () async {
                      _hasSent = true;
                      setState(() {

                      });
                    })

              ],
            )));
  }


  @override
  void initState() {
    super.initState();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    EasyLoading.showSuccess('Loading Succeeded');
  }
}