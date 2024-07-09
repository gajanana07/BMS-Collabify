import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var userName, emailName, emailValidate;

class GoogleSignInProvider extends ChangeNotifier {
  final GoogleSignIn googleSignIn;

  GoogleSignInProvider({required String clientId})
      : googleSignIn = GoogleSignIn(clientId: clientId);

  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;

  Future googleLogin() async {
    try {
      print('Attempting Google login...');
      final googleUser = await googleSignIn.signIn();
      print('Google user: $googleUser');
      if (googleUser == null) {
        print('User canceled the login');
        return;
      }

      _user = googleUser;
      print('Google user authenticated');

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Retrieve the user's details
      final firebaseUser = userCredential.user;
      print('Firebase user: $firebaseUser');
      userName = firebaseUser?.displayName;
      emailName = firebaseUser?.email;
      emailValidate = emailName?.split('.');

      print('User name: $userName');

      // Save user details to Firestore
      if (firebaseUser != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .set({
          'displayName': firebaseUser.displayName,
          'email': firebaseUser.email,
        });
      }

      notifyListeners();
    } catch (error) {
      print('Google Sign-In error: $error');
    }
  }

  Future googleLogout() async {
    try {
      print('Logging out from Google...');
      await googleSignIn.disconnect();
      await FirebaseAuth.instance.signOut();
      _user = null; // Clear the user on logout
      print('Logout successful');
      notifyListeners();
    } catch (error) {
      print('Google Sign-Out error: $error');
    }
  }

  Future<void> signInSilently() async {
    try {
      print('Attempting silent sign-in...');
      final googleUser = await googleSignIn.signInSilently();
      print('Silent sign-in user: $googleUser');
      if (googleUser != null) {
        _user = googleUser;

        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);

        final firebaseUser = FirebaseAuth.instance.currentUser;
        if (firebaseUser != null) {
          userName = firebaseUser.displayName;
          emailName = firebaseUser.email;
          emailValidate = emailName?.split('.');

          print('User name: $userName');
          print('Email contains "cs": ${emailName?.contains("cs") ?? false}');
        }

        notifyListeners();
      }
    } catch (error) {
      print('Sign in silently failed: $error');
    }
  }
}
