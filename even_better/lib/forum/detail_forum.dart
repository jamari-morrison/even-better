import 'dart:async';

import 'package:even_better/forum/add_comment.dart';
import 'package:even_better/models/forum_answer.dart';
import 'package:even_better/models/forum_post.dart';
import 'package:even_better/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:even_better/models/forum_answer.dart' as fa;
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DetailedForum extends StatefulWidget {
  List<Forum_Answer> comments;
  Forum_Post post;
  DetailedForum({
    required this.comments,
    required this.post,
    Key? key,
  }) : super(key: key);
  @override
  _DetailedForum createState() => _DetailedForum(comments, post);
}

// ------------------------------------------------------------
// create some fake forum data
// ------------------------------------------------------------
var ForumSamplePost = [
  fa.Forum_Answer("answerid1", "poster1",
      "Hello,\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
  fa.Forum_Answer("answerid2", "poster2",
      "Pellentesque justo metus, finibus porttitor consequat vitae, tincidunt vitae quam. Vestibulum molestie sem diam. Nullam pretium semper tempus. Maecenas lobortis lacus nunc, id lacinia nunc imperdiet tempor. Mauris mi ipsum, finibus consectetur eleifend a, maximus eget lorem. Praesent a magna nibh. In congue sapien sed velit mattis sodales. Nam tempus pulvinar metus, in gravida elit tincidunt in. Curabitur sed sapien commodo, fringilla tortor eu, accumsan est. Proin tincidunt convallis dolor, a faucibus sapien auctor sodales. Duis vitae dapibus metus. Nulla sit amet porta ipsum, posuere tempor tortor.\n\nCurabitur mauris dolor, cursus et mi id, mattis sagittis velit. Duis eleifend mi et ante aliquam elementum. Ut feugiat diam enim, at placerat elit semper vitae. Phasellus vulputate quis ex eu dictum. Cras sapien magna, faucibus at lacus vel, faucibus viverra lorem. Phasellus quis dui tristique, ultricies velit non, cursus lectus. Suspendisse neque nisl, vestibulum non dui in, vulputate placerat elit. Sed at convallis mauris, eu blandit dolor. Vivamus suscipit iaculis erat eu condimentum. Aliquam erat volutpat. Curabitur posuere commodo arcu vel consectetur."),
  fa.Forum_Answer("answerid3", "poster3",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
  fa.Forum_Answer("answerid4", "poster4",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
];
var tag_FrameWork = Tag("Framework", "");
var tag_Project = Tag("Project", "");
var tag_Work = Tag("Work", "");

class _DetailedForum extends State<DetailedForum> {
  List<Forum_Answer> comments;
  Forum_Post post;
  Timer? _timer;

  _DetailedForum(this.comments, this.post);
  @override
  void initState() {
    super.initState();
    // EasyLoading.addStatusCallback((status) {
    //   print('EasyLoading Status $status');
    //   if (status == EasyLoadingStatus.dismiss) {
    //     _timer?.cancel();
    //   }
    // });
    // EasyLoading.showSuccess('Loading Succeeded');
    // EasyLoading.removeCallbacks();
  }

  @override
  Widget build(BuildContext context) {
    var questionSection = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(
            post.title,
            textScaleFactor: 1.5,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconWithText(
                  Icons.person,
                  post.uid,
                  iconColor: Colors.black,
                ),
                Text(post.tagNames),
              ],
            ),
          ),
          const Divider()
        ],
      ),
    );
    var responses = Container(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) =>
              fa.ForumAnswer(comments[index]),
          itemCount: comments.length,
        ));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forum",
            style: TextStyle(
              fontFamily: 'Billabong',
              fontSize: 30.0,
            )),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              // _timer?.cancel();
              // await EasyLoading.show(
              //   status: 'loading...',
              //   maskType: EasyLoadingMaskType.black,
              // );
              // print('EasyLoading show');
              // TODO: press to enter the create post page
              print("add comments");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => commentForum(post)),
              );
              // EasyLoading.dismiss();
            },
            color: Colors.transparent,
            icon: const Icon(
              Icons.add_circle,
              size: 35.0,
              color: Colors.white,
            ),
            padding: EdgeInsets.only(right: 10.0),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          questionSection,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: responses,
            ),
          ),
        ],
      ),
    );
  }
}

class IconWithText extends StatelessWidget {
  final IconData iconData;
  final String text;
  final Color iconColor;

  IconWithText(this.iconData, this.text, {required this.iconColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Icon(
            this.iconData,
            color: this.iconColor,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(this.text),
          ),
        ],
      ),
    );
  }
}
