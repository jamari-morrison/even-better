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
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:convert';
import '../Faculty/faculty_homescreen.dart';
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
  // Widget l = _noaddNewPosts();
  // List<Posting> now_ps = <Posting>[];
  // Timer? _timer;
  bool _shouldShowPopup = false;
  File? _image;
  List<String> friends = <String>[];
  List<Posting> serverposts = <Posting>[];
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
    final uri = Uri.http('10.0.2.2:3000', '/popups/shouldQuestion',
        {'rose-username': 'morrisjj'});

    final response = await http.get(uri, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    print(response.body);

    final responseData = jsonDecode(response.body);
    print(responseData['message']);
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
    initPlatform();
    checkIfShouldPopup();
    initialName();
    getUserInfo().then((result) {
      // print(result.avatar);
      setState(() {
        _name = result.name;
        if (result.avatar != "N/A" && result.avatar.isNotEmpty) {
          _image = File(result.avatar);
        }
      });
    });
    fetchUsers(_username);
    pixelRatio = window.devicePixelRatio;
    //Size in physical pixels
    physicalScreenSize = window.physicalSize;
    physicalWidth = physicalScreenSize.width;
    physicalHeight = physicalScreenSize.height;

    //Size in logical pixels
    logicalScreenSize = window.physicalSize / pixelRatio;
    logicalWidth = logicalScreenSize.width;
    logicalHeight = logicalScreenSize.height;
    getRequest().then((value) {
      setState(() {
        serverposts.addAll(value);
        for (Posting po in serverposts) {
          // Future<String> name = getDiaplayName(po.poster);
          p = _buildPost(po.timestamp, po.imageUrl, po.title, po.des, po.poster,
              po.likes, '', context);
          SinglePost sp = SinglePost('', po.likes, p);
          ps.add(sp);
        }
        print("000000000000000000sb");
        print(ps.length);
        // l = getPostWidgets();
      });
    });
    // if (ps.isEmpty) {
    //   setState(() {
    //     l = _noaddNewPost();
    //   });
    // }
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

  Future<String> getDiaplayName(String email) async {
    print("email: " + email);
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
      print(u.useri.name);
      // print(user.toString());
      return u.useri.name;
    } else {
      print("status code: " + response.statusCode.toString());
      throw Exception('failed to load user');
    }
  }

  Future<List<Posting>> getRequest() async {
    print("Ip: get -> Post");
    List<Posting> posts = <Posting>[];
    var url = 'http://10.0.2.2:3000/posts/getUserPost/' + _username;
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonMembers = json.decode(response.body);
      print(jsonMembers);
      setState(() {
        // posts =
        //     jsonMembers.map<Posting>((json) => Posting.fromJson(json)).toList();
        posts =
            jsonMembers.map<Posting>((json) => Posting.fromJson(json)).toList();
      });
      return posts;
    } else {
      print("status code: " + response.statusCode.toString());
      throw Exception('failed to get all user posts info');
    }
  }

  void fetchUsers(email) async {
    print("email: " + email);
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
      print(response.body);
      print(jsonMembers);
      if (jsonMembers != null) {
        setState(() {
          friends = (jsonMembers as List).map((e) => e as String).toList();
        });
        // if (friends != null) {
        //   print("ffffffffffffffffff" + friends!.length.toString());
        // }
      }
    } else {
      print("status code: " + response.statusCode.toString());
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
    print(s);
    return FileImage(File(s));
  }

  Widget _buildPost(String time, String image, String title, String content,
      String name, int likes, String pid, context) {
    // String uname = "";
    // getDiaplayName(name).then((String result) {
    //   setState(() {
    //     uname = result;
    //   });
    // });
    var itemsInMenu = [
      DropdownMenuItem(
        value: 1,
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: () {
                print("update");
              },
              color: Colors.transparent,
              icon: const Icon(
                Icons.update,
                size: 35.0,
                color: Colors.black,
              ),
              padding: EdgeInsets.only(right: 10.0),
            ),
            TextButton(
              // style: TextButton.styleFrom(primary: Colors.black),
              onPressed: () async {
                print("update");
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
                      print("Trying to delete");
                    },
                  );
                  // set up the AlertDialog
                  AlertDialog alert = AlertDialog(
                    title: Text("Are you sure?"),
                    content: Text("This forum will be deleted permanently."),
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
                    print("Trying to delete");
                  },
                );
                // set up the AlertDialog
                AlertDialog alert = AlertDialog(
                  title: Text("Are you sure?"),
                  content: Text("This forum will be deleted permanently."),
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
              onPressed: () async {
                print("report content");
              },
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
                print("report content");
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
                    ),
                    subtitle: Text(time),
                    trailing: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            icon: const Icon(
                              Icons.menu,
                              size: 35.0,
                              color: Colors.black,
                            ),
                            items: itemsInMenu,
                            // onTap: () => print("Menu pressed"),
                            onChanged: (value) {})),
                  ),
                  InkWell(
                    onDoubleTap: () => print('Like post'),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => ViewPostScreen(
                      //       post: posts[0],
                      //     ),
                      //   ),
                      // );
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
                                //       likes++;
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
                                  circleColor: CircleColor(
                                      start: Color(0xff00ddff),
                                      end: Color(0xff0099cc)),
                                  bubblesColor: BubblesColor(
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
                                  likeCount: 0,
                                  onTap: onLikeButtonTapped,
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
                                  },
                                ),
                                const Text(
                                  '0',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
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
  Future<void> initPlatform() async{
    print('entering onesignal');

    await OneSignal.shared.setAppId("68f951ef-3a62-4c97-89dc-7ef962b29bc6");
    await OneSignal.shared.getDeviceState().then((value) => {
      print(value?.userId)
    });
    print('exiting onesignal');
  }
  Future<bool> onLikeButtonTapped(bool isLiked) async {
    /// send your request here
    // final bool success= await sendRequest();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;

    return !isLiked;
  }

  int _index = 0;
  @override
  Widget build(BuildContext context) {
    // screenwidth = MediaQuery.of(context).size.width;
    // screenheight = MediaQuery.of(context).size.height;

    Widget child = Container();

    switch (_index) {
      case 0:
        child = _postHome();
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
                  final NewPost _post = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageFromGalleryEx()));
                  // await GetRequest();
                  //TODO: Post real data
                  setState(() {
                    // Posting latestpost = serverposts[serverposts.length - 1];
                    // String pid = latestpost.pid;
                    // int numlikes = latestpost.likes;

                    // int l = serverposts.length - 1;
                    // Posting p_more = serverposts[];
                    p = _buildPost(_post.timeAgo, _post.imageUrl, _post.title,
                        _post.content, _name, 0, '', context);
                    SinglePost sp = SinglePost('', 0, p);
                    ps.add(sp);
                    // l = getPostWidgets();
                  });
                },
                // onPressed: () async {
                //   // _timer?.cancel();
                //   // await EasyLoading.show(
                //   //   status: 'loading...',
                //   //   maskType: EasyLoadingMaskType.black,
                //   // );
                //   // print('EasyLoading show');
                //   var _post = await Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => ImageFromGalleryEx()));
                //   // EasyLoading.dismiss();
                //   if (_post != null) {
                //     setState(() {
                // p = _buildPost(_post.timeAgo, _post.imageUrl, _post.title,
                //     _post.content, _name, 0, '', context);
                //       Posting posting = Posting(
                //           title: _post.title,
                //           des: _post.content,
                //           imageUrl: _post.imageUrl,
                //           likes: 0,
                //           poster: _username,
                //           timestamp: _post.timeAgo);
                //       SinglePost sp = SinglePost(posting, p);
                //       ps.add(sp);
                //       l = getPostWidgets();
                //     });
                //   }
                // },
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

  Widget _postHome() {
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
                        SizedBox(
                          width: 35.0,
                          child: IconButton(
                            icon: const Icon(Icons.analytics_outlined),
                            iconSize: 30.0,
                            onPressed: () async {
                              // _timer?.cancel();
                              // await EasyLoading.show(
                              //   status: 'loading...',
                              //   maskType: EasyLoadingMaskType.black,
                              // );
                              // print('EasyLoading show');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                    //SelectUser(currentStudent: 'morrisjj'),
                                    FacultyHomescreen()
                                ),
                              );
                              // EasyLoading.dismiss();
                            }

                            // => print('Direct Messages')
                            ,
                          ),
                        ),
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
                              // print('EasyLoading show');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      SelectUser(currentStudent: 'morrisjj'),
                                      //FacultyHomescreen()
                                ),
                              );
                              // EasyLoading.dismiss();
                            }

                            // => print('Direct Messages')
                            ,
                          ),
                        ),

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
class SinglePost {
  String pid;
  int likes;
  Widget widget;
  SinglePost(this.pid, this.likes, this.widget);
}
