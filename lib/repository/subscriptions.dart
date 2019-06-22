import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gatrabali/models/subscription.dart';

class SubscriptionService {
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
          userId: userId,
          lastChecked: DateTime.now().millisecondsSinceEpoch,
          acceptNotification: true);
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
