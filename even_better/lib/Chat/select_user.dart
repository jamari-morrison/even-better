import 'dart:async';

import 'package:even_better/Invite/invite_year.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'direct_message.dart';

class SelectUser extends StatefulWidget {
  const SelectUser({
    required this.currentStudent,
    Key? key,
  }) : super(key: key);
  final String currentStudent;

  @override
  State<SelectUser> createState() => _SelectUserState();
}

class _SelectUserState extends State<SelectUser> {
  List<Widget> itemsData = [];
  List<Widget> coreItems = [];
  Map<Widget, String> nameMap = {};
  String searchString = "";
  Icon searchIcon = Icon(Icons.search);
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    getItemData();
    EasyLoading.addStatusCallback((status) {
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    EasyLoading.showSuccess('All Alumnis Loaded');
    // EasyLoading.removeCallbacks();
  }

  Widget customSearchBar = const Text(
    'Find friends',
    style: TextStyle(
      fontFamily: 'Billabong',
      fontSize: 35.0,
    ),
  );

  void getItemData() async {
    List<Widget> listItems = [];
    Map<Widget, String> listMap = {};

    final uri = Uri.https('api.even-better-api.com:3000', '/students/all',
        {}); //in future don't grab all students
    final response = await http.get(uri, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    List<dynamic> responseList = jsonDecode(response.body);

    for (var student in responseList) {
      Widget toAdd = Visibility(
        child: ElevatedButton(
            child: Text(student['name']),
            onPressed: () async {
              _timer?.cancel();
              await EasyLoading.show(
                status: 'loading...',
                maskType: EasyLoadingMaskType.black,
              );
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DirectMessage(
                            currentStudent: 'Jamari Morrison',
                            recipient: student['name'],
                          )));
              EasyLoading.dismiss();
            }),
        visible: student['name'].contains(searchString),
      );
      listItems.add(toAdd);
      listMap[toAdd] = student['name'];
    }

    setState(() {
      itemsData = listItems;
      nameMap = listMap;
      for (var v in listItems) {
        coreItems.add(v);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: customSearchBar,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(
                Icons.add_circle_outline_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        InviteYear(currentStudent: "Jamari Morrison"),
                  ),
                );
              },
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  if (searchIcon.icon == Icons.search) {
                    searchIcon = const Icon(Icons.cancel);
                    customSearchBar = ListTile(
                      leading: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 28,
                      ),
                      title: TextField(
                        decoration: const InputDecoration(
                          hintText: 'type in student name',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        onChanged: (text) {
                          setState(() {
                            itemsData.clear();
                            for (var student in coreItems) {
                              if (nameMap[student]!.contains(text)) {
                                itemsData.add(student);
                              }
                            }
                          });
                        },
                      ),
                    );
                  }
                });
              },
              icon: searchIcon,
            )
          ],
          centerTitle: true,
        ),
        body: Container(
            child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: itemsData.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return itemsData[index];
                    }))
          ],
        )));
  }
}
