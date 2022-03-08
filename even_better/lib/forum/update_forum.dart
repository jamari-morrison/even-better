// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:even_better/post/feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:even_better/forum/connect.dart' as connect;
import 'package:intl/intl.dart';

class updateForum extends StatefulWidget {
  String postid;
  String title;
  String detail;
  updateForum(this.postid, this.title, this.detail);
  @override
  _updateForumState createState() =>
      _updateForumState(this.postid, this.title, this.detail);
}

class _updateForumState extends State<updateForum> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String content = '';
  String postid;

  _updateForumState(this.postid, this.title, this.content);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          // backgroundColor: CompanyColors.red,
          elevation: 0.0,
          title: Text("Update this forum",
              style: TextStyle(
                fontFamily: 'Billabong',
                fontSize: 30.0,
              )),
        ),
        body: SingleChildScrollView(
            reverse: true,
            child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                    child: Form(
                        key: _formKey, //keep track of the form
                        child: Column(children: <Widget>[
                          SizedBox(height: 20.0),
                          TextFormField(
                              initialValue: title,
                              decoration: const InputDecoration(
                                  // hintText: "this should be what's in the db",
                                  ),
                              validator: (val) => val!.isEmpty
                                  ? 'Enter your thoughts'
                                  : null, //is valid if null
                              onChanged: (val) {
                                setState(() => title = val);
                              }),
                          SizedBox(height: 40.0),
                          TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Anything to add? (Optional)',
                              ),
                              initialValue: content,
                              onChanged: (val) {
                                setState(() => content = val);
                              }),
                          SizedBox(height: 40.0),
                          RaisedButton(
                              color: CompanyColors.red,
                              child: const Text(
                                'Update',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                print(
                                    "--------------------Update pressed------------------");
                                if (_formKey.currentState!.validate()) {
                                  print(title);
                                  print(content);
                                  Navigator.pop(context);
                                  DateTime now = DateTime.now();
                                  String now_string =
                                      DateFormat('yyyy-MM-dd kk:mm')
                                          .format(now);
                                  print(title);
                                  print(content);
                                  connect.updateForumDB(
                                      postid, title, content, now_string);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                }
                              }),
                        ]))))));
  }
}
