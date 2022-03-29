import 'dart:async';

import 'package:even_better/forum/TagPage.dart';
import 'package:even_better/models/forum_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Tag extends StatelessWidget {
  final String name;
  // List<String> tagged_forum = <String>[];
  List<Forum_Post> tagged_forum = <Forum_Post>[];
  static String set = "1";
  Timer? _timer;

  Tag(this.name, set) {
    // tagged_forum = <String>[];
  }

  String get tagName {
    return "#" + name + " ";
  }

  // void addPost(String fid) {
  //   tagged_forum.add(fid);
  //
  // }

  void addPost(Forum_Post fid) {
    tagged_forum.add(fid);
  }

  static Tag changeColor(Tag t) {
    if (Tag.set == "1") {
      set = "";
      return t;
    } else {
      set = "1";
      return t;
    }
  }

  // List<String> get post => tagged_forum;
  // @override
  // void initState() {
  //   super.initState();
  //   EasyLoading.addStatusCallback((status) {
  //
  //     if (status == EasyLoadingStatus.dismiss) {
  //       _timer?.cancel();
  //     }
  //   });
  //   EasyLoading.showSuccess('Use in initState');
  //   // EasyLoading.removeCallbacks();
  // }

  @override
  Widget build(BuildContext context) {
    if (set == "1") {
      return Container(
        // padding: const EdgeInsets.all(1.0),
        child: Column(
          children: <Widget>[
            TextButton(
              onPressed: () {
                var forward = Tag(name, "");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TagPage(forward, tagged_forum)),
                );
              },
              child: Text(tagName, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } else {
      return Container(
        // padding: const EdgeInsets.all(1.0),
        child: Column(
          children: <Widget>[
            TextButton(
              onPressed: () async {
                var forward = Tag(name, "");
                _timer?.cancel();
                await EasyLoading.show(
                  status: 'loading...',
                  maskType: EasyLoadingMaskType.black,
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TagPage(forward, tagged_forum)),
                );
                EasyLoading.dismiss();
              },
              child: Text(tagName, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
  }
}
