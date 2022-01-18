import 'package:firebase_auth/firebase_auth.dart';
import 'package:even_better/models/user.dart';

class AuthService {
  // instance of firebase authentication, use _auth to interact with firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // create user obj based on FirebaseUser, (return type was MyUser but can't accept null returns)
  MyUser? _userFromFirebase(User? user) {
    // !!!! The operand can't be null, so the condition is always true.
    if (user != null) {
      return MyUser(user.uid);
    } else {
      print('No user specified, shouldve returned null [_userFromFirebase]');
      return null;
    }
    // return (user != null) ? MyUser(uid: user.uid) : null;
    // print('MyUser created [_userFromFirebase]');
    // return MyUser(user.uid);
  }

  // auth change user stream:
  //  whenever a state change occure,
  //  returns: User object when signs in,
  //           null when signs out.

  String? get userEmail {
    return _auth.currentUser?.email;
  }

  Stream<MyUser?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebase(user));
  }

  // anonymous sign in
  // Future signInAnonymous() async {
  //   try {
  //     UserCredential cred =
  //         await _auth.signInAnonymously(); // return an auth result obj
  //     User? user = cred.user;
  //     return _userFromFirebase(user);
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String pw) async {
    try {
      UserCredential cred =
          await _auth.signInWithEmailAndPassword(email: email, password: pw);
      User? user = cred.user;
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future deleteAccount() async {
    try {
      return FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        //might need to reauthenticate here
        print(
            'The user must reauthenticate before this operation can be executed.');
      }
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String pw) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: pw);
      User? user = cred.user;
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
