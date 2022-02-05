import 'dart:async';
import 'dart:convert';

import 'package:even_better/profile/moderator/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

class ViewReports extends StatefulWidget {
  const ViewReports({Key? key}) : super(key: key);

  @override
  State<ViewReports> createState() => _ViewReportsState();
}

class _ViewReportsState extends State<ViewReports> {
  List<Report> reports = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    getallReports();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    EasyLoading.showSuccess('Reports Loaded');
  }

  void getallReports() async {
    List<Report> listItems = [];
    final uri = Uri.http(
        'ec2-18-217-202-114.us-east-2.compute.amazonaws.com:3000',
        '/reports/all', {});
    final response = await http.get(uri, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    List<dynamic> reslist = jsonDecode(response.body);
    print("reslist is: " + reslist.toString());
    for (var report in reslist) {
      // print("------Trying new" + forum);
      String id = report['_id'];
      // print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!id == " + id);
      String reason = report['reason'];
      String timestamp = report['timestamp'];
      // print("title is " + tempTitle);
      // String id = forum['_id'];
      // print(forum['content']);
      /* TODO: enable tags here*/
      // List<> tempTags = forum['tags'];
      // List<Tag> passInTags = [];
      // for (var t in tempTags) {
      //   Tag temp = Tag(t, "1");
      //   passInTags.add(temp);
      // }
      Report tempFP = Report(id, reason, timestamp);
      // print(tempFP);
      listItems.add(tempFP);
    }
    setState(() {
      reports = listItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    var listpage = Container(
        padding: const EdgeInsets.all(2.0),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) => reports[index],
          itemCount: reports.length,
          shrinkWrap: true,
        ));
    return Scaffold(
        appBar: AppBar(
          title: const Text("Moderator Control",
              style: TextStyle(
                fontFamily: 'Billabong',
                fontSize: 35.0,
              )),
        ),
        body: listpage);
  }
}
