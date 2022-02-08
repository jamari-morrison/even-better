import 'package:even_better/profile/moderator/view_reports.dart';
import 'package:flutter/material.dart';

class Moderator extends StatelessWidget {
  const Moderator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Moderator Control",
            style: TextStyle(
              fontFamily: 'Billabong',
              fontSize: 35.0,
            )),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
        child: ListView(
          // physics: const NeverScrollableScrollPhysics(),
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ViewReports()));
                },
                child: Text('view reports'))
          ],
        ),
      ),
    );
  }
}
