// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';

//documentation: https://flutter.dev/docs/cookbook/networking/send-data
//if we need to work with responses, add stuff from here ^
//https://stackoverflow.com/questions/49914136/how-to-integrate-flutter-app-with-node-js
//https://medium.com/flutter/some-options-for-deserializing-json-with-flutter-7481325a4450

const String serverURL =
    "http://ec2-18-217-202-114.us-east-2.compute.amazonaws.com:3000";

// ----------------------------------------------------------------
// create post
@override
void createForum(title, poster, content, time, tags) {
  _createForum(title, poster, content, time, tags);
  print("creating forum [connect]");
}

@override
Future<http.Response> _createForum(title, poster, content, time, tags) {
  return http.post(
    Uri.parse(serverURL + "/forums/create"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "title": title,
      "poster": poster,
      "content": content,
      "timestamp": time,
      "tags": tags,
    }),
  );
}

//----------------------------------------------------------------
// get all forums
void allForum() {
  _allForum();
  print("getting all forum [connect]");
}

Future<http.Response> _allForum() {
  return http.get(
    Uri.parse(serverURL + "/forums/all"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
}

// ------------------------------
// Delete forum
@override
void deleteForum(forumID) {
  print(forumID);
  _deleteForum(forumID);
  print("deleting forum [connect]");
}

@override
Future<http.Response> _deleteForum(forumID) {
  print(serverURL + "/forums/deleteByKey/" + forumID);
  return http.get(
    Uri.parse(serverURL + "/forums/deleteByKey/" + forumID),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    // body: jsonEncode(<String, String>{}),
  );
}

// ------------------------------
// update forum
@override
void updateForumDB(forumid, title, content, time) {
  print(forumid);
  print(title);
  print(content);
  _updateForum(forumid, title, content, time);
  print("updating forum [connect]");
}

@override
Future<http.Response> _updateForum(forumid, title, content, time) async {
  final response = await http.post(
    Uri.parse('https://api.even-better-api.com/forums/update'),
    // Uri.parse('http://10.0.2.2:3000/forums/update'),
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

// ----------------------------------------------------------------
// create tag
void createTag(title, poster, content, time, tags) {
  _createTag(title, poster, content, time, tags);
  print("creating forum [connect]");
}

Future<http.Response> _createTag(title, poster, content, time, tags) {
  return http.post(
    Uri.parse(serverURL + "/forums/create"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "title": title,
      "poster": poster,
      "content": content,
      "timestamp": time,
      "tags": tags,
    }),
  );
}
