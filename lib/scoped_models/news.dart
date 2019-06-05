import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:gatrabali/models/feed.dart';
import 'package:gatrabali/models/user.dart';

class News extends Model {
  List<Feed> feeds;
  User currentUser;

  News({this.feeds = const <Feed>[]});

  void setFeeds(List<Feed> feeds) {
    this.feeds = feeds;
    notifyListeners();
  }

  void setUser(User user) {
    this.currentUser = user;
    print("currentUser SET: $user");
  }

  static News of(BuildContext ctx) =>
      ScopedModel.of<News>(ctx, rebuildOnChange: false);
}
