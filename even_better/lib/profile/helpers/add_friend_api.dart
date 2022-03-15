import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void createAddFriend(friend) async {
  final user = FirebaseAuth.instance.currentUser;
  String? email = user!.email;
  if (email != null) {
    print("email: " + email);
    print("friend's username: " + friend);
    final response = await http.post(
      Uri.parse('https://api.even-better-api.com/users/addfriend/' +
          email), //http://10.0.2.2:3000/users/update
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"friend": friend}),
    );
    print(response.statusCode.toString());
  }
  ;
}
