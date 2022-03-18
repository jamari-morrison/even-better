import 'dart:async';
import 'package:even_better/models/forum_post.dart';
import 'package:even_better/models/user.dart';
import 'package:even_better/post/feed_screen.dart';
import 'package:even_better/profile/helpers/update_user_api.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:even_better/forum/connect.dart' as connect;
import 'package:intl/intl.dart';

class commentForum extends StatefulWidget {
  Forum_Post forum;
  commentForum(this.forum);
  @override
  _commentForumState createState() => _commentForumState(forum);
}

class _commentForumState extends State<commentForum> {
  final _formKey = GlobalKey<FormState>();
  String text = '';
  Forum_Post forum;
  Timer? _timer;
  final user = auth.FirebaseAuth.instance.currentUser;
  String? fbuid;
  String? email;

  String _ebuid = "";
  String _displayname = "";
  bool _ifModerator = false;
  String _roseuid = "";
  _commentForumState(this.forum);
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    // EasyLoading.addStatusCallback((status) {
    //   print('EasyLoading Status $status');
    //   if (status == EasyLoadingStatus.dismiss) {
    //     _timer?.cancel();
    //   }
    // });
    // EasyLoading.showSuccess('Loading Successed');
    // EasyLoading.removeCallbacks();
  }

  getCurrentUser() async {
    auth.User? user = auth.FirebaseAuth.instance.currentUser;
    email = user?.email;
    fbuid = user?.uid;
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
        appBar: AppBar(
          backgroundColor: CompanyColors.red,
          elevation: 0.0,
          title: const Text('What do you think?'),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
                key: _formKey, //keep track of the form
                child: Column(children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Comment here',
                      ),
                      validator: (val) => val!.isEmpty
                          ? 'Enter your thoughts'
                          : null, //is valid if null
                      onChanged: (val) {
                        setState(() => text = val);
                      }),
                  RaisedButton(
                      color: CompanyColors.red,
                      child: const Text(
                        'Comment',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // print("---!!!Creating comment: " + text);
                          // TODO: implement submit comment
                          // _timer?.cancel();
                          // await EasyLoading.show(
                          //   status: 'Commenting...',
                          //   maskType: EasyLoadingMaskType.black,
                          // );
                          // print('EasyLoading show');
                          // forum.add_comment(
                          //     Forum_Answer("answer6", "morrison jamari", text));
                          DateTime now = DateTime.now();
                          String now_string =
                              DateFormat('yyyy-MM-dd kk:mm').format(now);
                          connect.createComment(forum.postId, text, _ebuid,
                              now_string, _displayname); //TODO!!!!
                          Navigator.of(context).pop();
                          // EasyLoading.dismiss();
                        }
                      }),
                ]))));
  }
}
