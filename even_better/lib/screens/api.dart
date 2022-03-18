import 'package:even_better/models/post_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

//documentation: https://flutter.dev/docs/cookbook/networking/send-data
//if we need to work with responses, add stuff from here ^
// String BASE_URL = 'https://api.even-better-api.com/posts/';
String BASE_URL = 'http://10.0.2.2:3000/posts/';
// List<Posting> serverposts = <Posting>[];

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

// void GetRequest(String username) async {
//   print("Ip: get -> Post");
//   String ip = BASE_URL + 'getUserPost/' + username;
//   print(ip);

//   Response response = await http.get(
//     Uri.parse(ip),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//   );
//  if (response.statusCode == 200 || response.statusCode == 201) {
//       var jsonMembers = json.decode(response.body);
//       print(response.body);
//       print(jsonMembers);
//       if (jsonMembers != null) {
//         setState(() {
//           serverposts = (jsonMembers as List).map((e) => e as String).toList();
//         });
//         // if (friends != null) {
//         //   print("ffffffffffffffffff" + friends!.length.toString());
//         // }
//       }
//     } else {
//       print("status code: " + response.statusCode.toString());
//       throw Exception('failed to get all user info');
//     }
//   // var psJson = jsonDecode(response.body);
//   // List? ps = psJson != null ? List.from(psJson) : null;

//   // // final url = Uri.parse('$urlPrefix/posts');
//   // // Response response = await get(url);
//   // print('Status code: ${response.statusCode}');
//   // print('Headers: ${response.headers}');
//   // print('Body: ${response.body}');
//   // print(">> " + ps![0]["_id"]);
//   // print(">> " + ps[1]["title"]);
//   // print(">> " + ps[0]["likes"].toString());
//   // print(">> " + ps[1]["picture-uri"].toString());
//   // for (var i = 0; i < ps.length; i++) {
//   //   serverposts.add(Posting(
//   //     // ps[i]["_id"] ?? 't0',
//   //     // ps[i]["title"] ?? 't1',
//   //     // ps[i]["description"] ?? 't2',
//   //     // ps[i]["picture-uri"] ?? 't3',
//   //     // ps[i]["likes"] ?? 0,
//   //     // ps[i]["poster"] ?? 't4',
//   //     // ps[i]["timestamp"] ?? 't5',
//   //     ps[i]["_id"],
//   //     ps[i]["title"],
//   //     ps[i]["description"],
//   //     ps[i]["picture-uri"],
//   //     ps[i]["likes"],
//   //     ps[i]["poster"],
//   //     ps[i]["timestamp"],
//   //   ));
//   // }
//   // // for (var i = 0; i < serverposts.length; i++) {
//   // //   print(serverposts[i].likes);
//   // // }
//   // print('postlikes:::::::::');
//   // print(serverposts[serverposts.length - 1].pid);
//   // // return serverposts;
// }

class Posting {
  final String title, des, imageUrl, poster, timestamp;
  final int likes;
  // final followers, following;
  // User(this.roseusername, this.username);
  Posting({
    required this.title,
    required this.des,
    required this.imageUrl,
    required this.likes,
    required this.poster,
    required this.timestamp,
  });

  factory Posting.fromJson(Map<String, dynamic> json) => Posting(
        title: json['title'] as String,
        des: json['description'] as String,
        imageUrl: json['picture-uri'] as String,
        likes: json['likes'] as int,
        poster: json['poster'] as String,
        timestamp: json['timestamp'] as String,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "desctiption": des,
        "picture-uri": imageUrl,
        "likes": likes,
        "poster": poster,
        "timestamp": timestamp,
      };
}
