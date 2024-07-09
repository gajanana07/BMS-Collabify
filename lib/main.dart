import 'package:classico/addProject.dart';
import 'package:classico/dashboard.dart';
import 'package:classico/firebase_options.dart';
import 'package:classico/login.dart';
import 'package:classico/message1.dart';
import 'package:classico/onboard.dart';
import 'package:classico/profile1.dart';
import 'package:classico/search3.dart';
import 'package:classico/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error initializing Firebase: ${snapshot.error}');
        } else if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'BMS-COLLABIFY',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: AuthWrapper(),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

// ignore: non_constant_identifier_names
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          return DashboardScreen(); // The screen you want to show when logged in
        }
        return Onboard(); // The login screen
      },
    );
  }
}
