import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gatrabali/config.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'package:gatrabali/repository/subscriptions.dart';
import 'package:gatrabali/scoped_models/app.dart';
import 'package:gatrabali/models/user.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AppModel model;

  Auth(this.model);

  Future<User> anonymousSignIn() {
    return _auth.signInAnonymously().then((authResult) {
      return Auth.userFromFirebaseUser(authResult.user);
    });
  }

  Future<User> googleSignIn({bool linkAccount = false}) {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    return _googleSignIn.signIn().then((user) {
      return user.authentication;
    }).then((auth) {
      return GoogleAuthProvider.getCredential(
          idToken: auth.idToken, accessToken: auth.accessToken);
    }).then((credential) {
      if (linkAccount) {
        return _auth
            .currentUser()
            .then((currentUser) => currentUser.linkWithCredential(credential));
      } else {
        return _auth.signInWithCredential(credential);
      }
    }).then((authResult) {
      return Auth.userFromFirebaseUser(authResult.user);
    });
  }

  Future<User> facebookSignIn({bool linkAccount = false}) {
    final _facebookSignin = FacebookLogin();
    return _facebookSignin.logIn(['email']).then((result) {
      if (result.status == FacebookLoginStatus.cancelledByUser) {
        throw Exception('Facebook login cancelled');
      }
      if (result.status == FacebookLoginStatus.error) {
        throw Exception(result.errorMessage);
      }
      return FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token);
    }).then((credential) {
      if (linkAccount) {
        return _auth
            .currentUser()
            .then((currentUser) => currentUser.linkWithCredential(credential));
      } else {
        return _auth.signInWithCredential(credential);
      }
    }).then((authResult) {
      return Auth.userFromFirebaseUser(authResult.user);
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
    var isAnon = firebaseUser.isAnonymous;
    var provider = firebaseUser.providerId;
    var name = isAnon ? "Anonim" : firebaseUser.displayName;
    var avatar = isAnon ? DEFAULT_AVATAR_IMAGE : firebaseUser.photoUrl;

    if (!isAnon && firebaseUser.providerData.isNotEmpty) {
      var info = firebaseUser.providerData.firstWhere((i) {
        return i.displayName != null && i.displayName.trim().length > 0;
      });
      provider = info.providerId;
      name = info.displayName;
      avatar = info.photoUrl != null ? info.photoUrl : DEFAULT_AVATAR_IMAGE;
    }

    return User(
        id: firebaseUser.uid,
        name: name,
        provider: provider,
        isAnonymous: isAnon,
        avatar: avatar);
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
