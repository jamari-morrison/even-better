import 'dart:async';
import 'dart:io';
import 'package:even_better/Chat/select_user.dart';
import 'package:even_better/Search/searchpage.dart';
import 'package:even_better/forum/data.dart';
import 'package:even_better/forum/forum.dart';
import 'package:even_better/screens/api.dart';
import 'package:even_better/screens/my_flutter_app_icons.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meta/meta.dart';
import 'package:even_better/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:even_better/models/post_model.dart';
import 'package:even_better/post/addpost.dart';
import 'package:even_better/post/view_post_screen.dart';
import 'package:like_button/like_button.dart';

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
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // EasyLoading.addStatusCallback((status) {
    //   print('EasyLoading Status $status');
    //   if (status == EasyLoadingStatus.dismiss) {
    //     _timer?.cancel();
    //   }
    // });
    // EasyLoading.showSuccess('Loading Successed');
    // EasyLoading.removeCallbacks();
  }

  Image getAvatorImage() {
    return Image(
      height: 50.0,
      width: 50.0,
      image: AssetImage(posts[0].authorImageUrl),
      fit: BoxFit.cover,
    );
  }

  FileImage getPostImage(String s) {
    print(s);
    return FileImage(File(s));
  }

  Widget _buildPost(String time, String image, String title, String content,
      String username, int likes, String pid) {
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
                        child: ClipOval(child: getAvatorImage()),
                      ),
                    ),
                    title: Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(time),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_horiz),
                      color: Colors.black,
                      onPressed: () => print('More'),
                    ),
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
    Widget child = Container();

    switch (_index) {
      case 0:
        child = _postHome();
        break;
      case 1:
        child = MySearchPage();
        break;
      case 3:
        child = ForumListPage(Data([], [], []));
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
                // onPressed: () async {
                //   final NewPost _post = await Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => ImageFromGalleryEx()));
                //   // await GetRequest();
                //   //TODO: Post real data
                //   setState(() {
                //     // Posting latestpost = serverposts[serverposts.length - 1];
                //     // String pid = latestpost.pid;
                //     // int numlikes = latestpost.likes;

                //     // int l = serverposts.length - 1;
                //     // Posting p_more = serverposts[];
                //     p = _buildPost(_post.timeAgo, _post.imageUrl, _post.title,
                //         _post.content, _post.username, 0, pid);
                //     SinglePost sp = SinglePost(pid, numlikes, p);
                //     ps.add(sp);
                //     l = getPostWidgets();
                //   });
                // },
                onPressed: () async {
                  // _timer?.cancel();
                  // await EasyLoading.show(
                  //   status: 'loading...',
                  //   maskType: EasyLoadingMaskType.black,
                  // );
                  // print('EasyLoading show');
                  final NewPost _post = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageFromGalleryEx()));
                  // EasyLoading.dismiss();
                  setState(() {
                    p = _buildPost(_post.timeAgo, _post.imageUrl, _post.title,
                        _post.content, 'Jamari', 0, '');
                    SinglePost sp = SinglePost('', 0, p);
                    ps.add(sp);
                    l = getPostWidgets();
                  });
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

  Widget _postHome() {
    return ListView(
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
                        _timer?.cancel();
                        await EasyLoading.show(
                          status: 'loading...',
                          maskType: EasyLoadingMaskType.black,
                        );
                        print('EasyLoading show');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                SelectUser(currentStudent: "Jamari Morrison"),
                          ),
                        );
                        EasyLoading.dismiss();
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
        l,
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
                Displayingpost(ps).reversed.toList()));
  }

  List<Widget> Displayingpost(List<SinglePost> ls) {
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
  return Padding(
    padding: EdgeInsets.all(50.0),
    child: Container(
      width: double.infinity,
      height: 100.0,
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
          width: 300.0,
          height: 50.0,
          child: const Center(
            child: Text(
              'Create your first Post! :)',
              style: TextStyle(
                fontFamily: 'Billabong',
                fontSize: 30.0,
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
        'Hello World',
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

class SinglePost {
  String pid;
  int likes;
  Widget widget;
  SinglePost(this.pid, this.likes, this.widget);
}
