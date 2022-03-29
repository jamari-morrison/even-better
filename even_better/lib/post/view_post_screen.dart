import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:even_better/post/homescreen_post_comment_api.dart';
import 'package:even_better/post/post_comment_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:even_better/forum/connect.dart' as connect;
import 'package:even_better/models/comment_model.dart';
import 'package:even_better/models/post_model.dart';
import 'package:even_better/screens/api.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'feed_screen.dart';

class ViewPostScreen extends StatefulWidget {
  final SinglePost post;
  ViewPostScreen({required this.post});

  @override
  _ViewPostScreenState createState() => _ViewPostScreenState();
}

class _ViewPostScreenState extends State<ViewPostScreen> {
  Timer? _timer;
  TextEditingController commentController = TextEditingController();
  String _username = "";
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  List<ViewPostComment> mycomments = <ViewPostComment>[];
  String? email;
  String? name;
  @override
  void initState() {
    super.initState();
    initialName();
    getComments();
  }

  initialName() async {
    User? user = FirebaseAuth.instance.currentUser;
    email = user?.email;
    if (email != null) {
      _username = email!;
    }
  }

  void _onRefresh() async {
    // print("trying to refresh");
    await Future.delayed(Duration(milliseconds: 1000), () {
      getComments();
    });
    _refreshController.refreshCompleted();
  }

  void getComments() async {
    List<Comment> listItems = [];
    String serverurl = "http://10.0.2.2:3000/comments";
    String temp = serverurl + "/getpostcomment/" + widget.post.pid;
    print(temp);
    final response = await http.get(
      Uri.parse(temp),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response != null && response.statusCode == HttpStatus.ok) {
      var jsonMembers = json.decode(response.body);
      print(jsonMembers);
      setState(() {
        // posts =
        //     jsonMembers.map<Posting>((json) => Posting.fromJson(json)).toList();
        mycomments = jsonMembers
            .map<ViewPostComment>((json) => ViewPostComment.fromJson(json))
            .toList();
      });
    } else if (response.statusCode == HttpStatus.noContent) {
      print("No content");
    } else {
      print("Loading Comments DB Error!!!!!");
    }
  }

  List<Widget> getList() {
    List<Widget> childs = [];
    if (mycomments.isNotEmpty) {
      for (var i = 0; i < mycomments.length; i++) {
        childs.add(_buildComment(i));
      }
    } else {
      childs.add(
        const SizedBox(
          height: 0.0,
        ),
      );
    }
    return childs;
  }

  Widget _buildComment(int i) {
    ViewPostComment temp = mycomments[i];
    var ifdelete = false;
    if (temp.commentername == _username) {
      ifdelete = true;
    }
    ;
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: ListTile(
        leading: Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 2),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: CircleAvatar(
            child: ClipOval(
              child: Image(
                height: 50.0,
                width: 50.0,
                image: AssetImage(posts[0].authorImageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Text(
          temp.commentername,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(temp.content),
        trailing: ifdelete
            ? IconButton(
                icon: Icon(
                  Icons.delete_outlined,
                ),
                color: Colors.grey,
                onPressed: () {
                  connect.deleteComment(temp.id);
                  _onRefresh();
                })
            : null,
        //     LikeButton(
        //   size: 30,
        //   circleColor: const CircleColor(
        //       start: Color(0xff00ddff), end: Color(0xff0099cc)),
        //   bubblesColor: const BubblesColor(
        //     dotPrimaryColor: Color(0xff33b5e5),
        //     dotSecondaryColor: Color(0xff0099cc),
        //   ),
        //   likeBuilder: (bool isLiked) {
        //     return Icon(
        //       Icons.favorite,
        //       color: isLiked ? Colors.pinkAccent : Colors.grey,
        //       size: 30,
        //     );
        //   },
        //   likeCount: widget.post.likes,
        //   // onTap: onLikeButtonTapped,
        //   onTap: (isLiked) {
        //     return changedata(isLiked, widget.post.likes, widget.post.pid);
        //   },
        // ),
      ),
    );
  }

  Future<bool> changedata(bool status, int likes, String id) async {
    //your code
    if (status) {
      createLikeUpdate(likes + 1, id);
    } else {
      createLikeUpdate(likes, id);
    }
    return Future.value(!status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDF0F6),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 40.0),
              width: double.infinity,
              height: 600.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              iconSize: 30.0,
                              color: Colors.black,
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: ListTile(
                                leading: Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black45,
                                        offset: Offset(0, 2),
                                        blurRadius: 6.0,
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    child: ClipOval(
                                      child: Image(
                                        height: 50.0,
                                        width: 50.0,
                                        //TODO:
                                        image:
                                            AssetImage(posts[0].authorImageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  widget.post.posting.poster,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(widget.post.posting.timestamp),
                                // trailing: IconButton(
                                //   icon: Icon(Icons.more_horiz),
                                //   color: Colors.black,
                                //   onPressed: () => print('More'),
                                // ),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onDoubleTap: () => print('Like post'),
                          child: Container(
                            margin: EdgeInsets.all(10.0),
                            width: double.infinity,
                            height: 400.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black45,
                                  offset: Offset(0, 5),
                                  blurRadius: 8.0,
                                ),
                              ],
                              image: DecorationImage(
                                image:
                                    getPostImage(widget.post.posting.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      // IconButton(
                                      //   icon: Icon(Icons.favorite_border),
                                      //   iconSize: 30.0,
                                      //   onPressed: () => print('Like post'),
                                      // ),
                                      // Text(
                                      //   '2,515',
                                      //   style: TextStyle(
                                      //     fontSize: 14.0,
                                      //     fontWeight: FontWeight.w600,
                                      //   ),
                                      // ),
                                      LikeButton(
                                        size: 30,
                                        circleColor: const CircleColor(
                                            start: Color(0xff00ddff),
                                            end: Color(0xff0099cc)),
                                        bubblesColor: const BubblesColor(
                                          dotPrimaryColor: Color(0xff33b5e5),
                                          dotSecondaryColor: Color(0xff0099cc),
                                        ),
                                        likeBuilder: (bool isLiked) {
                                          return Icon(
                                            Icons.favorite,
                                            color: isLiked
                                                ? Colors.pinkAccent
                                                : Colors.grey,
                                            size: 30,
                                          );
                                        },
                                        likeCount: widget.post.likes,
                                        // onTap: onLikeButtonTapped,
                                        onTap: (isLiked) {
                                          return changedata(
                                              isLiked,
                                              widget.post.likes,
                                              widget.post.pid);
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 20.0),
                                  Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.chat),
                                        iconSize: 30.0,
                                        onPressed: () {
                                          print('Chat');
                                        },
                                      ),
                                      Text(
                                        mycomments.length.toString(),
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // IconButton(
                              //   icon: Icon(Icons.bookmark_border),
                              //   iconSize: 30.0,
                              //   onPressed: () => print('Save post'),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              width: double.infinity,
              // height: 600.0,
              // height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Column(children: getList()
                  // ],
                  ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: 100.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, -2),
                blurRadius: 6.0,
              ),
            ],
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: TextField(
              controller: commentController,
              minLines: null,
              maxLines:
                  null, // If this is null, there is no limit to the number of lines, and the text container will start with enough vertical space for one line and automatically grow to accommodate additional lines as they are entered.
              expands: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding: EdgeInsets.all(20.0),
                hintText: 'Add a comment',
                prefixIcon: Container(
                  margin: EdgeInsets.all(4.0),
                  width: 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    child: ClipOval(
                      child: Image(
                        height: 48.0,
                        width: 48.0,
                        //TODO:
                        image: AssetImage(posts[0].authorImageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                suffixIcon: Container(
                  margin: EdgeInsets.only(right: 4.0),
                  width: 70.0,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: Color(0xFF23B66F),
                    onPressed: () async {
                      print(widget.post.pid);
                      print(commentController.text);
                      print(_username);
                      DateTime now = DateTime.now();
                      String now_string =
                          DateFormat('yyyy-MM-dd kk:mm').format(now);
                      print(now_string);
                      createComment(widget.post.pid, commentController.text,
                          _username, now_string);
                      connect.createComment(
                          widget.post.pid,
                          commentController.text,
                          "xxxx",
                          now_string,
                          _username);
                      _onRefresh();
                      commentController.clear();
                    },
                    child: Icon(
                      Icons.send,
                      size: 25.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

FileImage getPostImage(String s) {
  return FileImage(File(s));
}
