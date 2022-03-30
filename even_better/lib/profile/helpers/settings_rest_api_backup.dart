// import 'package:http/http.dart' as http;
// import 'dart:convert';

// //documentation: https://flutter.dev/docs/cookbook/networking/send-data
// //if we need to work with responses, add stuff from here ^

// class Album {
//   final String message;

//   Album({
//     required this.message,
//   });

//   factory Album.fromJson(Map<String, dynamic> json) {
//     //  
//     return Album(
//       //for whatever reason dynamic makes this parse directly to a boolean :(
//       message: json['message'] ? "true" : "false",
//     );
//   }
// }

// //make this private but still usable in test case??
// Future<Album> createAlbumDeleteAccount(roseUsername) async {
//   final response = await http.post(
//     Uri.parse(
//         'http://ec2-3-137-199-220.us-east-2.compute.amazonaws.com:3000/users/delete'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{'rose-username': roseUsername}),
//   );
//   if (response.statusCode == 200 || response.statusCode == 201) {
//     Album output = Album.fromJson(jsonDecode(response.body));
//      
//     return output;
//   } else {
//      
//     throw Exception('failed to create album');
//   }
// }

// class AlbumUpdate {
//   final String fname;

//   AlbumUpdate({
//     required this.fname,
//   });

//   factory AlbumUpdate.fromJson(Map<String, dynamic> json) {
//     return AlbumUpdate(fname: json['fname'].toString());
//   }
// }

// Future<AlbumUpdate> createAlbumUpdate(fname, roseUsername) async {
//   final response = await http.post(
//     Uri.parse('https://api.even-better-api.com/users/update'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{
//       'rose-username': roseUsername,
//       'fname': fname,
//     }),
//   );
//   //NEED TO HANDLE THIS ALBUM BETTER
//   if (response.statusCode == 200 || response.statusCode == 201) {
//     AlbumUpdate output = AlbumUpdate.fromJson(jsonDecode(response.body));
//     return output;
//   } else {
//      
//     throw Exception('failed to update album');
//   }
// }
