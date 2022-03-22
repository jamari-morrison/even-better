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
    required this.id,
    Key? key,
  }) : super(key: key);

  final dynamic optionQuantities;
  final String currentAnswers;
  final String quota;
  final String question;
  final String priority;
  final String id;


  @override
  State<SpecificPoll> createState() => _SpecificPollState();

}

class _SpecificPollState extends State<SpecificPoll> {
  List<Widget> itemsData = [];
  List<dynamic> itemStatuses = [];
  Timer? _timer;
  List<String> optionList = [];
  int _screen = 0;
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
       //String? currString = widget.optionQuantities[option];
      // if(currString != null){
         //String tempStr = currString;
         int currAnswers = widget.optionQuantities[option];//int.parse(tempStr);

         double currPercentDouble = totalResponses == 0 ? 0 : currAnswers/totalResponses;
         int currPercent = (currPercentDouble*100).round();
         String thisOptionData = option + " - "+ currPercent.toString()+"%";

         listItems.add(Text(thisOptionData));
       //}

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

  void delete() async{
    //TODO:
    String url = 'http://10.0.2.2:3000/popups/delete';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        '_id': widget.id,
      }),
    );
    print(response);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  Container(
             child: _screen == 0 ? Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 20, 5, 10),
                  child:
                Text("Manage Poll - " + widget.question,style: TextStyle(fontSize: 20))),

        Padding(
          padding: EdgeInsets.fromLTRB(5, 20, 5, 10),
          child:
                Text('Total response  s: ' + widget.currentAnswers,style: TextStyle(fontSize: 15))),
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
            Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [

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
                              builder: (context) => EditPoll(isEdit: true, startingOptions: optionList, startingPriority: widget.priority, startingQuestion: widget.question, startingQuota: widget.quota, id: widget.id)));
                      EasyLoading.dismiss();                    }),
                ElevatedButton(
                    child: Text("Delete"),
                    onPressed: () async {
                        delete();
                        setState(() {
                          _screen = 1;
                        });
                                      })]),


              ],
            ) :  Center(child: Column(
        children: [
             Padding(
             padding: EdgeInsets.fromLTRB(0, 100, 0, 20),
               child:Text("Poll has been deleted.", style: TextStyle(fontSize: 20),)),

      ElevatedButton(
          child: Text("Acknowledge"),
          onPressed: () async {
            int count = 0;
            Navigator.of(context).popUntil((_) => count++ >= 2);          }),


      ],
    )))
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
