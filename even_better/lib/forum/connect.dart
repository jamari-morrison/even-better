import 'package:http/http.dart' as http;
import 'dart:convert';

//documentation: https://flutter.dev/docs/cookbook/networking/send-data
//if we need to work with responses, add stuff from here ^
//https://stackoverflow.com/questions/49914136/how-to-integrate-flutter-app-with-node-js
//https://medium.com/flutter/some-options-for-deserializing-json-with-flutter-7481325a4450

const String serverURL = "https://api.even-better-api.com:443";

// ----------------------------------------------------------------
// create post
void createForum(title, poster, content, time, tags) {
  _createForum(title, poster, content, time, tags);
  print("creating forum [connect]");
}

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
