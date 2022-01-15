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
        // 'https://load-balancer-937536547.us-east-2.elb.amazonaws.com:443/students/checkExist'),
        // 'hstpsapi.even-better-api.com:443/students/checkExist'),
        'https://api.even-better-api.com:443/students/checkExist'),
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
    Uri.parse(
        'https://api.even-better-api.com:443/users/emailValidated/' + email),
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
    Uri.parse('https://api.even-better-api.com:443/users/sendValidationEmail/'),
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
    return AlbumSignUp(message: json['message'].toString());
  }
}

Future<AlbumSignUp> createAlbumSignUpEB(username, roseUsername, name) async {
  final response = await http.post(
    Uri.parse('https://api.even-better-api.com:443/users/signup'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'rose-username': roseUsername,
      'name': name,
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

class AlbumConfirmName {
  final message;

  AlbumConfirmName({
    required this.message,
  });

  factory AlbumConfirmName.fromJson(Map<String, dynamic> json) {
    return AlbumConfirmName(message: json['message']);
  }
}

Future<AlbumConfirmName> createAlbumConfirmName(roseUsername) async {
  //note: this get endpoint returns the entire user object. We only need to use the name

  final response = await http.post(
    Uri.parse('https://api.even-better-api.com:443/students/studentFromName'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'rose-username': roseUsername,
    }),
  );
  if (response.statusCode == 200 || response.statusCode == 201) {
    AlbumConfirmName output =
        AlbumConfirmName.fromJson(jsonDecode(response.body));
    return output;
  } else {
    print("status code: " + response.statusCode.toString());
    throw Exception('failed to create album');
  }
}
