import 'dart:async';

import 'package:even_better/forum/data.dart';
import 'package:even_better/forum/forum%20copy.dart';
import 'package:even_better/forum/forum.dart';
import 'package:even_better/models/forum_post.dart';
import 'package:even_better/models/tag.dart';
import 'package:even_better/models/tag.dart' as tagg;
import 'package:even_better/post/feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:even_better/forum/connect.dart' as connect;
import 'package:intl/intl.dart';

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
  List<Tag> addtags = [];
  String newTag = '';
  // Data db;
  Timer? _timer;
  //TODO: get all tags
  List<Tag> tags = [
    Tag("Framework", "1"),
    Tag("Company", "1"),
    Tag("Project", "1"),
    Tag("OO Design", "1")
  ];

  _createForumState();
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
                          SizedBox(height: 40.0),
                          Container(
                              child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[tags[0], tags[1], tags[2]],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  tags[3],
                                  TextButton(
                                    onPressed: () => showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)), //this right here
                                            child: Container(
                                              height: 200,
                                              child: Padding(
                                                // key: _formKey,
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Creating New Tag",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(
                                                        height: 20.0),
                                                    TextFormField(
                                                        decoration:
                                                            const InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                hintText:
                                                                    "What's the new tag's name?"),
                                                        validator: (val) => val!
                                                                .isEmpty
                                                            ? 'Enter your thoughts'
                                                            : null, //is valid if null
                                                        onChanged: (val) {
                                                          setState(() =>
                                                              newTag = val);
                                                        }),
                                                    SizedBox(
                                                      width: 320.0,
                                                      child: FlatButton(
                                                        onPressed: () {
                                                          print(newTag);
                                                        },
                                                        child: const Text(
                                                          "Create",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        color: Colors.red,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                    child: const Text("+",
                                        style: TextStyle(color: Colors.black)),
                                  ),
                                ],
                              ),
                            ],
                          )),
                          RaisedButton(
                              color: CompanyColors.red,
                              child: const Text(
                                'Comment',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                print(
                                    "--------------------Create pressed------------------");
                                if (_formKey.currentState!.validate()) {
                                  print(title);
                                  print(content);
                                  Navigator.pop(context);
                                  /* TODO: get current User Here to pass in and create forum  */

                                  DateTime now = DateTime.now();
                                  String now_string =
                                      DateFormat('yyyy-MM-dd kk:mm')
                                          .format(now);
                                  connect.createForum(title, "Ainsley Liu",
                                      content, now_string, "");
                                  // TODO: implement submit comment
                                  _timer?.cancel();
                                  await EasyLoading.show(
                                    status: 'creating...',
                                    maskType: EasyLoadingMaskType.black,
                                  );
                                  print('EasyLoading show');
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => ForumListPage2(
                                  //             Data([], [], []), newpost)));

                                  EasyLoading.dismiss();
                                }
                              }),
                        ]))))));
  }
}
