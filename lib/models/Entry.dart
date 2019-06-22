import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gatrabali/models/feed.dart';

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

  String getFeedTitle(List<Feed> feeds, Map<int, String> categories) {
    var title;

    for (var f in feeds) {
      if (f.id == this.feedId) {
        title = f.title;
      }
    }
    if (title == null) {
      title = categories[categoryId];
    }
    return title;
  }

  static Entry fromJson(dynamic json) {    
    var e = new Entry();
    e.id = json['id'];
    e.title = json['title'];
    e.url = json['url'];
    e.content = json['content'];
    e.publishedAt = json["published_at"];
    e.feedId = json['feed_id'];
    if (json['author'] != null) e.author = json['author'];
    if (json['enclosures'] != null) e.picture = json['enclosures'][0]['url'];
    if (json['categories'] != null) e.categoryId = json['categories'][0];
    return e;
  }

  static Entry fromBookmarkEntry(BookmarkEntry bookmark) {
    var e = new Entry();
    e.id = bookmark.entryId;
    e.title = bookmark.title;
    e.publishedAt = bookmark.publishedAt;
    e.feedId = bookmark.feedId;
    e.picture = bookmark.picture;
    return e;
  }

  static List<Entry> emptyList() {
    return List<Entry>();
  }
}

class BookmarkEntry {
  int entryId;
  int feedId;
  int publishedAt;
  DateTime bookmarkedAt;
  String title;
  String url;
  String picture;

  bool get hasPicture => picture != null;
  String get formattedDate => DateFormat("d/MM/yyyy")
      .format(DateTime.fromMillisecondsSinceEpoch(publishedAt));

  String getFeedTitle(List<Feed> feeds) {
    for (var f in feeds) {
      if (f.id == this.feedId) {
        return f.title;
      }
    }
    return null;
  }

  static BookmarkEntry fromDocument(DocumentSnapshot doc) {
    final data = doc.data;
    var be = new BookmarkEntry();
    be.entryId = data['entry_id'];
    be.title = data['title'];
    be.picture = data['picture'];
    be.publishedAt = data["published_at"];
    be.bookmarkedAt = data["bookmarked_at"];
    be.feedId = data['feed_id'];
    return be;
  }
}
