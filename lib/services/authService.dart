import 'package:firebase_auth/firebase_auth.dart';
import 'package:monitor_lizard/models/Employee.dart';
import 'package:monitor_lizard/providers/AuthProvider.dart';
import 'package:provider/provider.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = "";

  // auth change user stream
  Stream<User?> get authStateChanges {
    return _auth.authStateChanges();
  }

  // Sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return result;
    } catch (e) {
      print(e.toString());
      return Null;
    }
  }

  // Sign Up with Email/Password
  Future<String> signUpWithEmailPassword(
      String? email, String? password) async {
    String errors = "Sign up Failed: Please check your internet connection";
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);
      errors = "";

      print("!#_____Signed Up_____#!");
      return errors;
    } on FirebaseAuthException catch (e) {
      errors = e.message.toString();
      // if (e.code == 'weak-password') {
      //   errors = 'The password provided is too weak.';
      // } else if (e.code == 'email-already-in-use') {
      //   errors = 'The account already exists for that email.';
      // }
      return errors;
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  // Sign In with Email/Password
  Future<String> signInWithEmailPassword(String email, String password) async {
    String errors = "Sign in Failed: Please check your internet connection";
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print("##################################################");
      print(userCredential);
      errors = "";

      print("!#_____Signed In_____#!");
      return errors;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      errors = e.message.toString();
      // if (e.code == 'user-not-found') {
      //   errors = 'No user found for that email.';
      // } else if (e.code == 'wrong-password') {
      //   errors = 'Wrong password provided for that user.';
      // }
      return errors;
    }
  }

  // Edit user credentials
  Future editCredentials(
      {String firstName = "", String lastName = "", String email = ""}) async {
    try {
      if (firstName != "" && lastName != "") {
        await _auth.currentUser?.updateDisplayName("$firstName $lastName");
      }
      if (email != "") {
        await _auth.currentUser?.updateEmail(email);
      }
      print("!#_____Credentials Edited_____#!");
    } catch (e) {
      return e.toString();
    }
  }

  // Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
