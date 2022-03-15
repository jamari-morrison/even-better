import 'package:even_better/models/post_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

//documentation: https://flutter.dev/docs/cookbook/networking/send-data
//if we need to work with responses, add stuff from here ^
String BASE_URL = 'https://api.even-better-api.com/posts/';
List<Posting> serverposts = <Posting>[];

void createPost(title, description, url, likes, time, username) {
  _createPost(title, description, url, likes, time, username);
  print("post url ${url}");
}

Future<http.Response> _createPost(
    title, description, url, likes, time, username) {
  print("Ip: create ->");
  String ip = BASE_URL + 'create';
  print(ip);

  return http.post(
    Uri.parse(ip),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      // "_id": "0000000000001",
      "title": title,
      "description": description,
      "picture-uri": url,
      "likes": likes.toString(),
      "poster": username.toString(),
      "timestamp": time
    }),
  );
}
//https://stackoverflow.com/questions/49914136/how-to-integrate-flutter-app-with-node-js
//https://medium.com/flutter/some-options-for-deserializing-json-with-flutter-7481325a4450
// https://flutter.dev/docs/cookbook/networking/send-data
//https://suragch.medium.com/how-to-make-http-requests-in-flutter-d12e98ee1cef

// Future<List<Posting>> _makeGetRequest() async {

// void makeGetRequest() {
//   GetRequest();
// }

// Future<List<Posting>> GetRequest() async {
//   print("Ip: get ->");
//   String ip = BASE_URL + 'all';
//   print(ip);

//   Response response = await http.get(
//     Uri.parse(ip),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//   );

//   var psJson = jsonDecode(response.body);
//   List? ps = psJson != null ? List.from(psJson) : null;

//   // final url = Uri.parse('$urlPrefix/posts');
//   // Response response = await get(url);
//   print('Status code: ${response.statusCode}');
//   print('Headers: ${response.headers}');
//   print('Body: ${response.body}');
//   print(">> " + ps![0]["_id"]);
//   print(">> " + ps[1]["title"]);
//   print(">> " + ps[0]["likes"].toString());
//   print(">> " + ps[1]["picture-uri"].toString());
//   for (var i = 0; i < ps.length; i++) {
//     serverposts.add(Posting(
//       // ps[i]["_id"] ?? 't0',
//       // ps[i]["title"] ?? 't1',
//       // ps[i]["description"] ?? 't2',
//       // ps[i]["picture-uri"] ?? 't3',
//       // ps[i]["likes"] ?? 0,
//       // ps[i]["poster"] ?? 't4',
//       // ps[i]["timestamp"] ?? 't5',
//       ps[i]["_id"],
//       ps[i]["title"],
//       ps[i]["description"],
//       ps[i]["picture-uri"],
//       ps[i]["likes"],
//       ps[i]["poster"],
//       ps[i]["timestamp"],
//     ));
//   }
//   // for (var i = 0; i < serverposts.length; i++) {
//   //   print(serverposts[i].likes);
//   // }
//   print('postlikes:::::::::');
//   print(serverposts[serverposts.length - 1].pid);
//   // return serverposts;
// }

class Posting {
  String pid;
  String title;
  String des;
  String imageUrl;
  int likes;
  String authorName;
  String timeAgo;

  Posting(
    this.pid,
    this.title,
    this.des,
    this.imageUrl,
    this.likes,
    this.authorName,
    this.timeAgo,
  );
}
