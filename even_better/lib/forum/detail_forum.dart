// ignore_for_file: prefer_const_constructors, avoid_print, prefer_final_fields

import 'dart:async';
import 'dart:convert';

import 'package:even_better/forum/add_comment.dart';
import 'package:even_better/forum/connect.dart';
import 'package:even_better/forum/update_forum.dart';
import 'package:even_better/models/forum_answer.dart';
import 'package:even_better/models/forum_post.dart';
import 'package:even_better/models/user.dart';
import 'package:even_better/report_content/report_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:even_better/models/forum_answer.dart' as fa;
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DetailedForum extends StatefulWidget {
  List<Forum_Answer> comments;
  final String postId;
  Forum_Post post;
  DetailedForum({
    required this.postId,
    required this.comments,
    required this.post,
    Key? key,
  }) : super(key: key);
  @override
  _DetailedForum createState() => _DetailedForum(comments, post);
}

class _DetailedForum extends State<DetailedForum> {
  List<Forum_Answer> forumComments = [];
  List<Forum_Answer> comments;
  Forum_Post post;
  Timer? _timer;
  bool isempty = true;
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  // String serverurl = "http://10.0.2.2:3000";
  String serverurl = "https://api.even-better-api.com";
  _DetailedForum(this.comments, this.post);
  @override
  void initState() {
    super.initState();
    getComments();
  }

  void _onRefresh() async {
    print("trying to refresh");
    await Future.delayed(Duration(milliseconds: 1000), () {
      getComments();
    });
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    print("trying to refresh");
    await Future.delayed(Duration(milliseconds: 1000), () {
      getComments();
    });
    _refreshController.loadComplete();
  }

  void getComments() async {
    List<Forum_Answer> listItems = [];
    String temp = serverurl + "/comments/get/" + post.postId;
    // print(temp);
    final response = await http.get(
      Uri.parse(serverurl + "/comments/get/" + post.postId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response != null && response.statusCode == HttpStatus.ok) {
      List<dynamic> reslist = jsonDecode(response.body);
      // print("reslist is: " + reslist.toString());
      for (var comment in reslist) {
        String aid = comment['_id'];
        String commenter = comment['commenter'];
        String parent = comment['parent-id'];
        String tempContent = comment['content'];
        String tempTime = comment['timestamp'];
        String displayName = comment['commentername'];
        // getUserData(commenter).then((val) {
        //   var userData = val.userData;
        //   displayName = userData["name"];
        //   print("obtained user data! for each comment");
        // }).catchError((err) {
        //   print("failed to get user data :(");
        // });
        Forum_Answer tempFA =
            Forum_Answer(aid, commenter, tempContent, tempTime, displayName);
        listItems.add(tempFA);
      }
      setState(() {
        forumComments = listItems;
        if (forumComments.isNotEmpty) {
          isempty = false;
        }
      });
    } else if (response.statusCode == HttpStatus.noContent) {
      print("No content");
    } else {
      print("Loading Comments DB Error!!!!!");
    }
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
                  post.postername,
                  iconColor: Colors.black,
                ),
                // Text(post.tagNames),
                Text(""),
              ],
            ),
          ),
          Text(post.details),
          const Divider()
        ],
      ),
    );
    var noResponse = SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        header: WaterDropHeader(),
        footer: CustomFooter(builder: (context, mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text("pull up to refresh");
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text("Load Failed!Click to retry!");
          } else if (mode == LoadStatus.canLoading) {
            body = Text("release to load more");
          } else {
            body = Text("No more Data");
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        }),
        // child: Center(child: responses));
        child: Center(
            child: Container(
                margin:
                    const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 2.0),
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Be the first one to contribute!",
                  textScaleFactor: 2,
                  style: TextStyle(
                    fontFamily: 'Billabong',
                  ),
                ))));

    // if (forumComments.isNotEmpty) {
    //   responses = Container(
    //       padding: const EdgeInsets.all(8.0),
    //       child: ListView.builder(
    //         physics: const AlwaysScrollableScrollPhysics(),
    //         itemBuilder: (BuildContext context, int index) =>
    //             fa.ForumAnswer(forumComments[index]),
    //         itemCount: forumComments.length,
    //       ));
    // }
    var thelist = SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        header: WaterDropHeader(),
        footer: CustomFooter(builder: (context, mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text("pull up to refresh");
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text("Load Failed!Click to retry!");
          } else if (mode == LoadStatus.canLoading) {
            body = Text("release to load more");
          } else {
            body = Text("No more Data");
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        }),
        // child: Center(child: responses));
        child: Container(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) =>
                  fa.ForumAnswer(forumComments[index]),
              itemCount: forumComments.length,
            )));

    // var itemsInMenu = [

    var item1 = DropdownMenuItem(
      value: 1,
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () async {
              print("update");
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        updateForum(post.postId, post.title, post.details)),
              );
            },
            color: Colors.transparent,
            icon: const Icon(
              Icons.update,
              size: 35.0,
              color: Colors.black,
            ),
            padding: EdgeInsets.only(right: 10.0),
          ),
          TextButton(
            // style: TextButton.styleFrom(primary: Colors.black),
            onPressed: () async {
              print("update");
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        updateForum(post.postId, post.title, post.details)),
              );
            },
            child: Text("Update", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );

    // Visibility(
    //     visible: (MyUser.isModerator || post.posterid == MyUser.ebuid),
    //     child:
    var item2 = DropdownMenuItem(
        value: 2,
        child: Row(children: <Widget>[
          IconButton(
              onPressed: () async {
                Widget cancelButton = TextButton(
                  child: Text("CANCEL"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                );
                Widget continueButton = TextButton(
                  child: Text("DELETE"),
                  onPressed: () {
                    // print("Trying to delete");
                    deleteForum(post.postId);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                );
                // set up the AlertDialog
                AlertDialog alert = AlertDialog(
                  title: Text("Are you sure?"),
                  content: Text("This forum will be deleted permanently."),
                  actions: [
                    cancelButton,
                    continueButton,
                  ],
                );
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
              },
              color: Colors.transparent,
              padding: const EdgeInsets.only(right: 10.0),
              icon: const Icon(
                Icons.delete,
                size: 35.0,
                color: Colors.black,
              )),
          TextButton(
            // style: TextButton.styleFrom(primary: Colors.black),r
            onPressed: () async {
              Widget cancelButton = TextButton(
                child: Text("CANCEL"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              );
              Widget continueButton = TextButton(
                child: Text("DELETE"),
                onPressed: () {
                  // print("Trying to delete");
                  deleteForum(post.postId);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              );
              // set up the AlertDialog
              AlertDialog alert = AlertDialog(
                title: Text("Are you sure?"),
                content: Text("This forum will be deleted permanently."),
                actions: [
                  cancelButton,
                  continueButton,
                ],
              );
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            },
            child: Text("Delete", style: TextStyle(color: Colors.black)),
          ),
        ]));
    var item3 = DropdownMenuItem(
        value: 3,
        child: Row(children: <Widget>[
          IconButton(
            onPressed: () async {
              // print("report content");
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ReportContent(
                          contentId: post.postId,
                          contentType: "forums",
                        )),
              );
            },
            color: Colors.transparent,
            icon: const Icon(
              Icons.report,
              size: 35.0,
              color: Colors.black,
            ),
            padding: EdgeInsets.only(right: 10.0),
          ),
          TextButton(
            // style: TextButton.styleFrom(primary: Colors.black),
            onPressed: () async {
              // print("report content");
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ReportContent(
                          contentId: post.postId,
                          contentType: "forums",
                        )),
              );
            },
            child: Text("Report", style: TextStyle(color: Colors.black)),
          ),
        ]));
    var itemReport = DropdownMenuItem(
        value: 3,
        child: Row(children: <Widget>[
          IconButton(
            onPressed: () async {
              // print("report content");
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ReportContent(
                          contentId: post.postId,
                          contentType: "forums",
                        )),
              );
            },
            color: Colors.transparent,
            icon: const Icon(
              Icons.report,
              size: 35.0,
              color: Colors.white,
            ),
            padding: EdgeInsets.only(right: 10.0),
          ),
        ]));
    // ];
    var itemsInMenu = [item1, item2, item3];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forum",
            style: TextStyle(
              fontFamily: 'Billabong',
              fontSize: 30.0,
            )),
        actions: <Widget>[
          Visibility(
              visible: !(MyUser.isModerator || post.posterid == MyUser.ebuid),
              child: itemReport),
          Visibility(
            visible: (MyUser.isModerator || post.posterid == MyUser.ebuid),
            child: DropdownButtonHideUnderline(
                // alignedDropdown: true,
                // padding: EdgeInsets.only(right: 10.0),
                child: DropdownButton(
                    icon: const Icon(
                      Icons.menu,
                      size: 35.0,
                      color: Colors.white,
                    ),
                    items: itemsInMenu,
                    // onTap: () => print("Menu pressed"),
                    onChanged: (value) {})),
          ),
          IconButton(
            onPressed: () async {
              // print("add comments");
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
              child: isempty ? noResponse : thelist,
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
