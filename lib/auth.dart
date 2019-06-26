import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'package:gatrabali/repository/subscriptions.dart';
import 'package:gatrabali/scoped_models/app.dart';
import 'package:gatrabali/models/user.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AppModel model;

  Auth(this.model);

  Future<User> googleSignIn() {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    return _googleSignIn.signIn().then((user) {
      return user.authentication;
    }).then((auth) {
      return GoogleAuthProvider.getCredential(
          idToken: auth.idToken, accessToken: auth.accessToken);
    }).then((credential) {
      return _auth.signInWithCredential(credential);
    }).then((firebaseUser) {
      return Auth.userFromFirebaseUser(firebaseUser);
    });
  }

  Future<User> facebookSignIn() {
    final _facebookSignin = FacebookLogin();
    return _facebookSignin.logInWithReadPermissions(['email']).then((result) {
      if (result.status == FacebookLoginStatus.cancelledByUser) {
        throw Exception('Facebook login cancelled');
      }
      if (result.status == FacebookLoginStatus.error) {
        throw Exception(result.errorMessage);
      }
      return FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token);
    }).then((credential) {
      return _auth.signInWithCredential(credential);
    }).then((firebaseUser) {
      return Auth.userFromFirebaseUser(firebaseUser);
    });
  }

  Future<User> currentUser() {
    return _auth.currentUser().then((firebaseUser) {
      if (firebaseUser == null) throw Exception('User not found');

      return Auth.userFromFirebaseUser(firebaseUser);
    });
  }

  Future<void> signOut() async {
    // Delete FCM token before logout
    try {
      final user = model.currentUser;
      if (user != null && user.fcmToken != null) {
        await SubscriptionService.updateMessagingToken(user.id, user.fcmToken,
            delete: true);
      }
    } catch (err) {
      print(err);
    } finally {
      await _auth.signOut();
    }
    return;
  }

  static User userFromFirebaseUser(FirebaseUser firebaseUser) {
    return User(
        id: firebaseUser.uid,
        name: firebaseUser.displayName,
        provider: firebaseUser.providerId,
        avatar: firebaseUser.photoUrl);
  }

  static void onAuthStateChanged(Function callback) {
    FirebaseAuth.instance.onAuthStateChanged.listen((firebaseUser) {
      if (firebaseUser == null) {
        callback(null);
      } else {
        callback(Auth.userFromFirebaseUser(firebaseUser));
      }
    });
  }
}
