import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:gatrabali/models/user.dart';

abstract class BaseAuth {
  Future<User> signIn();
  Future<User> currentUser();
  Future<void> signOut();
  String provider;
}

class GoogleAuth implements BaseAuth {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String provider = 'google';

  @override
  Future<User> signIn() {
    return _googleSignIn.signIn().then((user) {
      return user.authentication;
    }).then((auth) {
      return GoogleAuthProvider.getCredential(
          idToken: auth.idToken, accessToken: auth.accessToken);
    }).then((credential) {
      return _auth.signInWithCredential(credential);
    }).then((firebaseUser) {
      return User(
          id: firebaseUser.uid,
          name: firebaseUser.displayName,
          provider: provider);
    });
  }

  @override
  Future<User> currentUser() {
    return _auth.currentUser().then((firebaseUser) {
      if (firebaseUser == null) throw Exception('User not found');

      return User(
          id: firebaseUser.uid,
          name: firebaseUser.displayName,
          provider: provider);
    });
  }

  @override
  Future<void> signOut() {
    return _auth.signOut();
  }
}
