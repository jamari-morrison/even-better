// ignore_for_file: avoid_print

import 'package:even_better/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//documentation: https://flutter.dev/docs/cookbook/networking/send-data
//if we need to work with responses, add stuff from here ^
//https://stackoverflow.com/questions/49914136/how-to-integrate-flutter-app-with-node-js
//https://medium.com/flutter/some-options-for-deserializing-json-with-flutter-7481325a4450

const String serverURL =
    // "http://ec2-18-217-202-114.us-east-2.compute.amazonaws.com:3000/";
    "https://api.even-better-api.com/";
// "http://10.0.2.2:3000/";
// USER
Future getUserData(ebuid) async {
  final uri = Uri.parse(serverURL + "users/getUser/" + ebuid);
  final response = await http.get(uri, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });

  var result = jsonDecode(response.body);
  if (response.statusCode == 200 || response.statusCode == 201) {
    UserData output = UserData.fromJson(jsonDecode(response.body));
    return output;
  } else {
    //
  }
}

// FORUM
// ----------------------------------------------------------------
// create post
@override
void createForum(title, poster, posterID, content, time, comments, tags) {
  _createForum(title, poster, posterID, content, time, comments, tags);
  //
}

@override
Future<http.Response> _createForum(
    title, poster, posterID, content, time, comments, tags) {
  return http.post(
    // Uri.parse(serverURL + "forums/create"),
    Uri.parse(serverURL + "forums/create"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "title": title,
      "poster": poster,
      "posterID": posterID,
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
  //
}

@override
Future<http.Response> _deleteForum(forumID) {
  //
  return http.get(
    Uri.parse(serverURL + "forums/deleteByKey/" + forumID),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
}

// Delete comment
@override
void deleteComment(commentID) {
  _deleteComment(commentID);
  //
}

@override
Future<http.Response> _deleteComment(commentID) {
  return http.get(
    Uri.parse(serverURL + "comments/deleteByKey/" + commentID),
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
  //
}

@override
Future<http.Response> _updateForum(forumid, title, content, time) async {
  final response = await http.post(
    Uri.parse(serverURL + "forums/update"),
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
void createComment(forumid, content, commenterid, time, commentername) {
  _createComment(forumid, content, commenterid, time, commentername);
  //
}

@override
Future<http.Response> _createComment(
    forumid, content, commenterid, time, commentername) {
  return http.post(
    Uri.parse(serverURL + "comments/create"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "parent-id": forumid,
      "content": content,
      "commenter": commenterid,
      "commentername": commentername,
      "timestamp": time,
    }),
  );
}

//----------------------------------------------------------------
// get comments for the forum
void getcurrentComments(forumid) {
  //
  //
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
//   //
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
