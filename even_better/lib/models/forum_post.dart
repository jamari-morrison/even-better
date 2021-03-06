import 'package:even_better/forum/detail_forum.dart';

import 'forum_answer.dart';
import 'tag.dart';
import 'package:flutter/material.dart';

class Forum_Post {
  final String postername; // auther
  final String postId;
  final String posterid;
  // final String fid; // forum_id
  DateTime post_time = DateTime.utc(1989, DateTime.november, 9);
  // DateTime _now = DateTime.now();
  String title;
  String details;
  List<Tag> tags;

  List<Forum_Answer> answers;

  Forum_Post(this.postId, this.postername, this.posterid, this.title,
      this.details, this.tags, this.answers) {
    post_time = DateTime.now();
  }

  List<Forum_Answer> get answer => answers;
}

class ForumPost extends StatelessWidget {
  final Forum_Post entry;
  ForumPost(this.entry);

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
        title: Text(entry.title),
        subtitle: Text(entry.details),
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
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailedForum(
                      postId: entry.postId,
                      comments: entry.answer,
                      post: entry,
                    )),
          );
        },
      ),
    );
  }
}
