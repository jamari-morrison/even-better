import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'invite.dart';

class InviteYear extends StatefulWidget {
  const InviteYear({
    required this.currentStudent,
    Key? key,
  }) : super(key: key);
  final String currentStudent;

  @override
  State<InviteYear> createState() => _InviteYearState();
}

class _InviteYearState extends State<InviteYear> {
  List<Widget> itemsData = [];
  List<dynamic> itemStatuses = [];
  Timer? _timer;

  void getItemData() {
    List<Widget> listItems = [];

    for (var year = 2020; year <= 2025; year++) {
      listItems.add(ElevatedButton(
          child: Text(year.toString()),
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
                    builder: (context) => Invite(
                          currentStudent: 'Jamari Morrison',
                          year: year,
                        )));
            EasyLoading.dismiss();
          }));
    }

    setState(() {
      itemsData = listItems;
      //print(listItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    getItemData();

    return Scaffold(
        body: Container(
            child: Column(
      children: [
        Expanded(
            child: ListView.builder(
                itemCount: itemsData.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  // print("printing");
                  // print(itemsData);
                  return itemsData[index];
                }))
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
