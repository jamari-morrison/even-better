// ignore_for_file: file_names

import 'package:even_better/models/tag.dart';
import 'package:even_better/post/feed_screen.dart';
import 'package:flutter/material.dart';

class showAllTags extends StatefulWidget {
  final List<Tag> alltags;
  const showAllTags({Key? key, required this.alltags}) : super(key: key);

  @override
  _showAllTagsState createState() => _showAllTagsState(alltags);
}

class _showAllTagsState extends State<showAllTags> {
  final List<Tag> alltags;
  _showAllTagsState(this.alltags);
  @override
  Widget build(BuildContext context) {
    var a = Container(
        decoration: const BoxDecoration(
          color: CompanyColors.red,
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[alltags[0], alltags[1], alltags[2]],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                alltags[3],
                // Container(
                //   child: Column(
                //     children: <Widget>[
                //       TextButton(
                //         onPressed: () {
                //           print("showing more tags");
                //         },
                //         child: const Text("···",
                //             style: TextStyle(color: Colors.white)),
                //       ),
                //     ],
                //   ),
                // ),
                // Container(
                //   child: Column(
                //     children: <Widget>[
                //       TextButton(
                //         onPressed: () {
                //           print("showing more tags");
                //         },
                //         child:
                //             const Text("", style: TextStyle(color: Colors.white)),
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          ],
        ));
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0.0,
          title: const Text("Even Better Forum"),
        ),
        body: Container(
            child: Column(
          children: <Widget>[a, Container()],

          // <Widget>[
          //   Row(
          //     children: <Widget>[topTagGroup],
          //   ),
          //   // Expanded(
          //   //   child: listpage,
          //   // )
          // ],
        )));
  }
}
