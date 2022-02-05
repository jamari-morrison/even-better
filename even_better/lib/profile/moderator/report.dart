import 'package:flutter/material.dart';

class Report extends StatelessWidget {
  final String id;
  final String reason;
  final String timestamp;
  const Report(this.id, this.reason, this.timestamp, {Key? key})
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
        title: Text(id),
        subtitle: Text(reason),
        leading: Icon(
          Icons.dashboard,
          color: Colors.red[500],
        ),
        // trailing: Row(
        //   verticalDirection: VerticalDirection.up,
        //   children: <Widget>[
        //     Tag("Framework", "1"),
        //     Tag("Company", "1"),
        //     Tag("Project", "1")
        //   ],
        // ),
        onTap: () {
// go to the post reported

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => DetailedForum(
          //             postId: entry.postId,
          //             comments: entry.answer,
          //             post: entry,
          //           )),
          // );
        },
      ),
    );
  }
}
