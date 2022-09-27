import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monitor_lizard/providers/AuthProvider.dart';
import 'package:monitor_lizard/screens/BottomTabNav.dart';
import 'package:monitor_lizard/screens/SignIn.dart';
import 'package:monitor_lizard/screens/SignUp1.dart';
import 'package:monitor_lizard/screens/SignUp2.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String authState = Provider.of<AuthProvider>(context).authState;
    User? currentUser = FirebaseAuth.instance.currentUser;

    if ((currentUser != null && currentUser.displayName == "") ||
        authState == "signUp2") {
      return const SignUp2();
    } else if (currentUser != null) {
      print(currentUser);
      return const BottomTabNav();
    } else if (authState == "signUp1") {
      return const SignUp1();
    } else if (authState == "signIn") {
      return const SignIn();
    } else {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }
}
