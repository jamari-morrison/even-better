// ignore_for_file: unnecessary_const

import 'package:even_better/UserVerification/Helpers/account_creation.dart';
import 'package:even_better/report_content/report_content_api.dart';
import 'package:flutter/material.dart';

class ReportContent extends StatelessWidget {
  final String contentId;
  final String contentType;
  ReportContent({required this.contentId, required this.contentType, Key? key})
      : super(key: key);

  void submitReport(context) {
    if (reportTextController.text.trim() != "") {
      createAlbumReportContent(
              contentId, contentType, reportTextController.text)
          .then((value) {
        Navigator.pop(context);
      }).catchError((err) {
        modalErrorHandler(err, context, "failed to submit error report");
      });
    } else {
      modalErrorHandler(
          "please add a reason", context, "no reason for reporting provided");
    }
  }

  final TextEditingController reportTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forum",
            style: TextStyle(
              fontFamily: 'Billabong',
              fontSize: 30.0,
            )),
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        child: Column(children: <Widget>[
          const Text('Reason For Reporting:',
              style: const TextStyle(fontSize: 25)),
          Card(
            borderOnForeground: true,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: null,
                  controller: reportTextController,
                  keyboardType: TextInputType.multiline,
                )),
          ),
          ElevatedButton(
              onPressed: () {
                submitReport(context);
              },
              child: const Text("Submit"))
        ]),
      ),
    );
  }
}
