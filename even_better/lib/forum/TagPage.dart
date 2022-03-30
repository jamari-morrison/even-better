// ignore_for_file: file_names

import 'package:even_better/models/forum_post.dart' as fp;
import 'package:even_better/models/forum_post.dart';
import 'package:even_better/models/tag.dart';
import 'package:flutter/material.dart';

class TagPage extends StatefulWidget {
  final Tag tag;
  final List<Forum_Post> fpost;
  TagPage(this.tag, this.fpost);

  @override
  _TagPageState createState() => _TagPageState(tag, fpost);
}

class _TagPageState extends State<TagPage> {
  final Tag tag;
  final List<Forum_Post> fpost;
  _TagPageState(this.tag, this.fpost);

  @override
  Widget build(BuildContext context) {
    var TagName = tag.tagName;
    // var allForums = tag.post; // <----- use this when integrate with backend
    var listpage = Container(
        padding: const EdgeInsets.all(2.0),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) =>
              fp.ForumPost(fpost[index]),
          itemCount: fpost.length,
          shrinkWrap: true,
        ));
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0.0,
        title: const Text("Even Better Forum"),
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(Icons.add_circle),
        //     onPressed: _onCreateForumPressed,
        //   ),
        // ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[listpage],

          // <Widget>[
          //   Row(
          //     children: <Widget>[topTagGroup],
          //   ),
          //   // Expanded(
          //   //   child: listpage,
          //   // )
          // ],
        ),
      ),
    );
  }

  // void _onCreateForumPressed() {
  //   // Navigator.pop(context);
  //
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => createForum(Data)),
  //   );
  // }
}
