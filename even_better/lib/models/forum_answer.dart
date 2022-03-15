// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Forum_Answer {
  // i didnt put fid because i think it will be linked thru the forum
  final String aid; //answer_id
  final String username; //author_id
  String text;
  int likes = 0;
  String timestamp;
  Forum_Answer(this.aid, this.username, this.text, this.timestamp) {
    // print('Forum Answer with uid: ${aid} [Forum_Answer]');
    // print('Forum Answer with answer: ${text} [Forum_Answer]');
  }

  void liked() {
    likes++;
    print('liked the answer');
  }
}

class ForumAnswer extends StatelessWidget {
  final Forum_Answer answers;
  ForumAnswer(this.answers);

  @override
  Widget build(BuildContext context) {
    // String timestring =
    //     DateFormat('yyyy-MM-dd kk:mm').format(answers.timestamp);
    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.red[200],
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.red[300],
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0)),
            ),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.person,
                  size: 50.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(answers.username),
                      Text(answers.timestamp),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(right: 5.0),
                        child: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.black,
                            ),
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
                                  // deleteForum(post.postId);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              );
                              AlertDialog alert = AlertDialog(
                                title: Text("Are you sure?"),
                                content: Text(
                                    "This forum will be deleted permanently."),
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
                            })),
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 8.0, left: 2.0),
                    //   child: Text(answers.likes.toString()),
                    // ),
                  ],
                )
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 2.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0))),
              child: Container(
                width: double.infinity,
                child: Text(answers.text),
              )),
        ],
      ),
    );
  }
}
