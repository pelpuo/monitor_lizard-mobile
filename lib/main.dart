import 'package:flutter/material.dart';
import 'package:monitor_lizard/providers/AttendanceProvider.dart';
import 'package:monitor_lizard/providers/AuthProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:monitor_lizard/screens/AccountDetails.dart';
import 'package:monitor_lizard/screens/AuthWrapper.dart';
import 'package:monitor_lizard/screens/BottomTabNav.dart';
import 'package:monitor_lizard/screens/Home.dart';
import 'package:monitor_lizard/screens/SignUp1.dart';
import 'package:monitor_lizard/screens/SignUp2.dart';
import 'package:monitor_lizard/services/authService.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AttendanceProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Cardio AI",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}
