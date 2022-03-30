import 'package:even_better/models/allusers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';

Future<UserI> getUserInfo() async {
  final user = FirebaseAuth.instance.currentUser;
  String? email = user!.email;
  if (email != null) {}
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

    //
    return u.useri;
  } else {
    throw Exception('failed to load user');
  }
}

void createStringUpdate(name, companyname, bio) async {
  if (name == null) {}
  final user = FirebaseAuth.instance.currentUser;
  String? email = user!.email;
  if (email != null) {
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
  }
  ;
}

void createBooleanUpdate(bool cs, bool se, bool ds) async {
  final user = FirebaseAuth.instance.currentUser;
  String? email = user!.email;
  if (email != null) {
    //
    //
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
  }
  ;
}

void createAvatarUpdate(ava) async {
  final user = FirebaseAuth.instance.currentUser;
  String? email = user!.email;
  if (email != null) {
    final response = await http.post(
      Uri.parse('https://api.even-better-api.com/users/updateava/' + email),
      // Uri.parse('http://10.0.2.2:3000/users/updateava/' + email),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"avatar": ava}),
    );
  }
  ;
}

// Upload(File imageFile) async {
//     var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
//       var length = await imageFile.length();

//       var uri = Uri.parse(uploadURL);

//      var request = new http.MultipartRequest("POST", uri);
//       var multipartFile = new http.MultipartFile('file', stream, length,
//           filename: basename(imageFile.path));
//           //contentType: new MediaType('image', 'png'));

//       request.files.add(multipartFile);
//       var response = await request.send();
//
//       response.stream.transform(utf8.decoder).listen((value) {
//
//       });
//     }
