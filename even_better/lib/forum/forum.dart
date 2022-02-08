import 'dart:async';
import 'dart:convert';

import 'package:even_better/forum/create_forum.dart';
import 'package:even_better/models/forum_post.dart' as fp;
import 'package:even_better/forum/data.dart';
import 'package:even_better/forum/showAllTags.dart';
import 'package:even_better/models/forum_post.dart';
import 'package:even_better/models/tag.dart';
import 'package:even_better/post/feed_screen.dart';
import 'package:even_better/screens/loading.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';

class ForumListPage extends StatefulWidget {
  // Data db;
  ForumListPage();
  @override
  _ForumListPageState createState() => _ForumListPageState();
}

class _ForumListPageState extends State<ForumListPage> {
  List<Forum_Post> forumPosts = [];
  bool loading = false;
  // Data db;
  List<Tag> tags = [
    Tag("Framework", "1"),
    Tag("Company", "1"),
    Tag("Project", "1"),
    Tag("OO Design", "1")
  ];
  Timer? _timer;
  _ForumListPageState();

  @override
  void initState() {
    super.initState();
    //moved line below to init state. If it's in build, it gets called each time
    //the widget rebuilds on a setState() call
    getallForums();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    EasyLoading.showSuccess('Forums Loaded');
    // EasyLoading.removeCallbacks();
  }

  void getallForums() async {
    List<Forum_Post> listItems = [];
    final uri = Uri.http(
        'ec2-18-217-202-114.us-east-2.compute.amazonaws.com:3000',
        '/forums/all', {});
    final response = await http.get(uri, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    List<dynamic> reslist = jsonDecode(response.body);
    print("reslist is: " + reslist.toString());
    for (var forum in reslist) {
      // print("------Trying new" + forum);
      String id = forum['_id'];
      // print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!id == " + id);
      String tempPoster = forum['poster'];
      String tempTitle = forum['title'];
      // print("title is " + tempTitle);
      String tempContent = forum['content'];
      // String id = forum['_id'];
      // print(forum['content']);
      /* TODO: enable tags here*/
      // List<> tempTags = forum['tags'];
      // List<Tag> passInTags = [];
      // for (var t in tempTags) {
      //   Tag temp = Tag(t, "1");
      //   passInTags.add(temp);
      // }
      Forum_Post tempFP =
          Forum_Post(id, tempPoster, tempTitle, tempContent, [], []);
      // print(tempFP);
      listItems.add(tempFP);
    }
    setState(() {
      forumPosts = listItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    // db = db.createdb();
    // print("all the posts =");
    // print(forumPosts);
    // print("---");

    var listpage = Container(
        padding: const EdgeInsets.all(2.0),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) =>
              fp.ForumPost(forumPosts[index]),
          itemCount: forumPosts.length,
          shrinkWrap: true,
        ));
    var topTagGroup = Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      child: Container(
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 0.0,
          ),
          decoration: const BoxDecoration(
            color: CompanyColors.red,
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[tags[0], tags[1], tags[2]],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  tags[3],
                  Container(
                    child: Column(
                      children: <Widget>[
                        TextButton(
                          onPressed: () async {
                            _timer?.cancel();
                            await EasyLoading.show(
                              status: 'loading...',
                              maskType: EasyLoadingMaskType.black,
                            );
                            print('EasyLoading show');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => showAllTags(
                                        alltags: tags,
                                      )),
                            );
                            EasyLoading.dismiss();
                          },
                          child: const Text("···",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            print("showing more tags");
                            // sleep(Duration(seconds: 3));
                            // setState(() => loading = false);
                          },
                          child: const Text("",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          )),
    );
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0.0,
          title: const Text("Even Better Forum",
              style: TextStyle(
                fontFamily: 'Billabong',
                fontSize: 30.0,
              )),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add_circle),
              onPressed: _onCreateForumPressed,
            ),
          ],
        ),
        //this didn't scroll but now it does!
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[topTagGroup],
            ),
            Expanded(
              child: listpage,
            )
          ],
        ));
  }

  void _onDotsPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => createForum()),
    );
  }

  void _onCreateForumPressed() {
    // Navigator.pop(context);
    print('add new post');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => createForum()),
    );
  }
}
