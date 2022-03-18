import 'dart:async';
import 'dart:convert';

import 'package:even_better/UserVerification/Helpers/account_creation.dart';
import 'package:even_better/forum/detail_forum.dart';
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
          int likes = message['likes'];
          var tags = message[
              'tags']; //some weird type error going on here so don't pass to Forum_Post
          setState(() {
            //TODO: need to obtain comments and tags at some point here
            page = DetailedForum(
                postId: widget.id,
                post: Forum_Post(widget.id, poster, title, content, [], []),
                key: widget.key,
                comments: []);
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
    return page == null ? Text("loading") : page;
  }
}
