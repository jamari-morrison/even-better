import 'dart:convert';

// UserI dbModelFromJson(String str) => UserI.fromJson(json.decode(str));

// String dbModelToJson(UserI data) => json.encode(data.toJson());

class UserI {
  final String roseusername, username, name, companyname, avatar, bio;
  final bool cs, se, ds;
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
  });

  factory UserI.fromJson(Map<String, dynamic> json) {
    return UserI(
      roseusername: json['rose-username'],
      username: json['username'],
      name: json['name'],
      companyname: json['companyname'],
      avatar: "json['avatar']",
      bio: "json['bio']",
      cs: true,
      se: false,
      ds: false,
    );
  }
  // factory UserI.fromJson(Map<String, dynamic> json) => UserI(
  //       roseusername: json['rose-username']! as String,
  //       username: json['username']! as String,
  //       name: json['name'],
  //       companyname: json['companyname'],
  //       avatar: json['avatar'],
  //       bio: json['bio'],
  //       cs: json['cs'] as bool,
  //       se: json['se'] as bool,
  //       ds: json['ds'] as bool,
  //     );

  Map<String, dynamic> toJson() => {
        "rose-username": roseusername,
        "username": username,
        "name": name,
        "companyname": companyname,
        "avatar": avatar,
        "bio": bio,
        "cs": cs,
        "se": se,
        "ds": ds
      };
}
