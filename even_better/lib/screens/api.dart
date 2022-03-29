import 'package:even_better/models/post_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

//documentation: https://flutter.dev/docs/cookbook/networking/send-data
//if we need to work with responses, add stuff from here ^
// String BASE_URL = 'https://api.even-better-api.com/posts/';
String BASE_URL = 'http://10.0.2.2:3000/posts/';
// List<Posting> serverposts = <Posting>[];

void createPost(title, description, url, likes, time, username) {
  _createPost(title, description, url, likes, time, username);
}

Future<http.Response> _createPost(
    title, description, url, likes, time, username) {
  String ip = BASE_URL + 'create';

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

void deletePost(pID) {
  _deletePost(pID);
}

Future<http.Response> _deletePost(pID) {
  String ip = BASE_URL + 'deleteByKey/' + pID;

  return http.post(
    Uri.parse(ip),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
}

void createPostUpdate(title, des, id) async {
  String ip = BASE_URL + 'update/' + id;

  final response = await http.post(
    Uri.parse(ip),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
      'description': des,
    }),
  );
}

void createLikeUpdate(likes, id) async {
  String ip = BASE_URL + 'updatelike/' + id;

  final response = await http.post(
    Uri.parse(ip),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'likes': likes,
    }),
  );
}

class Posting {
  String title, des, imageUrl, poster, timestamp;
  int likes;
  var id;
  // final followers, following;
  // User(this.roseusername, this.username);
  Posting({
    required this.title,
    required this.des,
    required this.imageUrl,
    required this.likes,
    required this.poster,
    required this.timestamp,
    this.id,
  });

  factory Posting.fromJson(Map<String, dynamic> json) => Posting(
        title: json['title'] as String,
        des: json['description'] as String,
        imageUrl: json['picture-uri'] as String,
        likes: json['likes'] as int,
        poster: json['poster'] as String,
        timestamp: json['timestamp'] as String,
        id: json['_id'],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "desctiption": des,
        "picture-uri": imageUrl,
        "likes": likes,
        "poster": poster,
        "timestamp": timestamp,
        "_id": id,
      };
}
