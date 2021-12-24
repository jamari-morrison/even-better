import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//documentation: https://flutter.dev/docs/cookbook/networking/send-data
//if we need to work with responses, add stuff from here ^

class AlbumBool {
  final bool message;

  AlbumBool({
    required this.message,
  });

  factory AlbumBool.fromJson(Map<String, dynamic> json) {
    return AlbumBool(
      message: json['message'],
    );
  }
}

//make this private but still usable in test case??
Future<AlbumBool> createAlbumValidateRose(roseUsername) async {
  final response = await http.post(
    Uri.parse(
        'http://ec2-3-137-199-220.us-east-2.compute.amazonaws.com:3000/students/checkExist'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'rose-username': roseUsername}),
  );
  if (response.statusCode == 200 || response.statusCode == 201) {
    AlbumBool output = AlbumBool.fromJson(jsonDecode(response.body));
    return output;
  } else {
    print("status code: " + response.statusCode.toString());
    throw Exception('failed to create album');
  }
}

//TODO: implement me!!
Future<AlbumBool> createAlbumIsEmailValidated(email) async {
  final response = await http.get(
    //query parameters!
    Uri.parse('http://192.168.1.140:3000/users/emailValidated/' + email),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200 || response.statusCode == 201) {
    AlbumBool output = AlbumBool.fromJson(jsonDecode(response.body));
    return output;
  } else {
    print("status code: " + response.statusCode.toString());
    throw Exception('failed to create album');
  }
}

Future<AlbumSendEmail> createAlbumSendEmail(email) async {
  print("sending email to " + email + "...");
  final response = await http.post(
    Uri.parse('http://192.168.1.140:3000/users/sendValidationEmail/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'rose-username': email}),
  );
  if (response.statusCode == 200 || response.statusCode == 201) {
    AlbumSendEmail output = AlbumSendEmail.fromJson(jsonDecode(response.body));
    return output;
  } else {
    print("status code: " + response.statusCode.toString());
    throw Exception('failed to create album');
  }
}

class AlbumSendEmail {
  final String message;

  AlbumSendEmail({
    required this.message,
  });

  factory AlbumSendEmail.fromJson(Map<String, dynamic> json) {
    return AlbumSendEmail(
        //for whatever reason dynamic makes this parse directly to a boolean :(
        message: json['message'].toString());
  }
}

class AlbumSignUp {
  final String message;

  AlbumSignUp({
    required this.message,
  });

  factory AlbumSignUp.fromJson(Map<String, dynamic> json) {
    return AlbumSignUp(
        //for whatever reason dynamic makes this parse directly to a boolean :(
        message: json['username'].toString());
  }
}

Future<AlbumSignUp> createAlbumSignUpEB(username, roseUsername) async {
  final response = await http.post(
    Uri.parse(
        'http://ec2-3-137-199-220.us-east-2.compute.amazonaws.com:3000/users/signup'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'rose-username': roseUsername,
    }),
  );
  //NEED TO HANDLE THIS ALBUM BETTER
  if (response.statusCode == 200 || response.statusCode == 201) {
    AlbumSignUp output = AlbumSignUp.fromJson(jsonDecode(response.body));
    return output;
  } else {
    print("status code: " + response.statusCode.toString());
    throw Exception('failed to create album');
  }
}