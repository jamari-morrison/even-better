class User {
  final String roseusername, username, name;
  // User(this.roseusername, this.username);
  User({
    required this.roseusername,
    required this.username,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      roseusername: json['rose-username'],
      username: json['username'],
      name: json['name'],
    );
  }
}
