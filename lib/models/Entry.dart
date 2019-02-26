import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Entry {
  int id;
  int categoryId;
  int feedId;
  int publishedAt;
  String title;
  String url;
  String content;
  String picture;
  String author;

  bool get hasPicture => picture != null;
  String get formattedDate => DateFormat("d/MM/yyyy")
      .format(DateTime.fromMillisecondsSinceEpoch(publishedAt));

  static Entry fromDocument(DocumentSnapshot doc) {
    var e = new Entry();
    e.id = doc['id'];
    e.title = doc['title'];
    e.url = doc['url'];
    e.content = doc['content'];
    e.publishedAt = doc["published_at"];
    e.feedId = doc['feed_id'];
    if (doc['author'] != null) e.author = doc['author'];
    if (doc['enclosures'] != null) e.picture = doc['enclosures'][0]['url'];
    if (doc['categories'] != null) e.categoryId = doc['categories'][0];
    return e;
  }
}
