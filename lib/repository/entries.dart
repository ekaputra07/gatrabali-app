import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:gatrabali/config.dart';
import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/models/category.dart';

class EntryService {
  /**
   * Returns all entries.
   */
  static Future<List<Entry>> fetchEntries(
      {int categoryId, int cursor, int limit = 10}) {
    var category = categoryId == null ? '' : categoryId;
    var url = cursor == null
        ? '$API_HOST/api/v1/news?categoryId=$category&limit=$limit'
        : '$API_HOST/api/v1/news?categoryId=$category&cursor=$cursor&limit=$limit';
    print('EntryService.fetchEntries() => $url ...');
    return http.get(url).then((resp) {
      print('EntryService.fetchEntries() finished.');
      if (resp.statusCode == 200) {
        List<dynamic> entries = convert.jsonDecode(resp.body);
        return Future.value(entries.map((f) => Entry.fromJson(f)).toList());
      }
      throw Exception(resp.body);
    });
  }

  /**
   * Returns summary of Category news.
   */
  static Future<List<CategorySummary>> fetchCategorySummary() {
    print('EntryService.fetchCategorySummary()...');
    return http.get('$API_HOST/api/v1/category_news_summary').then((resp) {
      print('EntryService.fetchCategorySummary() finished.');
      if (resp.statusCode == 200) {
        List<dynamic> summaries = convert.jsonDecode(resp.body);
        return Future.value(
            summaries.map((f) => CategorySummary.fromJson(f)).toList());
      }
      throw Exception(resp.body);
    });
  }

  static Future<bool> isBookmarked(String userId, String entryId) {
    return Firestore.instance
        .collection('/users/$userId/bookmarks')
        .document(entryId)
        .get()
        .then((bookmark) {
          if (bookmark.exists) return true;
          return false;
        });
  }
}
