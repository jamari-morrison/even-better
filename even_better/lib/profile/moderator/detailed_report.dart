import 'dart:async';
import 'dart:convert';

import 'package:even_better/UserVerification/Helpers/account_creation.dart';
import 'package:even_better/forum/detail_forum.dart';
import 'package:even_better/models/forum_answer.dart';
import 'package:even_better/models/forum_post.dart';
import 'package:even_better/models/tag.dart';
import 'package:even_better/profile/moderator/view_reports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;

class DetailedReport extends StatefulWidget {
  final String contentType;
  final String id;
  final String contentId;
  const DetailedReport(
      {required this.contentType,
      required this.id,
      Key? key,
      required this.contentId})
      : super(key: key);

  @override
  State<DetailedReport> createState() => _DetailedReportState();
}

class _DetailedReportState extends State<DetailedReport> {
  Timer? _timer;
  Widget page = Text("loading");

  @override
  void initState() {
    super.initState();
    obtainContent();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    EasyLoading.showSuccess('Reports Loaded');
  }

  void obtainContent() async {
    print("content type is : " + widget.contentType);
    print("id is: " + widget.contentId);
    print(
        "call is : + https://api.even-better-api.com/${widget.contentType}/getById/${widget.contentId}");
    final uri = Uri.parse(
        'https://api.even-better-api.com/${widget.contentType}/getById/${widget.contentId}');
    final response = await http.get(uri, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    final message = jsonDecode(response.body)['message'];
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("message is: " + message.toString());
      switch (widget.contentType) {
        case "forums":
          String poster = message['poster'];
          String title = message['title'];
          String content = message['content'];
          String posterid = message['posterID'];
          int likes = message['likes'];
          var tags = message[
              'tags']; //some weird type error going on here so don't pass to Forum_Post
          setState(() {
            page = DetailedForum(
                postId: widget.contentId,
                post: Forum_Post(
                    widget.contentId, poster, posterid, title, content, [], []),
                key: widget.key,
                comments: []);
          });
          break;
        case "comments": // Wasn't sure if we are supposed to let the moderator only see the comment...
          // I think they should look at the forum first to figure out whether the comment is
          // unfriendly or sth. but the problem will be that, if a post has a lot of comments
          // the moderator might need to look for the comment themselves, and we might not want
          // that? they might lose track of the comment.... One thing I thought about is that
          // maybe we can flag a comment if they are reported, and we might change the color of
          // the comment to show that the comment is the one that being reported. But we might not
          // want normal users to notice that? Not sure what I should do...
          String commentername = message['commentername'];
          String commenter = message['commenter'];
          String content = message['content'];
          String timestamp = message['timestamp'];
          int likes = message['likes'];
          setState(() {
            //TODO: need to obtain comments and tags at some point here
            page = Scaffold(
              appBar: AppBar(
                title: const Text("Moderator Control",
                    style: TextStyle(
                      fontFamily: 'Billabong',
                      fontSize: 35.0,
                    )),
              ),
              body: Container(
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 50, bottom: 100),
                child: ForumAnswer(Forum_Answer(widget.contentId, commenter,
                    content, timestamp, commentername)),
              ),
            );
          });

          break;
        default:
      }
    } else {
      setState(() {
        //TODO: need to obtain comments at some point here
        modalErrorHandler("page not found", context, "Page deleted probably");
        page = Text('page not found');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return page == null ? Text("whoops. content not found.") : page;
  }
}
