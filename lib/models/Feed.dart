import 'package:cloud_firestore/cloud_firestore.dart';

class Feed {
  int id;
  String title;
  String feedUrl;
  String siteUrl;
  String iconData;

  static Feed fromDocument(DocumentSnapshot doc) {
    var feed = new Feed();

    feed.id = doc['id'];
    feed.title = doc['title'];
    feed.feedUrl = doc['feed_url'];
    feed.siteUrl = doc['site_url'];
    if (doc['icon_data'] != null) {
      feed.iconData = doc['icon_data'];
    }
    return feed;
  }
}