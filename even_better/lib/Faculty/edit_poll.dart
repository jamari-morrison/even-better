import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class EditPoll extends StatefulWidget {
  const EditPoll({
    required this.isEdit,
    required this.startingOptions,
    required this.startingQuestion,
    required this.startingQuota,
    required this.startingPriority,
    required this.id,
    Key? key,
  }) : super(key: key);
  final bool isEdit;
  final List<String> startingOptions;
  final String startingQuota;
  final String startingPriority;
  final String startingQuestion;
  final String id;

  @override
  State<EditPoll> createState() => _EditPollState();

}

class _EditPollState extends State<EditPoll> {
  List<Widget> itemsData = [];
  Timer? _timer;
  int  _screen = 0;
  final _questionController = TextEditingController();
  final _quotaController = TextEditingController();
  final _priorityController = TextEditingController();
  List<TextEditingController> optionControllers = [];

  void initEdit(){
    //TODO: fill out these two variables
    //TODO: after that, last frontend-only thing to do is to enable notifications
    //TODO: then it's just endpoint integration :D

    List<Widget> oldOptions = [];
    List<TextEditingController> oldOptionControllers = [];
    int i = 1;
    for(String o in widget.startingOptions){
      String itemStr = "Option "+i.toString();
      TextEditingController tempController = TextEditingController();
      oldOptionControllers.add(tempController);
      tempController.text = o;
      oldOptions.add(TextFormField(
        controller: tempController,
        decoration:  InputDecoration(
          border: UnderlineInputBorder(),
          labelText: itemStr,
        ),
      ) );
    }

    setState(() {
      _questionController.text = widget.startingQuestion;
      _quotaController.text = widget.startingQuota;
      _priorityController.text = widget.startingPriority;
      optionControllers= oldOptionControllers;
      itemsData=oldOptions;
    });
  }
  void getItemData() {

      int itemCount = itemsData.length+1;
    String itemStr = 'Option '+itemCount.toString();
    final newController = TextEditingController();
      //listItems.add(
          Widget newField = TextFormField(
        controller: newController,
        decoration:  InputDecoration(
          border: UnderlineInputBorder(),
          labelText: itemStr,
        ),
      );

      //);


    setState(() {
      //itemsData = listItems;
      itemsData.add(newField);
      optionControllers.add(newController);

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

  Future<void>  sendData() async {
    List<String> options = [];

    for(TextEditingController tc in optionControllers){
      options.add(tc.text);
    }
    print(jsonEncode(<String, String>{
      'question': _questionController.text,
      'priority': _priorityController.text,
      'options': options.toString(),
      'quota': _quotaController.text,
      '_id': widget.id,
    }));
    String url;
    // if(widget.isEdit) url = 'https://api.even-better-api.com/popups/edit';
    //   else url = 'https://api.even-better-api.com/popups/create';
    if(widget.isEdit) url = 'http://10.0.2.2:3000/popups/edit';
    else url = 'http://10.0.2.2:3000/popups/create';

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'question': _questionController.text,
        'priority': _priorityController.text,
        'options': jsonEncode(options),
        'quota': _quotaController.text,
        '_id': widget.id,
      }),
    );
    print(response.body);
  }
   @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _screen == 0 ? Container(
            child: Column(
              children: [
                Text("Create New Poll"),
            TextFormField(
              controller: _questionController,
            decoration: const InputDecoration(
            border: UnderlineInputBorder(),
          labelText: 'Poll question',
        ),
    )
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
                    child: Text("Add Option"),
                    onPressed: () async {getItemData();}),
                ElevatedButton(
                    child: Text("Remove Option"),
                    onPressed: () async {removeItemData();}),
                ElevatedButton(
                    child: Text("Next"),
                    onPressed: () async {
                      _screen = 1;
                      setState(() {

                      });
                    })

              ],
            )):
        Container(
            child: Column(
              children: [
                Text("Create New Poll"),
                TextFormField(
                  controller: _priorityController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Priority (range: 1 - 1000)',
                    helperText: 'Priority determines the order in which polls are shown. The lower the number, the sooner the poll will be shown to students.'
                  ),
                )
                ,
                TextFormField(
                  controller: _quotaController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Quota',
                    helperText: 'Quota determines how many responses the poll will require before it is taken out of circulation.'
                  ),
                ),
                ElevatedButton(
                    child: Text("go back"),
                    onPressed: () async {
                      setState(() {
                        _screen=0;
                      });
                    }),
                ElevatedButton(
                    child: Text(widget.isEdit ? "Update" : "Create"),
                    onPressed: () async {
                      print('creating');
                      sendData();
                      Navigator.pop(context);
                    })

              ],
            ))
    );
  }

  @override
  void initState() {
    super.initState();
    if(widget.isEdit){
      initEdit();
    }
    else getItemData();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    EasyLoading.showSuccess('Loading Succeeded');
  }
}
