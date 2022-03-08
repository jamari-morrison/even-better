import 'dart:convert';

// UserI dbModelFromJson(String str) => UserI.fromJson(json.decode(str));

// String dbModelToJson(UserI data) => json.encode(data.toJson());

class UserI {
  final String roseusername, username, name, companyname, avatar, bio;
  final bool cs, se, ds;
  // final followers, following;
  // User(this.roseusername, this.username);
  UserI({
    required this.roseusername,
    required this.username,
    required this.name,
    required this.companyname,
    required this.avatar,
    required this.bio,
    required this.cs,
    required this.se,
    required this.ds,
    // required this.followers,
    // required this.following,
  });

  // factory UserI.fromJson(Map<String, dynamic> json) {
  //   return UserI(
  //     roseusername: json['rose-username'],
  //     username: json['username'],
  //     name: json['name'],
  //     companyname: json['companyname'],
  //     avatar: "json['avatar']",
  //     bio: "json['bio']",
  //     cs: true,
  //     se: false,
  //     ds: false,
  //   );
  // }
  factory UserI.fromJson(Map<String, dynamic> json) => UserI(
        roseusername: json['rose-username']! as String,
        username: json['username']! as String,
        name: json['name'],
        companyname: json['companyname'],
        avatar: json['avatar'] as String,
        bio: json['bio'],
        cs: json['cs'] as bool,
        se: json['se'] as bool,
        ds: json['ds'] as bool,
        // followers: json['followers'] as int,
        // following: json['following'] as int,
      );

  Map<String, dynamic> toJson() => {
        "rose-username": roseusername,
        "username": username,
        "name": name,
        "companyname": companyname,
        "avatar": avatar,
        "bio": bio,
        "cs": cs,
        "se": se,
        "ds": ds,
        // "followers":followers,
        // "following":following,
      };
}

class wholeUser {
  // final String profile = "None";
  // wholeUser({required String profile});
  UserI useri;
  wholeUser({
    required this.useri,
  });

  factory wholeUser.fromJson(Map<String, dynamic> json) => wholeUser(
        useri: UserI.fromJson(json["user"]),
      );
  Map<String, dynamic> toJson() => {
        "user": useri.toJson(),
      };
}
