import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'edit_poll.dart';

class SpecificPoll extends StatefulWidget {
  const SpecificPoll({
    required this.optionQuantities,
    required this.currentAnswers,
    required this. quota,
    required this.question,
    required this.priority,
    Key? key,
  }) : super(key: key);

  final Map<String, String> optionQuantities;
  final String currentAnswers;
  final String quota;
  final String question;
  final String priority;


  @override
  State<SpecificPoll> createState() => _SpecificPollState();

}

class _SpecificPollState extends State<SpecificPoll> {
  List<Widget> itemsData = [];
  List<dynamic> itemStatuses = [];
  Timer? _timer;
  List<String> optionList = [];

  void initOptionList(){
    List<String> tempList = [];
    for(String s in widget.optionQuantities.keys) tempList.add(s);

    setState(() {
      optionList = tempList;
    });
  }
  void prepStringNames(){
    int totalResponses = int.parse(widget.currentAnswers);
    List<Widget> listItems = [];
    for(String option in widget.optionQuantities.keys){
       print('now here');
       print(widget.optionQuantities[option]);
       String? currString = widget.optionQuantities[option];
       if(currString != null){
         int currAnswers = int.parse(currString);
         double currPercentDouble = currAnswers/totalResponses;
         int currPercent = (currPercentDouble*100).round();
         String thisOptionData = option + " - "+ currPercent.toString()+"%";

         listItems.add(Text(thisOptionData));
       }

    }

    setState(() {
      itemsData = listItems;
    });
  }

  void removeItemData() {
    List<Widget> listItems = [];
    for(Widget w in itemsData){
      listItems.add(w);
    }
    if(listItems.length != 0){
      listItems.removeLast();
    }
    setState(() {
      itemsData = listItems;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  Container(
            child: Column(
              children: [
                Text("Manage Poll - " + widget.question),
                Text('Total responses: ' + widget.currentAnswers),
                Text('Quota: '+ widget.quota)
                ,
                Expanded(
                    child: ListView.builder(
                        itemCount: itemsData.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          // print("printing");
                          // print(itemsData);
                          return itemsData[index];
                        })),
                ElevatedButton(
                    child: Text("Edit"),
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
                              builder: (context) => EditPoll(isEdit: true, startingOptions: optionList, startingPriority: widget.priority, startingQuestion: widget.question, startingQuota: widget.quota)));
                      EasyLoading.dismiss();                    }),


              ],
            ))
    );
  }

  @override
  void initState() {
    super.initState();
    prepStringNames();
    initOptionList();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    EasyLoading.showSuccess('Loading Succeeded');
  }
}
