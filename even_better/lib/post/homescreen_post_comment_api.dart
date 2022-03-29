import 'package:even_better/models/post_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

//documentation: https://flutter.dev/docs/cookbook/networking/send-data
//if we need to work with responses, add stuff from here ^
// String BASE_URL = 'https://api.even-better-api.com/posts/';
String BASE_URL = 'http://10.0.2.2:3000/comments/';
// List<Posting> serverposts = <Posting>[];

class ViewPostComment {
  String commentername, commenter, content, timestamp, parent_id;
  int likes;
  var id;
  // final followers, following;
  // User(this.roseusername, this.username);
  ViewPostComment({
    required this.commentername,
    required this.commenter,
    required this.content,
    required this.timestamp,
    required this.parent_id,
    required this.likes,
    this.id,
  });

  factory ViewPostComment.fromJson(Map<String, dynamic> json) =>
      ViewPostComment(
        commentername: json['commentername'] as String,
        commenter: json['commenter'] as String,
        content: json['content'] as String,
        likes: json['likes'] as int,
        timestamp: json['timestamp'] as String,
        id: json['_id'],
        parent_id: json['parent-id'] as String,
      );
}
