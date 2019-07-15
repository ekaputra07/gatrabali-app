import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'package:gatrabali/models/feed.dart';
import 'package:gatrabali/models/user.dart';

class AppModel extends Model {
  List<Feed> feeds = <Feed>[];
  User currentUser;
  int selectedTabIndex;
  String whatIsChanged;
  RemoteConfig remoteConfig;

  Map<int, String> categories = {
    11: 'Hukum & Kriminal',
    12: 'Bali United',
    2: 'Badung',
    3: 'Bangli',
    4: 'Buleleng',
    5: 'Denpasar',
    6: 'Gianyar',
    7: 'Jembrana',
    8: 'Karangasem',
    9: 'Klungkung',
    10: 'Tabanan',
    13: 'Opini',
    14: 'Teknologi',
    15: 'Lingkungan',
    16: 'Sosok',
    17: 'Budaya',
    18: 'Sosial',
    19: 'Agenda',
    20: 'Travel'
  };

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

  void setRemoteConfig(RemoteConfig config) {
    this.remoteConfig = config;
    print(
        "remoteConfig SET:cloudinary_fetch_url=${config.getString('cloudinary_fetch_url')}");
    notifyListeners();
  }

  String getCloudinaryUrl() {
    if (remoteConfig == null) return '';
    return remoteConfig.getString('cloudinary_fetch_url');
  }

  static AppModel of(BuildContext ctx) =>
      ScopedModel.of<AppModel>(ctx, rebuildOnChange: false);
}
