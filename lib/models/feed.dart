class Feed {
  int id;
  String title;
  String feedUrl;
  String siteUrl;
  String iconData;

  static Feed fromJson(dynamic json) {
    var feed = new Feed();

    feed.id = json['id'];
    feed.title = json['title'];
    // feed.feedUrl = json['feed_url'];
    // feed.siteUrl = json['site_url'];
    // if (json['icon_data'] != null) {
    //   feed.iconData = json['icon_data'];
    // }
    return feed;
  }

  static List<Feed> emptyList() {
    return List<Feed>();
  }
}
