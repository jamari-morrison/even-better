import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'edit_poll.dart';
import 'specific_poll.dart';
class ManagePolls extends StatefulWidget {
  const ManagePolls({
    Key? key,
  }) : super(key: key);

  @override
  State<ManagePolls> createState() => _ManagePollsState();

}

class _ManagePollsState extends State<ManagePolls> {
  List<Widget> pollWidgets = [];
  List<dynamic> pollData = [];
  Timer? _timer;


  void getPollData(){
    setState(() {
      pollData.add({
        'question': 'Test question',
        'optionQuantities': {
          'Option1': '150',
          'Option2': '50'
        },
        'currentAnswers': '200',
        'quota': '300',
        'priority': '1'
      });
    });

  }
  void createPollWidgets() {
    List<Widget> listItems = [];

    for (dynamic d in pollData) {
      print('look here');
      print(pollData);
      listItems.add(ElevatedButton(
          child: Text(d['question'].toString()),
          onPressed: () async {
            _timer?.cancel();
            await EasyLoading.show(
              status: 'loading...',
              maskType: EasyLoadingMaskType.black,
            );
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SpecificPoll(question: d['question'], optionQuantities: d['optionQuantities'],
                            currentAnswers: d['currentAnswers'],
                            quota: d['quota'], priority: d['priority'],)));
            EasyLoading.dismiss();
          }));



    }
    setState(() {
      pollWidgets = listItems;
      //print(listItems);
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        body: Container(
            child: Column(
              children: [
                ElevatedButton(
                    child: Text("Create New Poll"),
                    onPressed: () async {
                      _timer?.cancel();
                      await EasyLoading.show(
                        status: 'loading...',
                        maskType: EasyLoadingMaskType.black,
                      );
                      print('loading all students');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditPoll(isEdit: false, startingOptions: [], startingPriority: '', startingQuestion: '', startingQuota: '')));
                      EasyLoading.dismiss();
                    }),
                Text("Manage Existing Polls"),
                Expanded(
                    child: ListView.builder(
                        itemCount: pollWidgets.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          // print("printing");
                          // print(itemsData);
                          return pollWidgets[index];
                        }))
              ],
            )));
  }

  @override
  void initState() {
    super.initState();
    getPollData();
    createPollWidgets();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    EasyLoading.showSuccess('Loading Succeeded');
  }
}
