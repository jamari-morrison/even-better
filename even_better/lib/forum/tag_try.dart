// import 'package:flutter/material.dart';
// import 'package:forum/forum/models/tag.dart';

// class createForum extends StatefulWidget {
//   @override
//   _createForumState createState() => _createForumState();
// }

// class _createForumState extends State<createForum> {
//   final _formKey = GlobalKey<FormState>();
//   String title = '';
//   String content = '';
//   List<Tag> addtags = [];
//   String newTag = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.red[400],
//           elevation: 0.0,
//           title: const Text('What do you think?'),
//         ),
//         body: SingleChildScrollView(
//             reverse: true,
//             child: Padding(
//                 padding: EdgeInsets.only(
//                     bottom: MediaQuery.of(context).viewInsets.bottom),
//                 child: Container(
//                     padding:
//                         EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
//                     child: Questionaire(
//                         key: _formKey, //keep track of the form
//                         child: Column(children: <Widget>[
//                           SizedBox(height: 20.0),
//                           TextFormField(
//                               decoration: const InputDecoration(
//                                 hintText: 'Enter title here',
//                               ),
//                               validator: (val) => val!.isEmpty
//                                   ? 'Enter your thoughts'
//                                   : null, //is valid if null
//                               onChanged: (val) {
//                                 setState(() => title = val);
//                               }),
//                           SizedBox(height: 40.0),
//                           TextFormField(
//                               decoration: const InputDecoration(
//                                 hintText: 'What do you think?',
//                               ),
//                               validator: (val) => val!.isEmpty
//                                   ? 'Enter your thoughts'
//                                   : null, //is valid if null
//                               onChanged: (val) {
//                                 setState(() => content = val);
//                               }),
//                           SizedBox(height: 40.0),
//                           Container(
//                               child: Column(
//                             children: <Widget>[
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: <Widget>[
//                                   Tag("Framework", "1"),
//                                   Tag("Company", "1"),
//                                   Tag("Project", "1")
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: <Widget>[
//                                   Tag("OO Design", "1"),
//                                   Tag("Java", "1"),
//                                   Tag("Flutter", "1"),
//                                   TextButton(
//                                     onPressed: () => showDialog(
//                                         context: context,
//                                         builder: (BuildContext context) {
//                                           return Dialog(
//                                             shape: RoundedRectangleBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(
//                                                         20.0)), //this right here
//                                             child: Container(
//                                               height: 200,
//                                               child: Padding(
//                                                 // key: _formKey,
//                                                 padding:
//                                                     const EdgeInsets.all(12.0),
//                                                 child: Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     const Text(
//                                                       "Creating New Tag",
//                                                       style: TextStyle(
//                                                           fontSize: 20,
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                     ),
//                                                     const SizedBox(
//                                                         height: 20.0),
//                                                     TextFormField(
//                                                         decoration:
//                                                             const InputDecoration(
//                                                                 border:
//                                                                     InputBorder
//                                                                         .none,
//                                                                 hintText:
//                                                                     "What's the new tag's name?"),
//                                                         validator: (val) => val!
//                                                                 .isEmpty
//                                                             ? 'Enter your thoughts'
//                                                             : null, //is valid if null
//                                                         onChanged: (val) {
//                                                           setState(() =>
//                                                               newTag = val);
//                                                         }),
//                                                     SizedBox(
//                                                       width: 320.0,
//                                                       child: FlatButton(
//                                                         onPressed: () {
//                                                           print(newTag);
//                                                         },
//                                                         child: const Text(
//                                                           "Create",
//                                                           style: TextStyle(
//                                                               color:
//                                                                   Colors.white),
//                                                         ),
//                                                         color: Colors.red,
//                                                       ),
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           );
//                                         }),
//                                     child: const Text("+",
//                                         style: TextStyle(color: Colors.black)),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           )),
//                           RaisedButton(
//                               color: Colors.red[400],
//                               child: const Text(
//                                 'Comment',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                               onPressed: () async {
//                                 if (_formKey.currentState!.validate()) {
//                                   print(title);
//                                   // TODO: implement submit comment
//                                 }
//                               }),
//                         ]))))));
//   }
// }
