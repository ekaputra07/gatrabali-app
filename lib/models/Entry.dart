import 'package:intl/intl.dart';

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

  String getFeedTitle(List<Feed> feeds) {
    for (var f in feeds) {
      if (f.id == this.feedId) {
        return f.title;
      }
    }
    return null;
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

  static List<Entry> emptyList() {
    return List<Entry>();
  }
}
