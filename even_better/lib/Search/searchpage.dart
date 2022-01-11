import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:search_page/search_page.dart';
import 'package:http/http.dart' as http;

/// This is a very simple class, used to
/// demo the `SearchPage` package
class Person {
  final String name, surname;
  final num age;

  Person(this.name, this.surname, this.age);
}

class MySearchPage extends StatelessWidget {
  // List<Person> people = getItemData() as List<Person>;
  static List<Person> people = [
    Person('Mike', 'Barron', 64),
    Person('Todd', 'Black', 30),
    Person('Ahmad', 'Edwards', 55),
    Person('Anthony', 'Johnson', 67),
    Person('Annette', 'Brooks', 39),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Page'),
      ),
      body: ListView.builder(
        itemCount: people.length,
        itemBuilder: (context, index) {
          final Person person = people[index];
          return ListTile(
            title: Text(person.name),
            subtitle: Text(person.surname),
            trailing: Text('${person.age} yo'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Search people',
        onPressed: () => showSearch(
          context: context,
          delegate: SearchPage<Person>(
            onQueryUpdate: (s) => print(s),
            items: people,
            searchLabel: 'Search people',
            suggestion: Center(
              child: Text('Filter people by name, surname or age'),
            ),
            failure: Center(
              child: Text('No person found :('),
            ),
            filter: (person) => [
              person.name,
              person.surname,
              person.age.toString(),
            ],
            builder: (person) => ListTile(
              title: Text(person.name),
              subtitle: Text(person.surname),
              trailing: Text('${person.age} yo'),
            ),
          ),
        ),
        child: Icon(Icons.search),
      ),
    );
  }
}

Future<List<Person>> getItemData() async {
  List<Person> ps = <Person>[];
  List<Widget> listItems = [];
  Map<Widget, String> listMap = {};

  final uri = Uri.http('https://api.even-better-api.com:443', '/users/all',
      {}); //in future don't grab all students
  final response = await http.get(uri, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
  List<dynamic> responseList = jsonDecode(response.body);

  for (var student in responseList) {
    ps.add(Person(student['username'], student['rose-username'], 0));
  }

  return ps;
}
