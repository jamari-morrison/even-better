import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//documentation: https://flutter.dev/docs/cookbook/networking/send-data
//if we need to work with responses, add stuff from here ^

class Album {
  final String message;

  Album({
    required this.message,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    print(json['message']);
    return Album(
      //for whatever reason dynamic makes this parse directly to a boolean :(
      message: json['message'],
    );
  }
}

//make this private but still usable in test case??
Future<Album> createAlbumDeleteAccount(ebUsername) async {
  final response = await http.post(
    Uri.parse('https://api.even-better-api.com:443/users/delete'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'username': ebUsername}),
  );
  if (response.statusCode == 200 || response.statusCode == 201) {
    Album output = Album.fromJson(jsonDecode(response.body));
    return output;
  } else {
    print("status code: " + response.statusCode.toString());
    throw Exception('bad response');
  }
}

class AlbumUpdate {
  final String fname;

  AlbumUpdate({
    required this.fname,
  });

  factory AlbumUpdate.fromJson(Map<String, dynamic> json) {
    return AlbumUpdate(fname: json['fname'].toString());
  }
}
