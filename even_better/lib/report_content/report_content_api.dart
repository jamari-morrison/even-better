import 'package:http/http.dart' as http;
import 'dart:convert';

class AlbumBool {
  final String message;

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
Future<AlbumBool> createAlbumReportContent(
    String contentId, contentType, reason) async {
  var response;
  print("content type: " + contentType);
  print("content id: " + contentId);
  print("reason: " + reason);
  // if (contentType == "post") {
  response = await http.post(
    Uri.parse('https://api.even-better-api.com:443/posts/reportContent'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'content-id': contentId,
      'content-type': contentType,
      'reason': reason
    }),
  );
  // }
  // if (contentType == "comment") {
  //   response = await http.post(
  //     Uri.parse('https://api.even-better-api.com:443/comments/reportComment'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{'comment-id': contentId}),
  //   );
  // }
  // if (contentType == "forumPost") {
  //   response = await http.post(
  //     Uri.parse('https://api.even-better-api.com:443/forum/reportForum'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{'forum-id': contentId}),
  //   );
  // }
  if (response.statusCode == 200 || response.statusCode == 201) {
    AlbumBool output = AlbumBool.fromJson(jsonDecode(response.body));
    return output;
  } else {
    print("status code: " + response.statusCode.toString());
    throw Exception('failed to create album');
  }
}
