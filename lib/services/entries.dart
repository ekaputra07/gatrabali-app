import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:gatrabali/config.dart';
import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/models/category.dart';

class EntryService {
  /**
   * Returns all entries.
   */
  static Future<List<Entry>> fetchEntries({int cursor, int limit = 10}) {
    var url = cursor == null
        ? '$API_HOST/api/v1/news?limit=$limit'
        : '$API_HOST/api/v1/news?cursor=$cursor&limit=$limit';
    print('EntryService.fetchEntries() => $url ...');
    return http.get(url).then((resp) {
      print('EntryService.fetchEntries() finished.');
      if (resp.statusCode == 200) {
        List<dynamic> entries = convert.jsonDecode(resp.body);
        return Future.value(entries.map((f) => Entry.fromJson(f)).toList());
      }
      throw Exception(resp.body);
    }).catchError((err) {
      print('EntryService.fetchEntries() error. $err');
      return Future.value(Entry.emptyList());
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
    }).catchError((err) {
      print('EntryService.fetchCategorySummary() error. $err');
      return Future.value(CategorySummary.emptyList());
    });
  }
}
