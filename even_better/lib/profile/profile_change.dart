import 'dart:async';

import 'package:even_better/post/feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:even_better/screens/api.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ProfileUpdate extends StatefulWidget {
  String _company = '';
  String _name = '';
  String _bio = '';
  bool cs = false;
  bool se = false;
  bool ds = false;

  ProfileUpdate(
    this._company,
    this._name,
    this._bio,
    this.cs,
    this.se,
    this.ds,
  );

  @override
  ProfileUpdateState createState() {
    return ProfileUpdateState(
        this._company, this._name, this._bio, this.cs, this.se, this.ds);
  }
}

class ProfileUpdateState extends State<ProfileUpdate> {
  final TextEditingController companyController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  String _company;
  String _name;
  String _bio;
  bool cs;
  bool se;
  bool ds;
  // Prof profile = new Prof();
  Timer? _timer;

  ProfileUpdateState(
      this._company, this._name, this._bio, this.cs, this.se, this.ds) {
    companyController.text = _company;
    nameController.text = _name;
    bioController.text = _bio;
  }
  // ProfileUpdateState();

  @override
  void initState() {
    super.initState();
    // EasyLoading.addStatusCallback((status) {
    //   print('EasyLoading Status $status');
    //   if (status == EasyLoadingStatus.dismiss) {
    //     _timer?.cancel();
    //   }
    // });
    // EasyLoading.showSuccess('Loading Succeeded');
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    companyController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Even Better',
          style: TextStyle(
            fontFamily: 'Billabong',
            fontSize: 35.0,
            color: CompanyColors.red,
          ),
        ),
        //<Widget>[]
        backgroundColor: Colors.grey[200],
        elevation: 50.0,
        //IconButton
        brightness: Brightness.dark,
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                child: ConstrainedBox(
                  constraints: BoxConstraints(),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      _companyTile(companyController),
                      SizedBox(height: 30),
                      _nameTile(
                        nameController,
                      ),
                      SizedBox(height: 30),
                      _bioTile(
                        bioController,
                      ),
                      SizedBox(height: 30),
                      _majorTile(),
                    ],
                  ),
                ),
              ),
              Container(
                width: 100.00,
                margin: EdgeInsets.all(25),
                child: TextButton(
                  child: Text(
                    'Update',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Festive',
                        color: Colors.white,
                        fontSize: 32.0),
                  ),
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(CompanyColors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                  onPressed: () async {
                    _timer?.cancel();
                    await EasyLoading.show(
                      status: 'updating...',
                      maskType: EasyLoadingMaskType.black,
                    );
                    print('EasyLoading updating profile');
                    _sendDataBack(context);
                    EasyLoading.dismiss();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _csTile() {
    return CheckboxListTile(
      shape: RoundedRectangleBorder(
          // borderRadius: BorderRadius.circular(16),
          ),
      tileColor: Colors.grey[200],
      title: Text("CS"),
      value: cs,
      onChanged: (newValue) {
        setState(() {
          cs = newValue!;
        });
      },
      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
    );
  }

  Widget _seTile() {
    return CheckboxListTile(
      shape: RoundedRectangleBorder(
          // borderRadius: BorderRadius.circular(16),

          ),
      tileColor: Colors.grey[200],
      title: Text("SE"),
      value: se,
      onChanged: (newValue) {
        setState(() {
          se = newValue!;
        });
      },
      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
    );
  }

  Widget _dsTile() {
    return CheckboxListTile(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(16), bottomLeft: Radius.circular(16)),
      ),
      tileColor: Colors.grey[200],
      title: Text("DS"),
      value: ds,
      onChanged: (newValue) {
        setState(() {
          ds = newValue!;
        });
      },
      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
    );
  }

  Widget _majorTile() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      ListTile(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(16), topLeft: Radius.circular(16)),
        ),
        tileColor: Colors.grey[200],
        leading: Icon(Icons.edit),
        title: Text(
          'Major(s)',
          style: TextStyle(
              fontFamily: 'EB',
              height: 2,
              color: Colors.grey[800],
              fontSize: 20.0),
        ),
      ),
      _csTile(),
      _seTile(),
      _dsTile()
    ]);
  }

  void _sendDataBack(BuildContext context) {
    String company = companyController.text;
    String name = nameController.text;
    String bio = bioController.text;
    Navigator.pop(context, Prof(company, name, bio, cs, se, ds));
  }
}

Widget _companyTile(TextEditingController companyController) {
  return ListTileTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: ListTile(
      tileColor: Colors.grey[200],
      leading: Icon(Icons.edit),
      title: Text(
        'Company',
        style: TextStyle(
            fontFamily: 'EB',
            height: 2,
            color: Colors.grey[800],
            fontSize: 20.0),
      ),
      subtitle: TextField(
        controller: companyController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter...',
        ),
        // decoration: InputDecoration(
        //   border: InputBorder.none,

        // ),
        //keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 1,
        maxLength: 9,
      ),
    ),
  );
}

Widget _nameTile(TextEditingController nameController) {
  return Column(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(16),
      // ),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          tileColor: Colors.grey[200],
          leading: Icon(Icons.edit),
          title: Text(
            'Name',
            style: TextStyle(
                fontFamily: 'EB',
                height: 2,
                color: Colors.grey[800],
                fontSize: 20.0),
          ),
          subtitle: TextField(
            controller: nameController,
            // decoration: InputDecoration(
            //   border: InputBorder.none,
            //   hintText: 'Enter...',
            // ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter...',
            ),
            //keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 2,
            maxLength: 26,
          ),
        ),
      ]);
}

Widget _bioTile(TextEditingController bioController) {
  return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
    ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      tileColor: Colors.grey[200],
      leading: Icon(Icons.edit),
      title: Text(
        'Bio',
        style: TextStyle(
            fontFamily: 'EB',
            height: 2,
            color: Colors.grey[800],
            fontSize: 20.0),
      ),
      subtitle: TextField(
        controller: bioController,
        // decoration: InputDecoration(
        //   border: InputBorder.none,
        //   hintText: 'Enter...',
        // ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter...',
        ),
        //keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 5,
        maxLength: 300,
      ),
    ),
  ]);
}

class Prof {
  String? company;
  String? name;
  String? bio;
  bool? cs;
  bool? se;
  bool? ds;
  Prof(this.company, this.name, this.bio, this.cs, this.se, this.ds);
}
