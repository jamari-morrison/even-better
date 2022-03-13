import 'package:flutter/material.dart';

import 'detailed_report.dart';

class Report extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3.0),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
      decoration: const BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: ListTile(
        title: Text(DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp))
            .toLocal()
            .toString()), //format this timestamp
        subtitle: Text(reason),
        leading: Icon(
          Icons.dashboard,
          color: Colors.red[500],
        ),

        onTap: () {
// go to the post reported

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailedReport(
                    id: id, contentType: contentType, contentId: contentId)),
          );
        },
      ),
    );
  }
}
