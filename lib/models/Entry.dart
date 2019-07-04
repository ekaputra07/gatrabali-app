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
  String cdnPicture;
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

  Entry setCloudinaryPicture(String cloudinaryFetchUrl) {
    if (this.picture == null ||
        this.picture == "" ||
        cloudinaryFetchUrl == "") {
      return this;
    }
    this.cdnPicture = "$cloudinaryFetchUrl${this.picture}";
    return this;
  }

  static Entry fromJson(dynamic json) {
    var e = new Entry();
    e.id = json['id'];
    e.title = json['title'];
    e.url = json['url'];
    e.content = json['content'];
    e.publishedAt = json["published_at"];
    e.feedId = json['feed_id'];
    e.categoryId = json['category_id'];
    if (json['author'] != null) e.author = json['author'];
    if (json['enclosures'] != null) e.picture = json['enclosures'][0]['url'];
    return e;
  }

  static Entry fromBookmarkEntry(BookmarkEntry bookmark) {
    var e = new Entry();
    e.id = bookmark.entryId;
    e.title = bookmark.title;
    e.publishedAt = bookmark.publishedAt;
    e.feedId = bookmark.feedId;
    e.categoryId = bookmark.categoryId;
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
  int categoryId;
  int publishedAt;
  DateTime bookmarkedAt;
  String title;
  String url;
  String picture;
  String cdnPicture;

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

  BookmarkEntry setCloudinaryPicture(String cloudinaryFetchUrl) {
    if (this.picture == null ||
        this.picture == "" ||
        cloudinaryFetchUrl == "") {
      return this;
    }
    this.cdnPicture = "$cloudinaryFetchUrl${this.picture}";
    return this;
  }

  static BookmarkEntry fromDocument(DocumentSnapshot doc) {
    final data = doc.data;
    var be = new BookmarkEntry();
    be.entryId = data['entry_id'];
    be.title = data['title'];
    be.picture = data['picture'];
    be.feedId = data['feed_id'];
    be.categoryId = data['category_id'];
    be.publishedAt = data["published_at"];

    if (data["bookmarked_at"] == null) {
      be.bookmarkedAt = DateTime.now();
    } else {
      // Ios and Android will not receive same type.
      // Ios receive the timestamps as TimeStamp and Android receive it as DateTime already.
      be.bookmarkedAt = data["bookmarked_at"] is DateTime
          ? data["bookmarked_at"]
          : data["bookmarked_at"].toDate();
    }
    return be;
  }
}
