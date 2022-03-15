// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';

//documentation: https://flutter.dev/docs/cookbook/networking/send-data
//if we need to work with responses, add stuff from here ^
//https://stackoverflow.com/questions/49914136/how-to-integrate-flutter-app-with-node-js
//https://medium.com/flutter/some-options-for-deserializing-json-with-flutter-7481325a4450

const String serverURL =
    // "http://ec2-18-217-202-114.us-east-2.compute.amazonaws.com:3000";
    "https://api.even-better-api.com";

// FORUM
// ----------------------------------------------------------------
// create post
@override
void createForum(title, poster, content, time, comments, tags) {
  _createForum(title, poster, content, time, comments, tags);
  // print("creating forum [connect]");
}

@override
Future<http.Response> _createForum(
    title, poster, content, time, comments, tags) {
  return http.post(
    // Uri.parse(serverURL + "/forums/create"),
    Uri.parse(serverURL + "/forums/create"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "title": title,
      "poster": poster,
      "content": content,
      "timestamp": time,
      "comments": comments,
      "tags": tags,
    }),
  );
}

// ------------------------------
// Delete forum
@override
void deleteForum(forumID) {
  _deleteForum(forumID);
  // print("deleting forum [connect]");
}

@override
Future<http.Response> _deleteForum(forumID) {
  return http.get(
    Uri.parse(serverURL + "/forums/deleteByKey/" + forumID),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
}

// ------------------------------
// update forum
@override
void updateForumDB(forumid, title, content, time) {
  _updateForum(forumid, title, content, time);
  // print("updating forum [connect]");
}

@override
Future<http.Response> _updateForum(forumid, title, content, time) async {
  final response = await http.post(
    Uri.parse(serverURL + "/forums/update"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "id": forumid,
      "title": title,
      "content": content,
      "timestamp": time,
    }),
  );
  return response;
}

// FORUM COMMENTS
// ----------------------------------------------------------------
// create comments
@override
void createComment(forumid, content, commenter, time) {
  var temp = _createComment(forumid, content, commenter, time);
  // print("creating comments [connect]");
}

@override
Future<http.Response> _createComment(forumid, content, commenter, time) {
  return http.post(
    Uri.parse(serverURL + "/comments/create"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "parent-id": forumid,
      "content": content,
      "commenter": commenter,
      "timestamp": time,
    }),
  );
}

//----------------------------------------------------------------
// get comments for the forum
void getcurrentComments(forumid) {
  print(currentComments(forumid));
  print("getting comments [connect]");
}

Future<http.Response> currentComments(forumid) {
  return http.get(
    Uri.parse("https://api.even-better-api.com/forums/get/" + forumid),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
}

// ----------------------------------------------------------------
// create tag
// void createTag(title, poster, content, time, tags) {
//   _createTag(title, poster, content, time, tags);
//   // print("creating forum [connect]");
// }

// Future<http.Response> _createTag(title, poster, content, time, tags) {
//   return http.post(
//     Uri.parse(serverURL + "/forums/create"),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{
//       "title": title,
//       "poster": poster,
//       "content": content,
//       "timestamp": time,
//       "tags": tags,
//     }),
//   );
// }
