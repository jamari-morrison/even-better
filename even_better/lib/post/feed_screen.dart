import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:even_better/Chat/select_user.dart';
import 'package:even_better/Questionaire/questionaire.dart';
import 'package:even_better/Search/searchpage.dart';
import 'package:even_better/forum/data.dart';
import 'package:even_better/forum/forum.dart';
import 'package:even_better/models/allusers.dart';
import 'package:even_better/profile/helpers/update_user_api.dart';
import 'package:even_better/report_content/report_content.dart';
import 'package:even_better/screens/api.dart';
import 'package:even_better/screens/my_flutter_app_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:even_better/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:even_better/models/post_model.dart';
import 'package:even_better/post/addpost.dart';
import 'package:even_better/post/view_post_screen.dart';
import 'package:like_button/like_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pull_to_refresh/pull_to_refresh.dart';

//https://stackoverflow.com/questions/50945526/flutter-get-data-from-a-list-of-json
class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool _hasBeenPressed = false;
  Widget p = _noaddNewPost();
  List<SinglePost> ps = <SinglePost>[];
  Widget l = _noaddNewPosts();
  // List<Posting> now_ps = <Posting>[];
  // Timer? _timer;
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  bool _shouldShowPopup = false;
  File? _image;
  List<String> friends = <String>[];
  List<Posting> serverposts = <Posting>[];
  List<Posting> fserverposts = <Posting>[];
  String postname = "";
  var pixelRatio;
  //Size in physical pixels
  var physicalScreenSize;
  var physicalWidth;
  var physicalHeight;

//Size in logical pixels
  var logicalScreenSize;
  var logicalWidth;
  var logicalHeight;

  void checkIfShouldPopup() async {
    final uri = Uri.https('api.even-better-api.com', '/popups/shouldQuestion',
        {'rose-username': 'morrisjj'});

    final response = await http.get(uri, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    final responseData = jsonDecode(response.body);

    if (responseData['message'] == 'true') {
      setState(() {
        _shouldShowPopup = true;
      });
    } else {
      setState(() {
        _shouldShowPopup = false;
      });
    }
  }

  String _username = "";
  String _name = "";
  String? email;
  String? name;

  @override
  void initState() {
    super.initState();
    checkIfShouldPopup();
    initialName();
    getUserInfo().then((result) {
      //
      setState(() {
        _name = result.name;
        if (result.avatar != "N/A" && result.avatar.isNotEmpty) {
          _image = File(result.avatar);
        }
      });
    });
    fetchFriends(_username);
    pixelRatio = window.devicePixelRatio;
    //Size in physical pixels
    physicalScreenSize = window.physicalSize;
    physicalWidth = physicalScreenSize.width;
    physicalHeight = physicalScreenSize.height;

    //Size in logical pixels
    logicalScreenSize = window.physicalSize / pixelRatio;
    logicalWidth = logicalScreenSize.width;
    logicalHeight = logicalScreenSize.height;

    getRequest(_username).then((value) {
      setState(() {
        serverposts.addAll(value);
        for (Posting po in serverposts) {
          // getDiaplayName(po.poster);
          // Future<String> name = getDiaplayName(po.poster);
          p = _buildPost(po.timestamp, po.imageUrl, po.title, po.des, po.poster,
              po.likes, po.id, context);
          Posting posting = Posting(
              title: po.title,
              des: po.des,
              imageUrl: po.imageUrl,
              likes: po.likes,
              poster: po.poster,
              timestamp: po.timestamp,
              id: po.id);
          SinglePost sp = SinglePost(po.id.toString(), po.likes, p, posting);
          ps.add(sp);
          ps.sort();
        }
      });
    });
  }

  void _onRefresh() async {
    //
    await Future.delayed(Duration(milliseconds: 100), () {
      refreshPost();
    });
    _refreshController.refreshCompleted();
  }

  refreshPost() {
    // serverposts.clear();
    // fserverposts.clear();
    // ps.clear();
    getRequest(_username).then((value) {
      setState(() {
        serverposts.addAll(value);
        for (Posting po in serverposts) {
          // getDiaplayName(po.poster);
          // Future<String> name = getDiaplayName(po.poster);
          p = _buildPost(po.timestamp, po.imageUrl, po.title, po.des, po.poster,
              po.likes, po.id, context);
          Posting posting = Posting(
              title: po.title,
              des: po.des,
              imageUrl: po.imageUrl,
              likes: po.likes,
              poster: po.poster,
              timestamp: po.timestamp,
              id: po.id);
          SinglePost sp = SinglePost(po.id.toString(), po.likes, p, posting);
          ps.add(sp);
          ps.sort();
        }
      });
    });
    fetchFriends(_username);
  }

  initialName() async {
    User? user = FirebaseAuth.instance.currentUser;
    email = user?.email;
    if (email != null) {
      _username = email!;
    }
    name = user?.displayName;
    if (name != null) {
      _name = name!;
    }
  }

  Future<String> getDisplayName(String email) async {
    final response = await http.get(
      Uri.parse('https://api.even-better-api.com/users/getUser/' + email),
      // Uri.parse('http://10.0.2.2:3000/users/users/getUser/' + email),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      var user = json.decode(response.body);
      wholeUser u = wholeUser.fromJson(user);

      //
      setState(() {
        postname = u.useri.name;
      });
      return u.useri.name;
    } else {
      throw Exception('failed to load user');
    }
  }

  Future<List<Posting>> getRequest(String username) async {
    List<Posting> posts = <Posting>[];
    var url = 'https://api.even-better-api.com/posts/getUserPost/' + username;
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonMembers = json.decode(response.body);

      setState(() {
        // posts =
        //     jsonMembers.map<Posting>((json) => Posting.fromJson(json)).toList();
        posts =
            jsonMembers.map<Posting>((json) => Posting.fromJson(json)).toList();
      });
      return posts;
    } else {
      throw Exception('failed to get all user posts info');
    }
  }

  void fetchFriends(email) async {
    var url = 'https://api.even-better-api.com/users/getUserFriends/' + email;
    // var url = 'http://10.0.2.2:3000/users/getUserFriends/' + email;
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonMembers = json.decode(response.body);

      if (jsonMembers != null) {
        setState(() {
          friends = (jsonMembers as List).map((e) => e as String).toList();
        });
        if (friends != null) {
          for (String friend in friends) {
            getRequest(friend).then((value) {
              setState(() {
                fserverposts.addAll(value);

                if (!fserverposts.isEmpty) {
                  for (Posting po in fserverposts) {
                    // getDiaplayName(po.poster);
                    // Future<String> name = getDiaplayName(po.poster);
                    p = _buildPost(po.timestamp, po.imageUrl, po.title, po.des,
                        po.poster, po.likes, po.id, context);
                    Posting posting = Posting(
                        title: po.title,
                        des: po.des,
                        imageUrl: po.imageUrl,
                        likes: po.likes,
                        poster: po.poster,
                        timestamp: po.timestamp,
                        id: po.id);
                    SinglePost sp =
                        SinglePost(po.id.toString(), po.likes, p, posting);
                    ps.add(sp);
                    ps.sort();
                  }
                }
                l = getPostWidgets();
              });
            });
          }
        }
      }
    } else {
      throw Exception('failed to get all user info');
    }
  }

  Image getAvatarImage() {
    if (_image == null) {
      return Image(
        height: 50.0,
        width: 50.0,
        image: AssetImage(posts[0].authorImageUrl),
        fit: BoxFit.cover,
      );
    }
    return Image.file(
      _image!,
      height: 50.0,
      width: 50.0,
      fit: BoxFit.cover,
    );
  }

  FileImage getPostImage(String s) {
    return FileImage(File(s));
  }

  Widget _buildPost(String time, String image, String title, String content,
      String name, int likes, var pid, context) {
    // String uname = "";
    // getDiaplayName(name).then((String result) {
    //   setState(() {
    //     uname = result;
    //   });
    // });
    var itemsInMenu;
    if (name == _username) {
      itemsInMenu = [
        DropdownMenuItem(
          value: 1,
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () async {
                  TextEditingController titleController =
                      TextEditingController();
                  TextEditingController postController =
                      TextEditingController();
                  _displayTextInputDialog(
                      context, titleController, postController, pid);
                },
                color: Colors.transparent,
                icon: Icon(
                  Icons.update,
                  size: 35.0,
                  color: Colors.black,
                ),
                padding: EdgeInsets.only(right: 10.0),
              ),
              TextButton(
                // style: TextButton.styleFrom(primary: Colors.black),
                onPressed: () async {
                  TextEditingController titleController =
                      TextEditingController();
                  titleController.text = title;
                  TextEditingController postController =
                      TextEditingController();
                  postController.text = content;
                  await _displayTextInputDialog(
                      context, titleController, postController, pid);
                  // WidgetsBinding.instance
                  //     ?.addPostFrameCallback((_) => setState(() {
                  //           refreshPost();
                  //         }));
                  setState(() {
                    SinglePost toedit =
                        ps.firstWhere((element) => element.pid == pid);
                    ps
                        .firstWhere((element) => element.pid == pid)
                        .posting
                        .title = titleController.text;
                    ps.firstWhere((element) => element.pid == pid).posting.des =
                        postController.text;
                    serverposts
                        .firstWhere((element) => element.id == pid)
                        .title = titleController.text;
                    serverposts.firstWhere((element) => element.id == pid).des =
                        postController.text;
                    toedit.posting.title = titleController.text;
                    toedit.posting.des = postController.text;
                    _onRefresh();
                  });
                },
                child: Text("Update", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
        DropdownMenuItem(
            value: 2,
            child: Row(children: <Widget>[
              IconButton(
                  onPressed: () async {
                    Widget cancelButton = TextButton(
                      child: Text("CANCEL"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    );
                    Widget continueButton = TextButton(
                      child: Text("DELETE"),
                      onPressed: () {
                        deletePost(pid);
                        Navigator.of(context).pop();
                        setState(() {
                          serverposts
                              .removeWhere((element) => element.id == pid);
                          ps.removeWhere((item) => item.pid == pid);
                        });
                      },
                    );
                    // set up the AlertDialog
                    AlertDialog alert = AlertDialog(
                      title: Text("Are you sure?"),
                      content: Text("This post will be deleted permanently."),
                      actions: [
                        cancelButton,
                        continueButton,
                      ],
                    );
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  },
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(right: 10.0),
                  icon: const Icon(
                    Icons.delete,
                    size: 35.0,
                    color: Colors.black,
                  )),
              TextButton(
                // style: TextButton.styleFrom(primary: Colors.black),r
                onPressed: () async {
                  Widget cancelButton = TextButton(
                    child: Text("CANCEL"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  );
                  Widget continueButton = TextButton(
                    child: Text("DELETE"),
                    onPressed: () {
                      deletePost(pid);
                      Navigator.of(context).pop();
                      setState(() {
                        serverposts.removeWhere((element) => element.id == pid);
                        ps.removeWhere((item) => item.pid == pid);
                      });
                    },
                  );
                  // set up the AlertDialog
                  AlertDialog alert = AlertDialog(
                    title: Text("Are you sure?"),
                    content: Text("This post will be deleted permanently."),
                    actions: [
                      cancelButton,
                      continueButton,
                    ],
                  );
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                },
                child: Text("Delete", style: TextStyle(color: Colors.black)),
              ),
            ])),
        DropdownMenuItem(
            value: 3,
            child: Row(children: <Widget>[
              IconButton(
                onPressed: () async {},
                color: Colors.transparent,
                icon: const Icon(
                  Icons.report,
                  size: 35.0,
                  color: Colors.black,
                ),
                padding: EdgeInsets.only(right: 10.0),
              ),
              TextButton(
                // style: TextButton.styleFrom(primary: Colors.black),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReportContent(
                              contentId: "123",
                              contentType: "posts",
                            )),
                  );
                },
                child: Text("Report", style: TextStyle(color: Colors.black)),
              ),
            ]))
      ];
    } else {
      itemsInMenu = [
        DropdownMenuItem(
            value: 1,
            child: Row(children: <Widget>[
              IconButton(
                onPressed: () async {},
                color: Colors.transparent,
                icon: const Icon(
                  Icons.report,
                  size: 35.0,
                  color: Colors.black,
                ),
                padding: EdgeInsets.only(right: 10.0),
              ),
              TextButton(
                // style: TextButton.styleFrom(primary: Colors.black),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReportContent(
                              contentId: "123",
                              contentType: "posts",
                            )),
                  );
                },
                child: Text("Report", style: TextStyle(color: Colors.black)),
              ),
            ]))
      ];
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Container(
        width: double.infinity,
        // height: 800.0,
        constraints: const BoxConstraints(
          maxHeight: double.infinity,
        ),
        decoration: BoxDecoration(
          // color: Colors.white,
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    leading: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            offset: Offset(0, 2),
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        child: ClipOval(child: getAvatarImage()),
                      ),
                    ),
                    title: Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                    subtitle: Text(
                      time,
                      maxLines: 1,
                    ),
                    trailing: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            icon: const Icon(
                              Icons.more_horiz,
                              size: 30.0,
                              color: Colors.black,
                            ),
                            items: itemsInMenu,
                            // onTap: () => print("Menu pressed"),
                            onChanged: (value) {})),
                  ),
                  InkWell(
                    onDoubleTap: () {
                      changedata(true, likes, pid);
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ViewPostScreen(
                            post:
                                ps.firstWhere((element) => element.pid == pid),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10.0),
                      width: double.infinity,
                      height: 400.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        // boxShadow: const [
                        //   BoxShadow(
                        //     color: Colors.black45,
                        //     offset: Offset(0, 5),
                        //     blurRadius: 8.0,
                        //   ),
                        // ],
                        image: DecorationImage(
                          image: getPostImage(image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                // IconButton(
                                //     icon: const Icon(Icons.favorite_border),
                                //     iconSize: 30.0,
                                //     onPressed: () {
                                //       createLikeUpdate(likes++, pid);
                                //       refreshPost();
                                //     }

                                //     // => print('Like post'),
                                //     ),
                                // Text(
                                //   // serverposts[serverposts.length - 1].likes.toString(),
                                //   likes.toString(),
                                //   style: const TextStyle(
                                //     fontSize: 14.0,
                                //     fontWeight: FontWeight.w600,
                                //   ),
                                // ),

                                LikeButton(
                                  size: 30,
                                  circleColor: const CircleColor(
                                      start: Color(0xff00ddff),
                                      end: Color(0xff0099cc)),
                                  bubblesColor: const BubblesColor(
                                    dotPrimaryColor: Color(0xff33b5e5),
                                    dotSecondaryColor: Color(0xff0099cc),
                                  ),
                                  likeBuilder: (bool isLiked) {
                                    return Icon(
                                      Icons.favorite,
                                      color: isLiked
                                          ? Colors.pinkAccent
                                          : Colors.grey,
                                      size: 30,
                                    );
                                  },
                                  likeCount: likes,
                                  // onTap: onLikeButtonTapped,
                                  onTap: (isLiked) {
                                    return changedata(isLiked, likes, pid);
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.chat),
                                  iconSize: 30.0,
                                  onPressed: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (_) => ViewPostScreen(
                                    //       post: posts[0],
                                    //     ),
                                    //   ),
                                    // );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ViewPostScreen(
                                          post: ps.firstWhere(
                                              (element) => element.pid == pid),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                // Text(
                                //   likes.toString(),
                                //   style: const TextStyle(
                                //     fontSize: 14.0,
                                //     fontWeight: FontWeight.w600,
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 330,
                    child: Text(
                      title,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'EBX',
                          color: Colors.grey[800],
                          fontSize: 18.0),
                    ),
                  ),
                  Container(
                    width: 330,
                    constraints: const BoxConstraints(
                      maxHeight: double.infinity,
                    ),
                    child: Text(
                      content,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'EBR',
                          color: Colors.grey[800],
                          fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(
      BuildContext context,
      TextEditingController titleController,
      TextEditingController postController,
      String id) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Update Text'),
            content: Container(
              height: 350.0,
              width: 400,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  _descriptionTile(titleController),
                  SizedBox(height: 30),
                  _contentTile(
                    postController,
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('Update'),
                onPressed: () {
                  setState(() {
                    createPostUpdate(
                        titleController.text, postController.text, id);
                    SinglePost toedit =
                        ps.firstWhere((element) => element.pid == id);
                    toedit.posting.title = titleController.text;
                    toedit.posting.des = postController.text;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  Widget _descriptionTile(TextEditingController titleController) {
    return ListTileTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        tileColor: Colors.grey[200],
        leading: Icon(Icons.edit),
        title: Text(
          'Post Title',
          style: TextStyle(
              fontFamily: 'EB',
              height: 2,
              color: Colors.grey[800],
              fontSize: 20.0),
        ),
        subtitle: TextField(
          controller: titleController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter...',
          ),
          minLines: 1,
          maxLines: 2,
          maxLength: 44,
        ),
      ),
    );
  }

  Widget _contentTile(TextEditingController postController) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        tileColor: Colors.grey[200],
        leading: Icon(Icons.edit),
        title: Text(
          'Post Content',
          style: TextStyle(
              fontFamily: 'EB',
              height: 2,
              color: Colors.grey[800],
              fontSize: 20.0),
        ),
        subtitle: TextField(
          controller: postController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter...',
          ),
          //keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 3,
          maxLength: 300,
        ),
      ),
    ]);
  }

  Future<bool> changedata(bool status, int likes, String id) async {
    //your code
    if (status) {
      createLikeUpdate(likes + 1, id);
    } else {
      createLikeUpdate(likes, id);
    }
    return Future.value(!status);
  }

  int _index = 0;
  @override
  Widget build(BuildContext context) {
    // screenwidth = MediaQuery.of(context).size.width;
    // screenheight = MediaQuery.of(context).size.height;

    Widget child = Container();

    switch (_index) {
      case 0:
        child = postHome();
        break;
      case 1:
        child = MySearchPage();
        break;
      case 3:
        child = ForumListPage();
        break;
      case 4:
        child = ProfileApp();
        break;
    }
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: _bottomTab(),
      body: SizedBox.expand(child: child),
    );
  }

  Widget _bottomTab() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30.0),
        topRight: Radius.circular(30.0),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        onTap: (int index) => setState(() => _index = index),
        //backgroundColor: Colors.deepPurple,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.dashboard,
              size: 30.0,
              color: Colors.grey,
            ),
            title: Text(''),
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 30.0,
              color: Colors.grey,
            ),
            title: Text(''),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Color(0xFFF8BBD0),
                onPressed: () async {
                  // final NewPost _post = await
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageFromGalleryEx()));
                  // refreshPost();
                  serverposts.clear();
                  fserverposts.clear();
                  ps.clear();
                  _onRefresh();
                },
                child: const Icon(
                  Icons.add,
                  size: 35.0,
                  color: Colors.white,
                ),
              ),
            ),
            title: Text(''),
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              // MyFlutterApp.community,
              Icons.people_outlined,
              size: 30.0,
              color: Colors.grey,
            ),
            title: Text(''),
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              size: 30.0,
              color: Colors.grey,
            ),
            title: Text(''),
          ),
        ],
      ),
    );
  }

  Widget postHome() {
    return _shouldShowPopup
        ? Questionaire(currentStudent: 'morrisjj')
        : ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Even Better',
                      style: TextStyle(
                        fontFamily: 'Billabong',
                        fontSize: 35.0,
                        color: CompanyColors.red,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        const SizedBox(width: 16.0),
                        SizedBox(
                          width: 35.0,
                          child: IconButton(
                            icon: const Icon(Icons.send),
                            iconSize: 30.0,
                            onPressed: () async {
                              // _timer?.cancel();
                              // await EasyLoading.show(
                              //   status: 'loading...',
                              //   maskType: EasyLoadingMaskType.black,
                              // );
                              //
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      SelectUser(currentStudent: _username),
                                ),
                              );
                              // EasyLoading.dismiss();
                            }

                            // => print('Direct Messages')
                            ,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              // p,
              ps.isEmpty ? _noaddNewPosts() : getPostWidgets(),
              // l,
              // Container(
              //   height: 200,
              // ),
            ],
          );
  }

  Widget getPostWidgets() {
    return Container(
        width: double.infinity,
        // height: double.infinity,
        // height: MediaQuery.of(context).size.height * 1.20,
        constraints: const BoxConstraints(
          // minHeight: 800,
          maxHeight: double.infinity,
        ),
        child: ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            // physics: AlwaysScrollableScrollPhysics(),
            children:
                // ps.reversed.toList()
                displayingpost(ps).reversed.toList()));
  }

  List<Widget> displayingpost(List<SinglePost> ls) {
    List<Widget> toreturn = <Widget>[];
    for (var i = 0; i < ls.length; i++) {
      toreturn.add(ls[i].widget);
    }

    return toreturn;
  }

  Widget _contentWidget(String text, bool _flag) {
    String firstHalf;
    String secondHalf;
    bool _flag = true;

    if (text.length > 52) {
      firstHalf = text.substring(0, 52);
      secondHalf = text.substring(52, text.length);
    } else {
      firstHalf = text;
      secondHalf = "";
    }
    return Container(
      width: 330,
      child: secondHalf.isEmpty
          ? Text(
              firstHalf,
              style: TextStyle(
                  fontFamily: 'EBR', color: Colors.grey[800], fontSize: 18.0),
            )
          : Column(
              children: <Widget>[
                Text(
                  _flag ? (firstHalf + "...") : (firstHalf + secondHalf),
                  style: TextStyle(
                      fontFamily: 'EBR',
                      color: Colors.grey[800],
                      fontSize: 18.0),
                ),
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        _flag ? "show more" : "show less",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _flag = !_flag;
                    });
                  },
                ),
              ],
            ),
    );
  }
}

Widget _noaddNewPosts() {
  var pixelRatio = window.devicePixelRatio;
  //Size in physical pixels
  var physicalScreenSize = window.physicalSize;
  var physicalWidth = physicalScreenSize.width;
  var physicalHeight = physicalScreenSize.height;

//Size in logical pixels
  var logicalScreenSize = window.physicalSize / pixelRatio;
  var logicalWidth = logicalScreenSize.width;
  var logicalHeight = logicalScreenSize.height;
  return Padding(
    padding: EdgeInsets.all(logicalWidth * 0.085),
    child: Container(
      width: double.infinity,
      height: logicalHeight * 0.55,
      constraints: const BoxConstraints(
        maxHeight: double.infinity,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(10.0),
          color: Colors.white,
          width: logicalWidth * 0.8,
          height: logicalHeight * 0.5,
          child: Center(
            child: Text(
              'Create your first Post! :)',
              style: TextStyle(
                fontFamily: 'Billabong',
                fontSize: logicalWidth / 13,
                color: CompanyColors.red,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _noaddNewPost() {
  return Container(
    decoration: const BoxDecoration(color: Colors.white),
    child: const Center(
      child: Text(
        '',
        textDirection: TextDirection.ltr,
        style: TextStyle(
          fontSize: 32,
          color: Colors.black87,
        ),
      ),
    ),
  );
}

class CompanyColors {
  CompanyColors._(); // this basically makes it so you can instantiate this class

  static const _redColor = 0xFF800000;

  static const MaterialColor red = MaterialColor(
    _redColor,
    <int, Color>{
      20: Color(0xFFFFD4D4),
      30: Color(0xFFAABEFB),
      50: Color(0xFFD50000),
      100: Color(0xFFB30000),
      200: Color(0xFFA30000),
      300: Color(0xFF9B0000),
      400: Color(0xFF800000),
      500: Color(0xFF800000),
      600: Color(0xFFCC1414),
      700: Color(0xFFCC1414),
      800: Color(0xFF96084F),
      900: Color(0xFF96084F)
    },
  );
}

// class SinglePost {
//   Posting posting;
//   Widget widget;
//   SinglePost(this.posting, this.widget);
// }
class SinglePost implements Comparable<SinglePost> {
  String pid;
  int likes;
  Widget widget;
  Posting posting;
  SinglePost(this.pid, this.likes, this.widget, this.posting);

  @override
  compareTo(SinglePost b) {
    int order = posting.timestamp.compareTo(b.posting.timestamp);
    if (order == 0) order = b.posting.timestamp.compareTo(posting.timestamp);
    return order;
  }
}
