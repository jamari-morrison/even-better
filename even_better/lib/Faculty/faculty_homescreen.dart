import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'broadcast_message.dart';
import 'manage_polls.dart';
class FacultyHomescreen extends StatefulWidget {
  const FacultyHomescreen({
    required this.currentStudent,
    Key? key,
  }) : super(key: key);
  final String currentStudent;

  @override
  State<FacultyHomescreen> createState() => _FacultyHomescreenState();

}

class _FacultyHomescreenState extends State<FacultyHomescreen> {
  List<Widget> itemsData = [];
  List<dynamic> itemStatuses = [];
  Timer? _timer;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Container(
            child: Column(
              children: [
                ElevatedButton(
                    child: Text("Broadcast Message"),
                    onPressed: () async {
                      _timer?.cancel();
                      await EasyLoading.show(
                        status: 'loading...',
                        maskType: EasyLoadingMaskType.black,
                      );
                      print('loading all students');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BroadcastMessage()));
                      EasyLoading.dismiss();
                    }),
                ElevatedButton(
                    child: Text("Manage Polls"),
                    onPressed: () async {
                      _timer?.cancel();
                      await EasyLoading.show(
                        status: 'loading...',
                        maskType: EasyLoadingMaskType.black,
                      );
                      print('loading all students');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ManagePolls()));
                      EasyLoading.dismiss();
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
