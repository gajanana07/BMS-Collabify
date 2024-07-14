import 'package:classico/dashboard.dart';
import 'package:classico/firebase_options.dart';
import 'package:classico/onboard.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            home: const AuthWrapper(),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

// ignore: non_constant_identifier_names
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          return const DashboardScreen(); // The screen you want to show when logged in
        }
        return const Onboard(); // The login screen
      },
    );
  }
}
