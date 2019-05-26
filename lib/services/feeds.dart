import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:gatrabali/config.dart';
import 'package:gatrabali/models/feed.dart';

class FeedService {
  /**
   * Returns all feeds.
   */
  static Future<List<Feed>> fetchFeeds() {
    print('FeedService.fetchFeeds()...');
    return http.get('$API_HOST/api/v1/feeds').then((resp) {
      print('FeedService.fetchFeeds() finished.');
      if (resp.statusCode == 200) {
        List<dynamic> feeds = convert.jsonDecode(resp.body);
        return Future.value(feeds.map((f) => Feed.fromJson(f)).toList());
      }
      throw Exception(resp.body);
    }).catchError((err) {
      print('FeedService.fetchFeeds() error. $err');
      return Future.value(Feed.emptyList());
    });
  }
}
