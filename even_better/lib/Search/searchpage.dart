import 'dart:async';
import 'dart:convert';

import 'package:even_better/UserVerification/Helpers/verification_rest_api.dart';
import 'package:even_better/models/allusers.dart';
import 'package:even_better/post/feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

// class MySearchPage extends StatelessWidget {
//   // List<Person> people = getItemData() as List<Person>;
//   static List<Person> people = [
//     Person('Mike', 'Barron', 64),
//     Person('Todd', 'Black', 30),
//     Person('Ahmad', 'Edwards', 55),
//     Person('Anthony', 'Johnson', 67),
//     Person('Annette', 'Brooks', 39),
//   ];
class _MySearchPageState extends State<MySearchPage> {
  List<User> _users = <User>[];
  Timer? _timer;

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
          final User person = _users[index];
          return ListTile(
              title: Text(person.name),
              subtitle: Text(person.username),
              // trailing: Text('${person.age} yo'),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Icon(
                  Icons.add_circle_outline_sharp,
                  color: CompanyColors.red,
                )
              ]));
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Search people',
        onPressed: () => showSearch(
          context: context,
          delegate: SearchPage<User>(
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
              //person.age.toString(),
            ],
            builder: (person) => ListTile(
              title: Text(person.name),
              subtitle: Text(person.username),
              // trailing: Text('${person.age} yo'),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Icon(
                  Icons.add_circle_outline_sharp,
                  color: CompanyColors.red,
                )
              ]),
            ),
          ),
        ),
        child: Icon(Icons.search),
      ),
    );
  }

  Future<List<User>> fetchUsers() async {
    // var users = List<User>();
    List<User> users = <User>[];
    var url = 'https://api.even-better-api.com:443/users/all';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonMembers = json.decode(response.body);
      setState(() {
        users =
            jsonMembers.map<User>((json) => new User.fromJson(json)).toList();
      });
      return users;
    } else {
      print("status code: " + response.statusCode.toString());
      throw Exception('failed to get all user info');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers().then((value) {
      _users.addAll(value);
    });
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    EasyLoading.showSuccess('Seach Loaded');
    // EasyLoading.removeCallbacks();
  }
}
