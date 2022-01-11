import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  final String name;
  const Loading({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0.0,
          title: Text(name,
              style: const TextStyle(
                fontFamily: 'Billabong',
                fontSize: 30.0,
              )),
        ),
        body: Container(
          color: Colors.white,
          child: const Center(
            child: SpinKitFoldingCube(
              color: Colors.red,
              size: 50.0,
            ),
          ),
        ));
  }
}
