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
  final _messageController = TextEditingController();

  void sendMessage() async{
    String url = 'http://10.0.2.2:3000/notifications/send';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'messageText': _messageController.text,
      }),
    );
  }
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
                    onPressed: () async {
                      int count = 0;
                      Navigator.of(context).popUntil((_) => count++ >= 2);

                    })

              ],
            )) : Container(
            child: Column(
              children: [
                Text("Broadcast Message"),
                Text("Send a notification to all students on the app"),
                TextFormField(
                  controller: _messageController,
                  decoration:  InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "MessageText",
                  ),
                ),
                ElevatedButton(
                    child: Text("Send"),
                    onPressed: () async {
                      _hasSent = true;
                      sendMessage();
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
