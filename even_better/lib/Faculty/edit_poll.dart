import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class EditPoll extends StatefulWidget {
  const EditPoll({
    Key? key,
  }) : super(key: key);

  @override
  State<EditPoll> createState() => _EditPollState();

}

class _EditPollState extends State<EditPoll> {
  List<Widget> itemsData = [];
  List<dynamic> itemStatuses = [];
  Timer? _timer;
  int  _screen = 0;

  void getItemData() {
    List<Widget> listItems = [];
    for(Widget w in itemsData){
      listItems.add(w);

    }

      int itemCount = listItems.length+2;
    String itemStr = 'Option '+itemCount.toString();
      listItems.add(TextFormField(
        decoration:  InputDecoration(
          border: UnderlineInputBorder(),
          labelText: itemStr,
        ),
      ));


    setState(() {
      itemsData = listItems;
      //print(listItems);
    });
  }

   @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: _screen == 0 ? Container(
            child: Column(
              children: [
                Text("Create New Poll"),
            TextFormField(
            decoration: const InputDecoration(
            border: UnderlineInputBorder(),
          labelText: 'Poll question',
        ),
    )
                ,
                TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Option 1',
                  ),
                ),
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
                    onPressed: () async {}),
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
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Priority (range: 1 - 1000)',
                    helperText: 'Priority determines the order in which polls are shown. The lower the number, the sooner the poll will be shown to students.'
                  ),
                )
                ,
                TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Quota',
                    helperText: 'Quota determines how many responses the poll will require before it is taken out of circulation.'
                  ),
                ),
                ElevatedButton(
                    child: Text("Create"),
                    onPressed: () async {
                      //TODO: put api sending logic hete
                      Navigator.pop(context);
                    })

              ],
            ))
    );
  }

  @override
  void initState() {
    super.initState();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    EasyLoading.showSuccess('Loading Succeeded');
  }
}
