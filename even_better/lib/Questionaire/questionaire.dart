import 'package:even_better/Invite/invite_year.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:provider/provider.dart';

import 'MultipleNotifier.dart';
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
  final List<String> countries = [
    'React',
    'Flutter',
    'Node.js',
    'Express',
    'Vue',
    'Mongoose',
    'Angular'
  ];

  @override
  Widget build(BuildContext context) {
    final _multipleNotifier = Provider.of<MultipleNotifier>(context);

    return (Center(
        child: ListView(
            children: ListTile.divideTiles(context: context, tiles: [
      AlertDialog(
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
      )
      // ListTile(
      //   title: Text('Single choice Dialog'),
      //   onTap: () => _showMultiChoiceDialog(context),
      // )
    ]).toList())));
  }

  @override
  void initState() {
    super.initState();
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
