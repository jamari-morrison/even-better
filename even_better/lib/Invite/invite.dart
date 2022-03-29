import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Invite extends StatefulWidget {

  const Invite({
    required this.currentStudent,
    required this.year,
    Key? key,
  }) : super(key: key);
  final String currentStudent;
  final int year;

  @override
  State<Invite> createState() => _InviteState();
}

class _InviteState extends State<Invite> {
  List<Widget> itemsData = [];
  List<dynamic> itemStatuses = [];


  void  getItemData() async {

    final uri =
    Uri.https('api.even-better-api.com', '/students/list', {'year': widget.year.toString()});

    final response = await http.get(uri, headers: <String, String>{
         'Content-Type': 'application/json; charset=UTF-8',
       });


    List<dynamic> responseList = jsonDecode(response.body);

    List<Widget> listItems = [];
    List<dynamic> listStatuses = [];

    for(var student in responseList){
      var statusColor;
      var statusString = student['status'];
      if(statusString == 'joined') statusColor = Colors.green;
      else if(statusString == 'pending') statusColor = Colors.blue;
      else statusColor = Colors.red;

      listStatuses.add({'color': statusColor, 'text': statusString});
      setState(() {
        itemStatuses = listStatuses;
      });
    }
    for (var student in responseList) {
      listItems.add(ButtonWidget(data: student, currentStudent: "Jamari Morison",));
    }

    setState(() {
      itemsData = listItems;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        body: Container(

          child: Column(
            children: [
              Expanded(
              child: ListView.builder(
              itemCount: itemsData.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return itemsData[index];
                  }))

            ],
          )


    ));
  }

  @override
  void initState() {
    super.initState();
    getItemData();

  }
}










class ButtonWidget extends StatefulWidget {

  const ButtonWidget({Key? key, required this.data,required this.currentStudent}) : super(key: key);
  final dynamic data;
  final String currentStudent;


  @override
  _ButtonWidgetState createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  bool _clicked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 75,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.data["name"],
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                            widget.data["year"] +", "+ widget.data["major"],
                            style: TextStyle(fontSize: 17, color: Colors.grey)),
                        Padding(
                            padding: EdgeInsets.fromLTRB(174, 0, 0, 0),
                            child: ConstrainedBox(
                                constraints: BoxConstraints.tightFor(width: 88, height: 22),
                                child: ElevatedButton(
                                  onPressed: () async {

                                    if(widget.data['status'] == 'Invite' && !_clicked){


                                      final response = await http.post(
                                        Uri.parse(
                                            'https://api.even-better-api.com/students/invite'),
                                        headers: <String, String>{
                                          'Content-Type': 'application/json; charset=UTF-8',
                                        },
                                        body: jsonEncode(<String, String>{
                                          'inviter': widget.currentStudent,
                                          'name':  widget.data['name'],
                                          'rose-username': widget.data['rose-username'],
                                        }),
                                      );

                                      _clicked = true;
                                      setState((){});

                                    }

                                  },
                                  child: Text(_clicked ? 'pending' : widget.data["status"]),
                                  style: ElevatedButton.styleFrom(
                                    primary: _clicked || widget.data['status'] == 'pending' ? Colors.blue : (widget.data['status'] == 'invite' ? Colors.red : Colors.green),
                                  ),



                                )
                            )
                        )

                      ]

                  )],
              )
            ],
          ),
        ));
  }
}

