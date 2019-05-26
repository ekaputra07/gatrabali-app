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
  static Future<List<Entry>> fetchEntries() {
    print('EntryService.fetchEntries()...');
    return http.get('$API_HOST/api/v1/news').then((resp) {
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
