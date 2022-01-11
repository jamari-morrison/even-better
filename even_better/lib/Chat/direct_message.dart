import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
//import 'package:socket_io/socket_io.dart';
import 'package:socket_io_client/socket_io_client.dart';


String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}


class DirectMessage extends StatefulWidget {
  const DirectMessage({
    required this.currentStudent,
    required this.recipient,
    Key? key,
  }) : super(key: key);
  final String currentStudent;
  final String recipient;

  @override
  State<DirectMessage> createState() => _DirectMessageState();


}





class _DirectMessageState extends State<DirectMessage> {
  List<types.Message> _messages = [];
  final _user = const types.User(id: 'currentStudent');
  final _recipient = const types.User(id: 'recipient');
  Socket socket = io('http://10.0.2.2:3000', <String, dynamic>{'transports': ['websocket'], 'autoConnect': false});

  // IO.Socket socket = IO.io('http://10.0.2.2:3000', OptionBuilder()
  //     .setTransports(['websocket']) // for Flutter or Dart VM
  //     .disableAutoConnect()  // disable auto-connection
  //     .setExtraHeaders({'foo': 'bar'}) // optional
  //     .build());



  void getMessageHistory() async{
    final uri =
    Uri.http('10.0.2.2:3000', '/messages/conversation', {'sender': widget.currentStudent, 'recipient': widget.recipient});

    final response = await http.get(uri, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    print('got in');
    print(response.body);

    Map<String, dynamic> responseList = jsonDecode(response.body);

    for(var msg in responseList['messages']){
      final textMessage = types.TextMessage(
        author: msg['sender'] == widget.currentStudent ? _user : _recipient,
        createdAt: msg['timestamp'],
        id: msg['_id'],
        text: msg['text'],
      );

      _addMessage(textMessage);
    }


  }


  void _addMessage(types.Message message) {

    setState(() {
      _messages.insert(0, message);
    });
  }



  void _handleSendPressed(types.PartialText message) {


    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    socket.emit('fromClient', {
      'sender': widget.currentStudent,
      'recipient': widget.recipient,
      'text': message.text,
      'timestamp': textMessage.createdAt
    });

    _addMessage(textMessage);
  }

  void _handleGetMessage(String message) {
    print('handling get');
    print(message);
    final textMessage = types.TextMessage(
      author: _recipient,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message,
    );
    _addMessage(textMessage);
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: Text(widget.recipient), backgroundColor: Colors.purple,),
      body:
      SafeArea(
        bottom: false,
        child: Chat(
          messages: _messages,
          onSendPressed: _handleSendPressed,
          user: _user,
        ),
      ),
    );







  }

  @override
  void initState() {
    super.initState();
    getMessageHistory();
    socket.connect();
    print('START');


    socket.onConnect((_) {
      print('connect');
      socket.emit('init', {'userID': widget.currentStudent});
    });
    socket.on('event', (data) => print(data));
    socket.onDisconnect((_) => print('disconnect'));

    //TODO: get timestamp from server, don't make own
    //TODO: upload message id to server so they're the same (?)
    socket.on('fromServer', (_) => {_handleGetMessage(_.toString())});

  }

}



