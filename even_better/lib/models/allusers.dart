class User {
  final String roseusername, username;
  // User(this.roseusername, this.username);
  User({
    required this.roseusername,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      roseusername: json['rose-username'],
      username: json['username'],
    );
  }
}
