import 'package:cloud_firestore/cloud_firestore.dart';

class Subscription {
  String userId;
  int lastChecked;
  bool acceptNotification;

  Subscription({this.userId, this.lastChecked, this.acceptNotification});

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'last_checked': lastChecked,
      'accept_notification': acceptNotification
    };
  }

  static Subscription fromDocument(DocumentSnapshot doc) {
    final data = doc.data;
    var sub = Subscription();

    sub.userId = data['user_id'];
    sub.lastChecked = data['last_checked'];
    sub.acceptNotification = data['accept_notification'];
    return sub;
  }
}
