import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:gatrabali/models/feed.dart';
import 'package:gatrabali/models/user.dart';

class News extends Model {
  List<Feed> feeds = <Feed>[];
  User currentUser;
  int selectedTabIndex;
  String whatIsChanged;

  void setFeeds(List<Feed> feeds) {
    this.feeds = feeds;
    this.whatIsChanged = 'feeds';
    notifyListeners();
  }

  void setSelectedTabIndex(int index) {
    this.selectedTabIndex = index;
    this.whatIsChanged = 'selectedTabIndex';
    notifyListeners();
  }

  void setUser(User user) {
    this.currentUser = user;
    this.whatIsChanged = 'currentUser';
    print("currentUser SET: $user");
    notifyListeners();
  }

  static News of(BuildContext ctx) =>
      ScopedModel.of<News>(ctx, rebuildOnChange: false);
}
