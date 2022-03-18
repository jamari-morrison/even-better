// ignore_for_file: prefer_const_constructors, camel_case_types

import 'dart:async';

import 'package:even_better/models/forum_post.dart';
import 'package:even_better/models/tag.dart';
import 'package:even_better/models/tag.dart' as tagg;
import 'package:even_better/models/user.dart';
import 'package:even_better/post/feed_screen.dart';
import 'package:even_better/profile/helpers/update_user_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:even_better/forum/connect.dart' as connect;
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class createForum extends StatefulWidget {
  // Data db;
  createForum();
  @override
  _createForumState createState() => _createForumState();
}

class _createForumState extends State<createForum> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String content = '';
  // List<Tag> addtags = [];
  // String newTag = '';
  Timer? _timer;
  // String name = "Add a name";
  final user = auth.FirebaseAuth.instance.currentUser;
  String? fbuid;
  String? email;

  String _ebuid = "";
  String _displayname = "";
  bool _ifModerator = false;
  String _roseuid = "";
  /*get all tags*/
  // List<Tag> tags = [
  //   Tag("Framework", "1"),
  //   Tag("Company", "1"),
  //   Tag("Project", "1"),
  //   Tag("OO Design", "1")
  // ];

  _createForumState();
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  getCurrentUser() async {
    auth.User? user = auth.FirebaseAuth.instance.currentUser;
    email = user?.email;
    fbuid = user?.uid;
    MyUser currentUser = MyUser(fbuid!, email);
    _ebuid = MyUser.getEBUid();
    _displayname = MyUser.getDisplayName();
    _ifModerator = MyUser.getIsModerator();
    _roseuid = MyUser.getRoseUsername();
    print("firebase uid is " + fbuid! + " and email is " + email!);
    print("EB uid is " + _ebuid);
    print("displayname is " + _displayname);
    print(_ifModerator);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          // backgroundColor: CompanyColors.red,
          elevation: 0.0,
          title: const Text('What do you think?'),
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
                              decoration: const InputDecoration(
                                hintText: 'Enter title here',
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
                                hintText: 'What do you think? (Optional)',
                              ),
                              // validator: (val) => val!.isEmpty
                              //     ? 'Enter your thoughts'
                              //     : null, //is valid if null
                              onChanged: (val) {
                                setState(() => content = val);
                              }),
                          // tag section here, saved in forum copy.dart
                          RaisedButton(
                              color: CompanyColors.red,
                              child: const Text(
                                'Comment',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.pop(context);
                                  /* TODO: get current User to pass in and create forum  */

                                  DateTime now = DateTime.now();
                                  String now_string =
                                      DateFormat('yyyy-MM-dd kk:mm')
                                          .format(now);
                                  connect.createForum(title, _displayname,
                                      _ebuid, content, now_string, "", "");
                                  // TODO: implement submit comment
                                  // _timer?.cancel();
                                  // await EasyLoading.show(
                                  //   status: 'creating...',
                                  //   maskType: EasyLoadingMaskType.black,
                                  // );
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => ForumListPage2(
                                  //             Data([], [], []), newpost)));

                                  // EasyLoading.dismiss();
                                }
                              }),
                        ]))))));
  }
}
