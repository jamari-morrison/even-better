import 'dart:async';
import 'dart:convert';
import 'package:even_better/models/allusers.dart';
import 'package:even_better/post/feed_screen.dart';
import 'package:even_better/profile/helpers/add_friend_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:search_page/search_page.dart';
import 'package:http/http.dart' as http;

/// This is a very simple class, used to
/// demo the `SearchPage` package
// class Person {
//   final String name, surname;
//   final num age;

//   Person(this.name, this.surname, this.age);
// }

class MySearchPage extends StatefulWidget {
  const MySearchPage({Key? key}) : super(key: key);
  @override
  _MySearchPageState createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  List<UserI> _users = <UserI>[];
  // Timer? _timer;
  String _username = "";
  String? email;
  List<String> friends = <String>[];

  @override
  Widget build(BuildContext context) {
    print(_users.length);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Search Page'),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final UserI person = _users[index];
          return ListTile(
              title: Text(person.name),
              subtitle: Text(person.username),
              // trailing: Text('${person.age} yo'),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.add_circle_outline_sharp,
                    color: CompanyColors.red,
                  ),
                  onPressed: () {
                    bool ifcontain = friends.contains(person.username);
                    if (_username == person.username) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildSelfDialog(context),
                      );
                    } else if (ifcontain) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildFriendDialog(context),
                      );
                    } else {
                      createAddFriend(person.username);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopupDialog(context),
                      );
                    }
                  },
                )
              ]));
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Search people',
        onPressed: () => showSearch(
          context: context,
          delegate: SearchPage<UserI>(
            onQueryUpdate: (s) => print(s),
            items: _users,
            searchLabel: 'Search people',
            suggestion: Center(
              child: Text('Filter people by name'),
            ),
            failure: Center(
              child: Text('No person found :('),
            ),
            filter: (person) => [
              person.username,
              person.roseusername,
              person.name,
              person.companyname,
              person.bio,
              //person.age.toString(),
            ],
            builder: (person) => ListTile(
              title: Text(person.name),
              subtitle: Text(person.username),
              // trailing: Text('${person.age} yo'),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.add_circle_outline_sharp,
                    color: CompanyColors.red,
                  ),
                  onPressed: () {
                    bool ifcontain = friends.contains(person.username);
                    if (_username == person.username) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildSelfDialog(context),
                      );
                    } else if (ifcontain) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildFriendDialog(context),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopupDialog(context),
                      );
                    }
                  },
                )
              ]),
            ),
          ),
        ),
        child: Icon(Icons.search),
      ),
    );
  }

  Future<List<UserI>> fetchUsers() async {
    // var users = List<User>();
    List<UserI> users = <UserI>[];
    var url = 'https://api.even-better-api.com/users/all';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonMembers = json.decode(response.body);
      setState(() {
        users = jsonMembers.map<UserI>((json) => UserI.fromJson(json)).toList();
      });
      return users;
    } else {
      print("status code: " + response.statusCode.toString());
      throw Exception('failed to get all user info');
    }
  }

  void fetchFriends(email) async {
    print("email: " + email);
    var url = 'https://api.even-better-api.com/users/getUserFriends/' + email;
    // var url = '10.0.2.2/users/getUserFriends/' + email;
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonMembers = json.decode(response.body);
      print(response.body);
      print(jsonMembers);
      if (jsonMembers != null) {
        setState(() {
          friends = (jsonMembers as List).map((e) => e as String).toList();
        });

        print("ffffffffffffffffff" + friends.length.toString());
      }
    } else {
      print("status code: " + response.statusCode.toString());
      throw Exception('failed to get all user info');
    }
  }

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    fetchUsers().then((value) {
      _users.addAll(value);
    });
    email = user?.email;
    if (email != null) {
      _username = email!;
    }
    print("fffffff" + _username);
    fetchFriends(_username);
    print("fffff" + friends.length.toString());
    // EasyLoading.addStatusCallback((status) {
    //   print('EasyLoading Status $status');
    //   if (status == EasyLoadingStatus.dismiss) {
    //     _timer?.cancel();
    //   }
    // });
    // EasyLoading.showSuccess('Seach Loaded');
    // EasyLoading.removeCallbacks();
  }
}

Widget _buildPopupDialog(BuildContext context) {
  return AlertDialog(
    title: const Text('Friend'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        Text("Added"),
      ],
    ),
    actions: <Widget>[
      FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Ok'),
      ),
    ],
  );
}

Widget _buildSelfDialog(BuildContext context) {
  return AlertDialog(
    title: const Text('Sorry'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        Text("You can't follow yourself"),
      ],
    ),
    actions: <Widget>[
      FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Close'),
      ),
    ],
  );
}

Widget _buildFriendDialog(BuildContext context) {
  return AlertDialog(
    title: const Text('Sorry'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        Text("Can't follow the friend again!"),
      ],
    ),
    actions: <Widget>[
      FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Close'),
      ),
    ],
  );
}
