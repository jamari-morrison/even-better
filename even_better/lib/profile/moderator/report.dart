import 'package:even_better/UserVerification/Helpers/account_creation.dart';
import 'package:even_better/profile/helpers/settings_rest_api.dart';
import 'package:flutter/material.dart';

import 'detailed_report.dart';

class Report extends StatefulWidget {
  final String id;
  final String reason;
  final String timestamp;
  final String contentType;
  final String contentId;
  const Report(
      this.contentId, this.contentType, this.id, this.reason, this.timestamp,
      {Key? key})
      : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  bool resolved = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3.0),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
      decoration: const BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: ListTile(
        title: Text(
            DateTime.fromMillisecondsSinceEpoch(int.parse(widget.timestamp))
                .toLocal()
                .toString()), //format this timestamp
        subtitle: Text(widget.reason),
        leading: Icon(
          getIcon(),
          color: Colors.red[500],
        ),
        trailing: resolved
            ? Icon(
                Icons.check,
                color: Colors.green,
              )
            : ElevatedButton(
                onPressed: () {
//delete the report
                  createAlbumDeleteReport(widget.id).then((value) {
                    setState(() {
                      resolved = true;
                    });
                  }).catchError((onError) {
                    modalErrorHandler(
                        onError, context, "failed to delete report");
                  });
                },
                child: Icon(
                  Icons.delete,
                ),
              ),

        onTap: () {
// go to the post reported
//TODO:
//need to have different types here!!

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailedReport(
                    id: widget.id,
                    contentType: widget.contentType,
                    contentId: widget.contentId)),
          );
        },
      ),
    );
  }

  getIcon() {
    switch (widget.contentType) {
      case "forums":
        return Icons.forum;
      case "comments":
        return Icons.comment;
      case "posts":
        return Icons.photo_size_select_actual_sharp;
      default:
    }
  }
}
