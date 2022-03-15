import 'package:even_better/models/allusers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<UserI> getUserInfo() async {
  final user = FirebaseAuth.instance.currentUser;
  String? email = user!.email;
  if (email != null) {
    print("email: " + email);
  }
  final response = await http.get(
    Uri.parse('https://api.even-better-api.com/users/getUser/' + email!),
    // Uri.parse('http://10.0.2.2:3000/users/users/getUser/' + email!),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200 || response.statusCode == 201) {
    var user = json.decode(response.body);
    wholeUser u = wholeUser.fromJson(user);
    print(u.useri.avatar);
    // print(user.toString());
    return u.useri;
  } else {
    print("status code: " + response.statusCode.toString());
    throw Exception('failed to load user');
  }
}

void createStringUpdate(name, companyname, bio) async {
  print("update: " + name);
  if (name == null) {
    print("you can't leave it blank");
  }
  final user = FirebaseAuth.instance.currentUser;
  String? email = user!.email;
  if (email != null) {
    print("email: " + email);
    final response = await http.post(
      Uri.parse('https://api.even-better-api.com/users/updatestring/' + email),
      // Uri.parse('http://10.0.2.2:3000/users/updatestring/' + email),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'companyname': companyname,
        'bio': bio,
      }),
    );
    print(response.statusCode.toString());
  }
  ;
}

void createBooleanUpdate(bool cs, bool se, bool ds) async {
  final user = FirebaseAuth.instance.currentUser;
  String? email = user!.email;
  if (email != null) {
    // print("emailbool: " + email);
    // print("bool: " + cs.toString() + se.toString() + ds.toString());
    final response = await http.post(
      Uri.parse('https://api.even-better-api.com/users/updatebool/' + email),
      // Uri.parse('http://10.0.2.2:3000/users/updatebool/' + email),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'cs': cs,
        'ds': ds,
        'se': se,
      }),
    );
    print(response.statusCode.toString());
  }
  ;
}

void createAvatarUpdate(ava) async {
  final user = FirebaseAuth.instance.currentUser;
  String? email = user!.email;
  if (email != null) {
    print("email: " + email);
    print("ava: " + ava);
    final response = await http.post(
      Uri.parse('https://api.even-better-api.com/users/updateava/' + email),
      // Uri.parse('http://10.0.2.2:3000/users/updateava/' + email),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"avatar": ava}),
    );
    print(response.statusCode.toString());
  }
  ;
}
