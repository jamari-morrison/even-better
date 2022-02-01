import 'package:even_better/Invite/invite_year.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:provider/provider.dart';

import 'multiple_notifier.dart';
import 'SingleNotifier.dart';

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
  List<dynamic> countries = [
=======
  final List<String> countries = [
>>>>>>> 2c74c42b74c5e98eafad9d3a4b4766eb5bf13dd3
    'React',
    'Flutter',
    'Node.js',
    'Express',
    'Vue',
    'Mongoose',
    'Angular'
  ];
<<<<<<< HEAD
  String questionTitle = 'Original';
  String questionID = 'empty';

  void getPopupData() async{
  final uri =
  Uri.http('10.0.2.2:3000', '/popups/nextQuestion', {'rose-username': widget.currentStudent.toString()});

  final response = await http.get(uri, headers: <String, String>{
  'Content-Type': 'application/json; charset=UTF-8',
  });

  print(response.body);

  final responseData = jsonDecode(response.body);
  print(responseData['message']);
  if(responseData['message'] == 'has question'){
    setState(() {
      countries = responseData['question']['options'];
      questionTitle = responseData['question']['question'];
      questionID = responseData['question']['_id'];
    });
  }
  else{
    //redirect to dm's here :D
  }

}

void sendPopupData(List<String> selections) async{
    print(jsonEncode(selections));
    print(jsonEncode(<String, String>{
      'questionID': widget.currentStudent,
      'answerer':  widget.currentStudent.toString(),
      'answer': selections.toString(),
    }.toString()));
  final response = await http.post(
    Uri.parse(
        'http://10.0.2.2:3000/popups/answer'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'questionID': widget.currentStudent,
      'answerer':  widget.currentStudent.toString(),
      'answer': selections.toString(),
    }),
  );
  print(response.body);

}

=======
>>>>>>> 2c74c42b74c5e98eafad9d3a4b4766eb5bf13dd3

  @override
  Widget build(BuildContext context) {
    final _multipleNotifier = Provider.of<MultipleNotifier>(context);

    return (Center(
<<<<<<< HEAD
        child: true ? ListView(
            children: ListTile.divideTiles(context: context, tiles: [
      AlertDialog(
        title: Text(questionTitle),
=======
        child: ListView(
            children: ListTile.divideTiles(context: context, tiles: [
      AlertDialog(
        title: Text("What frameworks do you use? (select all that apply)"),
>>>>>>> 2c74c42b74c5e98eafad9d3a4b4766eb5bf13dd3
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
<<<<<<< HEAD
              sendPopupData(_multipleNotifier.selectedItems);
=======
>>>>>>> 2c74c42b74c5e98eafad9d3a4b4766eb5bf13dd3
              Navigator.of(context).pop();
            },
          ),
        ],
      )
      // ListTile(
      //   title: Text('Single choice Dialog'),
      //   onTap: () => _showMultiChoiceDialog(context),
      // )
<<<<<<< HEAD
    ]).toList()) : Text('joe')));
=======
    ]).toList())));
>>>>>>> 2c74c42b74c5e98eafad9d3a4b4766eb5bf13dd3
  }

  @override
  void initState() {
    super.initState();
    getPopupData();

<<<<<<< HEAD
  }

=======
>>>>>>> 2c74c42b74c5e98eafad9d3a4b4766eb5bf13dd3
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
                      .map((e) => RadioListTile(
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
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
}
