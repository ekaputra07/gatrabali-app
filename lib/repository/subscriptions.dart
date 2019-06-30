import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gatrabali/models/subscription.dart';

class SubscriptionService {
  // Register or deregister FCM token
  static Future<void> updateMessagingToken(String userID, String token,
      {bool delete = false}) async {
    final tokensField = 'fcm_tokens';

    var user =
        await Firestore.instance.collection('/users').document(userID).get();

    // user record not exists, not delete -> create user
    if (!user.exists && !delete) {
      final tokens = {token: true};
      await Firestore.instance
          .collection('/users')
          .document(userID)
          .setData({tokensField: tokens});
      print("new user + fcm token created");
      return;
    }

    // user record exists
    if (user.exists) {
      var userData = user.data;
      var tokens = userData[tokensField] == null ? {} : userData[tokensField];

      if (delete) {
        tokens.remove(token);
      } else {
        tokens[token] = true;
      }
      await user.reference.updateData({tokensField: tokens});
    }
    print("user + fcm token updated/deleted");
    return;
  }

  // Get user's alert subscription for a category
  static Future<Subscription> getCategorySubscription(
      String userId, int categoryId) {
    return Firestore.instance
        .collection('/categories/$categoryId/subscribers')
        .document(userId)
        .get()
        .then((doc) {
      if (!doc.exists)
        throw Exception('entry ${doc.reference.path} not exists');
      return Subscription.fromDocument(doc);
    });
  }

  // Subscribe to a category
  static Future<void> subscribeToCategory(String userId, int categoryId,
      {bool delete = false}) {
    var collectionName = '/categories/$categoryId/subscribers';
    if (!delete) {
      var sub = Subscription(
          userId: userId, subscribedAt: DateTime.now().millisecondsSinceEpoch);
      return Firestore.instance
          .collection(collectionName)
          .document(userId)
          .setData(sub.toMap());
    } else {
      return Firestore.instance
          .collection(collectionName)
          .document(userId)
          .delete();
    }
  }
}
