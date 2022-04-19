import 'package:even_better/UserVerification/Helpers/verification_rest_api.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:test/test.dart';
import 'dart:core';
import '../lib/UserVerification/Helpers/labeled_text_field.dart';
import '../lib/UserVerification/Helpers/verification_rest_api.dart' as restapi;

void main() {
  test('Valid password', () {
    expect("", listRequirements('thisIsAValidPassword?1'));
    //ensure that these invalid passwords produce a warning
    expect(true, listRequirements('invalid password') != "");
    expect(true, listRequirements('InvalidPassword') != "");
    expect(true, listRequirements('InvPs!1') != "");
    expect(true, listRequirements('InvalidPassword1234') != "");
  });
  //can add more tests after firebase calls work
  // test('sign up testing', () {
  //   Future<Album> testAl =
  //       createAlbumRegisterEB("testUsername", "testPassword1!", "roseUsrn");
  //   testAl.then((value) => {expect("roseUsrn", value.roseUsername)});
  // });
}
