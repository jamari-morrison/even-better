// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'dart:convert';

import 'package:even_better/profile/moderator/report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ViewReports extends StatefulWidget {
  const ViewReports({Key? key}) : super(key: key);

  @override
  State<ViewReports> createState() => _ViewReportsState();
}

class _ViewReportsState extends State<ViewReports> {
  List<Report> reports = [];
  // Timer? _timer;
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  @override
  void initState() {
    super.initState();
    getallReports();
    // EasyLoading.addStatusCallback((status) {
    //   print('EasyLoading Status $status');
    //   if (status == EasyLoadingStatus.dismiss) {
    //     _timer?.cancel();
    //   }
    // });
    // EasyLoading.showSuccess('Reports Loaded');
  }

  void getallReports() async {
    List<Report> listItems = [];
    final uri = Uri.parse('https://api.even-better-api.com/reports/all');
    final response = await http.get(uri, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    List<dynamic> reslist = jsonDecode(response.body);
    // print("reslist is: " + reslist.toString());
    for (var report in reslist) {
      String id = report['_id'];
      String reason = report['reason'];
      String timestamp = report['timestamp'];
      String contentType = report['content-type'];
      String contentId = report['content-id'];
      // print(contentType);

      Report tempFP = Report(contentId, contentType, id, reason, timestamp);
      listItems.add(tempFP);
    }
    setState(() {
      reports = listItems;
    });
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000), () {
      getallReports();
    });
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000), () {
      getallReports();
    });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    var listpage = SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        header: WaterDropHeader(),
        footer: ClassicFooter(),
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
