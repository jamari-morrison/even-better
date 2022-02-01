import 'package:even_better/UserVerification/Helpers/account_creation.dart';
import 'package:even_better/UserVerification/Helpers/labeled_text_field.dart';
import 'package:even_better/UserVerification/Signup/sign_up.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../Helpers/verification_rest_api.dart';

class ConfirmName extends StatefulWidget {
  final String roseUsername;
  const ConfirmName({required this.roseUsername, Key? key}) : super(key: key);

  @override
  State<ConfirmName> createState() => _ConfirmNameState();
}

class _ConfirmNameState extends State<ConfirmName> {
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    createAlbumConfirmName(widget.roseUsername).then((value) {
      //hopefully this makes the widget rebuild
      //does this work?
      nameController.text = value.name;
    }).catchError((err) {
      modalErrorHandler(err, context, "difficulty obtaining name");
      //what to do if there's an error here?
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyApp.appTitle),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            LabeledTextField(
                label: "What name do you go by?",
                textEditingController: nameController,
                isPassword: false,
                isSignUpPassword: false,
                onSubmit: () {}),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: ElevatedButton(
                  child: const Text(
                    'Submit name',
                    style: TextStyle(
                      fontFamily: 'EB',
                      fontSize: 25.0,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    //push the selected name to the user document
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUp(
                                roseUsername: widget.roseUsername,
                                name: nameController.text)));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
