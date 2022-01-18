import 'dart:async';

import 'package:even_better/forum/create_forum.dart';
import 'package:even_better/models/forum_post.dart' as fp;
import 'package:even_better/forum/data.dart';
import 'package:even_better/forum/showAllTags.dart';
import 'package:even_better/post/feed_screen.dart';
import 'package:even_better/screens/loading.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';

class ForumListPage extends StatefulWidget {
  Data db;
  ForumListPage(this.db);
  @override
  _ForumListPageState createState() => _ForumListPageState(db);
}

class _ForumListPageState extends State<ForumListPage> {
  bool loading = false;
  Data db;
  Timer? _timer;
  _ForumListPageState(this.db);
  // var topTagGroup = Container(
  //   alignment: Alignment.center,
  //   decoration: const BoxDecoration(
  //     color: Colors.white,
  //     borderRadius: BorderRadius.all(Radius.circular(15.0)),
  //   ),
  //   child: Container(
  //       alignment: Alignment.bottomCenter,
  //       margin: const EdgeInsets.symmetric(
  //         horizontal: 10.0,
  //         vertical: 0.0,
  //       ),
  //       decoration: const BoxDecoration(
  //         color: Colors.red,
  //         borderRadius: BorderRadius.all(Radius.circular(30.0)),
  //       ),
  //       child: Column(
  //         children: <Widget>[
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: <Widget>[Tag1, Tag("Company", ""), Tag("Project", "")],
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: <Widget>[
  //               Tag("OO Design", ""),
  //               Tag("Java", ""),
  //               Container(
  //                 child: Column(
  //                   children: <Widget>[
  //                     TextButton(
  //                       onPressed: () {
  //                         print("showing more tags");
  //                       },
  //                       child: const Text("···",
  //                           style: TextStyle(color: Colors.white)),
  //                     ),
  //                   ],
  //                 ),
  //               )
  //             ],
  //           ),
  //         ],
  //       )),
  // );
  @override
  void initState() {
    super.initState();
    // EasyLoading.addStatusCallback((status) {
    //   print('EasyLoading Status $status');
    //   if (status == EasyLoadingStatus.dismiss) {
    //     _timer?.cancel();
    //   }
    // });
    // EasyLoading.showSuccess('Loading Succeeded!');
    // EasyLoading.removeCallbacks();
  }

  @override
  Widget build(BuildContext context) {
    db = db.createdb();
    var listpage = Container(
        padding: const EdgeInsets.all(2.0),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) =>
              fp.ForumPost(db.posts[index]),
          itemCount: db.posts.length,
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
                children: <Widget>[db.tags[0], db.tags[1], db.tags[2]],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  db.tags[3],
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
                                        alltags: db.tags,
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
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[SizedBox(height: 5.0), topTagGroup, listpage],

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
        ));
  }

  void _onDotsPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => createForum(db)),
    );
  }

  void _onCreateForumPressed() {
    // Navigator.pop(context);
    print('add new post');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => createForum(db)),
    );
  }
}
