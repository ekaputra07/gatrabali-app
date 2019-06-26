import 'package:cloud_firestore/cloud_firestore.dart';

class Subscription {
  String userId;
  int subscribedAt;

  Subscription({this.userId, this.subscribedAt});

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'subscribed_at': subscribedAt,
    };
  }

  static Subscription fromDocument(DocumentSnapshot doc) {
    final data = doc.data;
    var sub = Subscription();

    sub.userId = data['user_id'];
    sub.subscribedAt = data['subscribed_at'];
    return sub;
  }
}
