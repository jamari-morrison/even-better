import 'dart:convert';

import 'package:even_better/UserVerification/Helpers/account_creation.dart';
import 'package:http/http.dart' as http;

class MyUser {
  final String fbuid;
  final String? userEmail;
  static late bool isModerator;
  static late String roseUsername;
  static late String ebuid;
  static late String displayName;

  MyUser(this.fbuid, this.userEmail) {
    print('User obj with uid: ${this.fbuid} [MyUser]');
    print('User obj with user email: ${this.userEmail} [MyUser]');
    getUserData().then((val) {
      var userData = val.userData;
      roseUsername = userData["rose-username"];
      isModerator = userData["moderator"];
      ebuid = userData["_id"];
      displayName = userData["name"];
      print("obtained user data!");
    }).catchError((err) {
      print("failed to get user data :(");
    });
    //obtain other user data
  }

  static getRoseUsername() {
    return roseUsername;
  }

  static getIsModerator() {
    return isModerator;
  }

  static getDisplayName() {
    return displayName;
  }

  static getEBUid() {
    return ebuid;
  }

  Future getUserData() async {
    final uri = Uri.parse(
        'https://api.even-better-api.com/users/getUser/' + userEmail!);
    final response = await http.get(uri, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    var result = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      UserData output = UserData.fromJson(jsonDecode(response.body));
      return output;
    } else {
      print("whoops, no user data??");
    }
  }
}

class UserData {
  final userData;

  UserData({
    required this.userData,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(userData: json['user']);
  }
}
