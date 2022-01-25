import 'package:even_better/Invite/invite_year.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_multiselect/flutter_multiselect.dart';

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
  int tag = 1;
  List<String> users = [
    'News',
    'Entertainment',
    'Politics',
    'Automotive',
    'Sports',
    'Education',
    'Fashion',
    'Travel',
    'Food',
    'Tech',
    'Science',
  ];

  @override
  Widget build(BuildContext context) {
    return (MultiSelect(
      titleText: "What frameworks do you use?",
      validator: (value) {
        if (value == null) {
          return 'Please select one or more option(s)';
        }
      },
      errorText: 'Please select one or more option(s)',
      dataSource: [
        {
          "display": "F",
          "value": 1,
        },
        {
          "display": "Canada",
          "value": 2,
        },
        {
          "display": "India",
          "value": 3,
        },
        {
          "display": "United States",
          "value": 4,
        }
      ],
      textField: 'display',
      valueField: 'value',
      filterable: false,
      required: true,
      value: null,
      onSaved: (value) {
        print('The saved values are $value');
      },
    ));
  }

  @override
  void initState() {
    super.initState();
  }
}
