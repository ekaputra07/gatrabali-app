import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gatrabali/models/Feed.dart';

class FeedService {
  static Future<List<Feed>> fetchFeeds() {
    print('FeedService.fetchFeeds()...');
    return Firestore.instance.collection('feeds').getDocuments().then((docs) {
      print('FeedService.fetchFeeds() finished.');
      return Future.value(
          docs.documents.map((d) => Feed.fromDocument(d)).toList());
    });
  }
}
