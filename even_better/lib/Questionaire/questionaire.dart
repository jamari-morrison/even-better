import 'package:even_better/Invite/invite_year.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../Chat/select_user.dart';
import 'multiple_notifier.dart';
import 'SingleNotifier.dart';
import '../post/feed_screen.dart';

class Questionaire extends StatefulWidget {
  const Questionaire({
    required this.currentStudent,
    Key? key,
  }) : super(key: key);
  final String currentStudent;

  @override
  State<Questionaire> createState() => _QuestionaireState();
}

class _QuestionaireState extends State<Questionaire> {
<<<<<<< HEAD
  List<dynamic> countries = [];
  String questionTitle = '';
=======
  List<dynamic> countries = [
    'React',
    'Flutter',
    'Node.js',
    'Express',
    'Vue',
    'Mongoose',
    'Angular'
  ];
  String questionTitle = 'Original';
>>>>>>> 26c99286396118278c507269a6e9814957e70e1a
  String questionID = 'empty';

  void getPopupData() async {
    final uri = Uri.http('10.0.2.2:3000', '/popups/nextQuestion',
        {'rose-username': widget.currentStudent.toString()});

    final response = await http.get(uri, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    print(response.body);

    final responseData = jsonDecode(response.body);
    print(responseData['message']);
    if (responseData['message'] == 'has question') {
      setState(() {
        countries = responseData['question']['options'];
        questionTitle = responseData['question']['question'];
        questionID = responseData['question']['_id'];
      });
    } else {
      //redirect to dm's here :D
<<<<<<< HEAD
      print('nothing to show');
=======
>>>>>>> 26c99286396118278c507269a6e9814957e70e1a
    }
  }

  void sendPopupData(List<String> selections) async {
<<<<<<< HEAD
    print(jsonEncode(<String, String>{
      'questionID': questionID.toString(),
      'answerer': widget.currentStudent.toString(),
      'answer': jsonEncode(selections),
    }).toString());
=======
    print(jsonEncode(selections));
    print(jsonEncode(<String, String>{
      'questionID': widget.currentStudent,
      'answerer': widget.currentStudent.toString(),
      'answer': selections.toString(),
    }.toString()));
>>>>>>> 26c99286396118278c507269a6e9814957e70e1a
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/popups/answer'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'questionID': questionID.toString(),
        'answerer': widget.currentStudent.toString(),
<<<<<<< HEAD
        'answer': jsonEncode(selections),
=======
        'answer': selections.toString(),
>>>>>>> 26c99286396118278c507269a6e9814957e70e1a
      }),
    );
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    final _multipleNotifier = Provider.of<MultipleNotifier>(context);

    return (Center(
        child: true
            ? ListView(
                children: ListTile.divideTiles(context: context, tiles: [
                AlertDialog(
                  title: Text(questionTitle),
                  content: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: countries
                            .map((e) => CheckboxListTile(
                                  title: Text(e),
                                  value: _multipleNotifier.isHaveItem(e),
                                  onChanged: (value) {
                                    value!
                                        ? _multipleNotifier.addItem(e)
                                        : _multipleNotifier.removeItem(e);
                                  },
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  actions: [
                    FlatButton(
                      child: Text("Submit"),
                      onPressed: () {
                        sendPopupData(_multipleNotifier.selectedItems);
                        //Navigator.of(context).pop();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => FeedScreen()));
                      },
                    ),
                  ],
                )
                // ListTile(
                //   title: Text('Single choice Dialog'),
                //   onTap: () => _showMultiChoiceDialog(context),
                // )
              ]).toList())
            : Text('joe')));
  }

  @override
  void initState() {
    super.initState();
    getPopupData();
  }

  _showMessageDialog(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Are you sure"),
          content: Text("Do you want to delete these items?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );

  _showSingleChoiceDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) {
        var _singleNotifier = Provider.of<SingleNotifier>(context);
        return AlertDialog(
            title: Text("Select one country"),
            content: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: countries
                      .map((e) => RadioListTile<String>(
                            title: Text(e),
                            value: e,
                            groupValue: _singleNotifier.currentCountry,
                            selected: _singleNotifier.currentCountry == e,
                            onChanged: (value) {
                              if (value != _singleNotifier.currentCountry) {
                                _singleNotifier.updateCountry(value.toString());
                                Navigator.of(context).pop();
                              }
                            },
                          ))
                      .toList(),
                ),
              ),
            ));
      });

  _showMultiChoiceDialog(BuildContext context) => showDialog(
        context: context,
        builder: (context) {
          final _multipleNotifier = Provider.of<MultipleNotifier>(context);
          return AlertDialog(
            title: Text("What frameworks do you use? (select all that apply)"),
            content: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: countries
                      .map((e) => CheckboxListTile(
                            title: Text(e),
                            value: _multipleNotifier.isHaveItem(e),
                            onChanged: (value) {
                              value!
                                  ? _multipleNotifier.addItem(e)
                                  : _multipleNotifier.removeItem(e);
                            },
                          ))
                      .toList(),
                ),
              ),
            ),
            actions: [
              FlatButton(
                child: Text("Submit"),
                onPressed: () {
                 // Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      SelectUser(currentStudent: 'morrisjj'),
                    ),
                  );
                  EasyLoading.dismiss();
                },
              ),
            ],
          );
        },
      );
}
