// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields

import 'dart:async';
import 'dart:convert';

import 'package:even_better/forum/create_forum.dart';
import 'package:even_better/models/forum_post.dart' as fp;
import 'package:even_better/models/forum_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ForumListPage extends StatefulWidget {
  // Data db;
  ForumListPage();
  @override
  _ForumListPageState createState() => _ForumListPageState();
}

class _ForumListPageState extends State<ForumListPage> {
  List<Forum_Post> forumPosts = [];
  // static const int PAGE_SIZE = 10;
  // bool loaded = true;
  // bool _enablePullup = true;
  // bool loading = true;
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  // Timer? _timer;
  String serverurl = "https://api.even-better-api.com";
  // String serverurl = "http://10.0.2.2:3000";
  _ForumListPageState();

  @override
  void initState() {
    super.initState();
    //moved line below to init state. If it's in build, it gets called each time
    //the widget rebuilds on a setState() call
    getallForums();
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000), () {
      getallForums();
    });
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000), () {
      getallForums();
    });
    _refreshController.loadComplete();
  }

  void getallForums() async {
    List<Forum_Post> listItems = [];
    final uri = serverurl + "/forums/all";
    final response = await http.get(Uri.parse(uri), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    if (response != null && response.statusCode == HttpStatus.ok) {
      List<dynamic> reslist = jsonDecode(response.body);
      // print("reslist is: " + reslist.toString());
      for (var forum in reslist) {
        String id = forum['_id'];
        String tempPoster = forum['poster'];
        String posterID = forum['posterID'];
        String tempTitle = forum['title'];
        String tempContent = forum['content'];
        /* enable tags here*/
        Forum_Post tempFP = Forum_Post(
            id, tempPoster, posterID, tempTitle, tempContent, [], []);
        listItems.add(tempFP);
      }
      setState(() {
        forumPosts = listItems;
      });
    } else {
      print("Loading Forum DB Error!!!!!");
    }
  }

  @override
  Widget build(BuildContext context) {
    var listpage = SmartRefresher(
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
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) =>
              fp.ForumPost(forumPosts[index]),
          itemCount: forumPosts.length,
          shrinkWrap: true,
        ));
    //  Container(
    //     padding: const EdgeInsets.all(2.0),
    //     child: );

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
            // Row( // for tag area
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[],
            // ),
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
    // print('add new post');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => createForum()),
    );
  }
}

// code in init
// EasyLoading.addStatusCallback((status) {
//   print('EasyLoading Status $status');
//   if (status == EasyLoadingStatus.dismiss) {
//     _timer?.cancel();
//   }
// });
// EasyLoading.showSuccess('Forums Loaded');
// EasyLoading.removeCallbacks();

// code in build
// var topTagGroup = Container(
// alignment: Alignment.center,
// decoration: const BoxDecoration(
//   color: Colors.white,
//   borderRadius: BorderRadius.all(Radius.circular(15.0)),
// ),
// child: Container(
//     alignment: Alignment.bottomCenter,
//     margin: const EdgeInsets.symmetric(
//       horizontal: 10.0,
//       vertical: 0.0,
//     ),
//     decoration: const BoxDecoration(
//       color: CompanyColors.red,
//       borderRadius: BorderRadius.all(Radius.circular(30.0)),
//     ),
//     child: Column(
//       children: <Widget>[
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           crossAxisAlignment: CrossAxisAlignment.center,
//   children: <Widget>[tags[0], tags[1], tags[2]],
// ),
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceAround,
//   crossAxisAlignment: CrossAxisAlignment.center,
//   children: <Widget>[
//     tags[3],
//     Container(
//       child: Column(
//         children: <Widget>[
//           TextButton(
//             onPressed: () async {
//               _timer?.cancel();
//         await EasyLoading.show(
//           status: 'loading...',
//           maskType: EasyLoadingMaskType.black,
//         );
//         print('EasyLoading show');
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => showAllTags(
//                     alltags: tags,
//                   )),
//         );
//         EasyLoading.dismiss();
//       },
//       child: const Text("···",
//           style: TextStyle(color: Colors.white)),
//     ),
//   ],
// ),
//               ),
//               Container(
//                 child: Column(
//                   children: <Widget>[
//                     TextButton(
//                       onPressed: () {
//                         print("showing more tags");
//                         // sleep(Duration(seconds: 3));
//                         // setState(() => loading = false);
//                       },
//                       child: const Text("",
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

// body: forumPosts.length == 0 ? _getMoreForums():RefreshIndicator(
//   onRefresh: () {return _onRefresh();},
//   child:ListView.builder(
//     controller:_scrollController,
//     itemCount: forumPosts.length,
//     // itemBuilder: (context, index) =>{
//     //   // // Widget tip = Text("");
//     //   // // if (index == forumPosts.length - 1){
//     //   // //   tip = _getmoreForums();
//     //   // // }
//     //   // return Column(
//     //   //   children:<Widget>[
//     //   //     ListTile(
//     //   //       Title: Text("HiHi", maxLines: 1,)
//     //   //     ),])
//     // },
//   ),
// ),
