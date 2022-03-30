import 'package:even_better/models/post_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

String BASE_URL = 'https://api.even-better-api.com/';
// String BASE_URL = 'http://10.0.2.2:3000/';

void createComment(postid, content, commenter, time) {
  _createComment(postid, content, commenter, time);
  //
}

@override
Future<http.Response> _createComment(postid, content, commenter, time) {
  return http.post(
    Uri.parse(BASE_URL + "postcomments/create"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "parent-id": postid,
      "content": content,
      "commenter": commenter,
      "timestamp": time,
    }),
  );
}

void getcurrentComments(postid) {}

Future<http.Response> currentComments(postid) {
  return http.get(
    Uri.parse(BASE_URL + "postcomments/get/" + postid),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
}

void deleteComment(commentID) {
  _deleteComment(commentID);
  //
}

@override
Future<http.Response> _deleteComment(commentID) {
  return http.get(
    Uri.parse(BASE_URL + "postcomments/deleteByKey/" + commentID),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
}
