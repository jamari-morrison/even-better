import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:even_better/fb_services/auth.dart';
import 'package:even_better/post/feed_screen.dart';
import 'package:even_better/profile/profile_change.dart';
import 'package:even_better/profile/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:even_better/models/allusers.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'helpers/update_user_api.dart';

class ProfileApp extends StatefulWidget {
  const ProfileApp({Key? key}) : super(key: key);

  @override
  ProfileAppState createState() => ProfileAppState();
}

class ProfileAppState extends State<ProfileApp> {
  final AuthService _auth = AuthService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController postController = TextEditingController();
  final picker = ImagePicker();
  final user = FirebaseAuth.instance.currentUser;
  List<UserI> _users = <UserI>[];
  bool _update = false;
  File? _image;
  String _company = ' ';
  bool cs = false;
  bool se = false;
  bool ds = false;
  String _username = "";
  String _name = "";
  String? email;
  String? name;
  String _bio = ' ';
  Timer? _timer;

  // SizedBox sb = _noupdateProfile();
  ProfileAppState();
  Future<List<UserI>> fetchUsers() async {
    // var users = List<User>();
    List<UserI> users = <UserI>[];
    var url = 'http://10.0.2.2:3000/users/all';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonMembers = json.decode(response.body);
      setState(() {
        users = jsonMembers.map<UserI>((json) => UserI.fromJson(json)).toList();
      });
      return users;
    } else {
      print("status code: " + response.statusCode.toString());
      throw Exception('failed to get all user info');
    }
  }

  //ProfileAppState();
  @override
  void initState() {
    super.initState();
    fetchUsers().then((value) {
      _users.addAll(value);
    });
    initialName();
  }

  // final FirebaseAuth _fireauth = FirebaseAuth.instance;
  initialName() async {
    User? user = FirebaseAuth.instance.currentUser;
    email = user?.email;
    if (email != null) {
      _username = email!;
    }
  }

  void getUser() {
    for (var uuu in _users) {
      if (uuu.username == _username) {
        setState(() {
          _name = uuu.name;
          cs = uuu.cs;
          ds = uuu.ds;
          se = uuu.se;
          _company = uuu.companyname;
          _bio = uuu.bio;
          if (uuu.avatar != "") {
            _image = File(uuu.avatar);
          }
        });
      }
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery(context);
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      _imgFromCamera(context);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    fetchUsers();
    getUser();
    final double screenwidth = MediaQuery.of(context).size.width;
    final double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: const Color(0xFFE0E0E0),
      appBar: AppBar(
        title: const Text(
          'Even Better',
          style: TextStyle(
            fontFamily: 'Billabong',
            fontSize: 35.0,
            color: CompanyColors.red,
          ),
        ),

        //<Widget>[]
        backgroundColor: const Color(0xFFEDF0F6),
        elevation: 20.0,
        //IconButton
        brightness: Brightness.dark,
        actions: <Widget>[
          FlatButton.icon(
              label: const Text(''),
              icon: const Icon(Icons.settings),
              onPressed: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Settings(_auth)));
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                width: double.infinity,
                height: 250.0,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Color(0xffFFDCDC), Color(0xFF6440FF)],
                )),
                child: Container(
                  width: double.infinity,
                  height: 200.0,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          height: 8.0,
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              _showPicker(context);
                            },
                            child: CircleAvatar(
                              radius: 55,
                              backgroundColor: CompanyColors.red[30],
                              child: _image != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.file(
                                        _image!,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      width: 100,
                                      height: 100,
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Username: " + _username,
                              style: TextStyle(
                                fontFamily: 'EB',
                                fontSize: screenwidth * 0.055,
                                color: Colors.white,
                              ),
                            ),
                            // IconButton(
                            //   icon: const Icon(
                            //     Icons.edit_rounded,
                            //     color: Colors.white,
                            //   ),
                            //   onPressed: () => setState(() {
                            //      sb = _updateProfile();
                            //   }),
                            // ),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 0.0),
                          clipBehavior: Clip.antiAlias,
                          color: Colors.white,
                          elevation: 5.0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenwidth * 0.005,
                                vertical: screenheight * 0.0001),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Posts",
                                        style: TextStyle(
                                          fontFamily: 'EB',
                                          color: CompanyColors.red[300],
                                          fontSize: screenwidth / 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 2.0,
                                      ),
                                      Text(
                                        "1",
                                        style: TextStyle(
                                          fontFamily: 'EB',
                                          fontSize: screenwidth / 22,
                                          color: CompanyColors.red[300],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Followers",
                                        style: TextStyle(
                                          fontFamily: 'EB',
                                          color: CompanyColors.red[300],
                                          fontSize: screenwidth / 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 2.0,
                                      ),
                                      Text(
                                        "20",
                                        style: TextStyle(
                                          fontFamily: 'EB',
                                          fontSize: screenwidth / 22.0,
                                          color: CompanyColors.red[300],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Follow",
                                        style: TextStyle(
                                          fontFamily: 'EB',
                                          color: CompanyColors.red[300],
                                          fontSize: screenwidth / 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 2.0,
                                      ),
                                      Text(
                                        "10",
                                        style: TextStyle(
                                          fontFamily: 'EB',
                                          fontSize: screenwidth / 22.0,
                                          color: CompanyColors.red[300],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Company",
                                        style: TextStyle(
                                          fontFamily: 'EB',
                                          color: CompanyColors.red[300],
                                          fontSize: screenwidth / 20.0,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 2.0,
                                      ),
                                      Text(
                                        _company,
                                        style: TextStyle(
                                          fontFamily: 'EB',
                                          fontSize: screenwidth / 22.0,
                                          color: CompanyColors.red[300],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(children: <Widget>[
                      Text(
                        'Major(s): ',
                        style: TextStyle(
                            color: CompanyColors.red[300],
                            fontFamily: 'EBI',
                            fontSize: 20.0),
                      ),
                      Text(
                        _major(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'EB',
                          color: Colors.black87,
                          letterSpacing: 1.0,
                        ),
                      )
                    ]),
                    Row(children: <Widget>[
                      Text(
                        'Name: ',
                        style: TextStyle(
                            color: CompanyColors.red[300],
                            fontFamily: 'EBI',
                            fontSize: 20.0),
                      ),
                      Text(
                        _name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'EB',
                          color: Colors.black87,
                          letterSpacing: 1.0,
                        ),
                      )
                    ]),
                    Row(children: <Widget>[
                      Text(
                        'Bio: ',
                        style: TextStyle(
                            color: CompanyColors.red[300],
                            fontFamily: 'EBI',
                            fontSize: 20.0),
                      ),
                      Text(
                        _bio,
                        // 'I have graduated from Rose-Hulman CS major for 10 years. If you need any mobile app for your company then contact me for more informations.'
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'EB',
                          color: Colors.black87,
                          letterSpacing: 1.0,
                        ),
                      )
                    ]),
                  ],
                ),
              ),
            ),
            // sb
            _updateProfile()
          ],
        ),
      ),
    );
  }

  String _major() {
    String str = '';
    if (cs) {
      str = str + 'CS,';
    }
    if (se) {
      str = str + 'SE,';
    }
    if (ds) {
      str = str + 'DS,';
    }
    if (str != null && str.isNotEmpty) {
      str = str.substring(0, str.length - 1);
    }
    return str;
  }

  void _awaitReturnValueFromSecondScreen(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    final Prof _r = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileUpdate(
            _company,
            _name,
            _bio,
            cs,
            se,
            ds,
          ),
        ));

    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      _company = _r.company!;
      _name = _r.name!;
      _bio = _r.bio!;
      cs = _r.cs!;
      se = _r.se!;
      ds = _r.ds!;
      _major();
    });
  }

  _imgFromCamera(context) async {
    final pickedImage = await picker.getImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        createAvatarUpdate(_image!.path, context);
      });
    }
  }

  _imgFromGallery(context) async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        createAvatarUpdate(_image!.path, context);
      });
    }
  }

  Widget _updateProfile() {
    return SizedBox(
      width: 150.00,
      height: 45,
      child: RaisedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileUpdate(
                  _company,
                  _name,
                  _bio,
                  cs,
                  se,
                  ds,
                ),
              ),
            );
            // _awaitReturnValueFromSecondScreen(context);
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
          elevation: 0.0,
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: <Color>[Color(0xff4F78FF), Color(0xffA8BCFE)]),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Container(
              constraints: BoxConstraints(maxWidth: 300.0, minHeight: 45.0),
              alignment: Alignment.center,
              child: const Text(
                "Update",
                style: TextStyle(
                  fontFamily: 'EB',
                  color: Colors.white,
                  fontSize: 26.0,
                ),
              ),
            ),
          )),
    );
  }
}

Widget _noupdateProfile() {
  return const SizedBox(
    width: 200.00,
  );
}
