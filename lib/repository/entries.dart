import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:gatrabali/config.dart';
import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/models/category.dart';

class EntryService {
  /// Returns all entries.
  static Future<List<Entry>> fetchEntries(
      {int categoryId, int cursor, int limit = 10}) {
    var category = categoryId == null ? '' : categoryId;

    if (category == 11) {
      return fetchKriminalEntries(cursor: cursor, limit: limit);
    } else if (category == 12) {
      return fetchBaliUnitedEntries(cursor: cursor, limit: limit);
    }

    var url = cursor == null
        ? '$API_HOST/entries?categoryId=$category&limit=$limit'
        : '$API_HOST/entries?categoryId=$category&cursor=$cursor&limit=$limit';
    print('EntryService.fetchEntries() => $url ...');
    return http.get(url).then((resp) {
      print('EntryService.fetchEntries() finished.');
      if (resp.statusCode == 200) {
        List<dynamic> entries = convert.jsonDecode(resp.body);
        return entries.map((f) => Entry.fromJson(f)).toList();
      }
      throw Exception(resp.body);
    });
  }

  /// Returns all Kriminal entries.
  static Future<List<Entry>> fetchKriminalEntries(
      {int cursor = 0, int limit = 10}) {
    var url = '$API_HOST/kriminal/entries?cursor=$cursor&limit=$limit';
    print('EntryService.fetchKriminalEntries() => $url ...');
    return http.get(url).then((resp) {
      print('EntryService.fetchKriminalEntries() finished.');
      if (resp.statusCode == 200) {
        List<dynamic> entries = convert.jsonDecode(resp.body);
        return entries.map((f) => Entry.fromJson(f)).toList();
      }
      throw Exception(resp.body);
    });
  }

  /// Returns all BU entries.
  static Future<List<Entry>> fetchBaliUnitedEntries(
      {int cursor = 0, int limit = 10}) {
    var url = '$API_HOST/baliunited/entries?cursor=$cursor&limit=$limit';
    print('EntryService.fetchBaliUnitedEntries() => $url ...');
    return http.get(url).then((resp) {
      print('EntryService.fetchBaliUnitedEntries() finished.');
      if (resp.statusCode == 200) {
        List<dynamic> entries = convert.jsonDecode(resp.body);
        return entries.map((f) => Entry.fromJson(f)).toList();
      }
      throw Exception(resp.body);
    });
  }

  /// Returns all entries in Balebengong.
  static Future<List<Entry>> fetchBalebengongEntries(
      {int categoryId, int cursor = 0, int limit = 10}) {
    var category = categoryId == 0 ? '' : categoryId;

    var url =
        '$API_HOST/balebengong/entries?categoryId=$category&cursor=$cursor&limit=$limit';
    print('EntryService.fetchBalebengongEntries() => $url ...');
    return http.get(url).then((resp) {
      print('EntryService.fetchBalebengongEntries() finished.');
      if (resp.statusCode == 200) {
        List<dynamic> entries = convert.jsonDecode(resp.body);
        return entries.map((f) => Entry.fromJson(f)).toList();
      }
      throw Exception(resp.body);
    });
  }

  /// Returns summary of Category news.
  static Future<List<CategorySummary>> fetchCategorySummary() {
    print('EntryService.fetchCategorySummary()...');
    return http.get('$API_HOST/categories/summary').then((resp) {
      print('EntryService.fetchCategorySummary() finished.');
      if (resp.statusCode == 200) {
        List<dynamic> summaries = convert.jsonDecode(resp.body);
        return summaries.map((f) => CategorySummary.fromJson(f)).toList();
      }
      throw Exception(resp.body);
    });
  }

  /// Check to see if an entry is bookmarked by user
  static Future<bool> isBookmarked(String userId, int entryId) {
    return Firestore.instance
        .collection('/users/$userId/bookmarks')
        .document(entryId.toString())
        .get()
        .then((bookmark) {
      if (bookmark.exists) return true;
      return false;
    });
  }

  /// Bookmark an entry
  static Future<void> bookmark(String userId, Entry entry,
      {bool delete = false}) {
    var collectionName = '/users/$userId/bookmarks';
    if (!delete) {
      return Firestore.instance
          .collection(collectionName)
          .document(entry.id.toString())
          .setData({
        'entry_id': entry.id,
        'bookmarked_at': FieldValue.serverTimestamp(),
        'title': entry.title,
        'picture': entry.picture,
        'feed_id': entry.feedId,
        'category_id': entry.categoryId,
        'published_at': entry.publishedAt
      });
    } else {
      return Firestore.instance
          .collection(collectionName)
          .document(entry.id.toString())
          .delete();
    }
  }

  /// Returns all user bookmarks
  static Future<List<BookmarkEntry>> getBookmarks(String userId,
      {int cursor = 0, limit = 20}) {
    return Firestore.instance
        .collection('/users/$userId/bookmarks')
        // .startAfter([cursor.toString()])
        .limit(limit)
        .orderBy('bookmarked_at', descending: true)
        .getDocuments()
        .then((result) {
      return result.documents
          .map((doc) => BookmarkEntry.fromDocument(doc))
          .toList();
    }).catchError((err) => print(err));
  }

  /// Return entry by ID
  static Future<Entry> getEntryById(int id, {int categoryID, int feedID}) {
    var url = '$API_HOST/entries/$id';

    // Override url if category is kriminal or baliunited
    if (categoryID != null) {
      if (categoryID == 11) {
        url = '$API_HOST/kriminal/entries/$id';
      } else if (categoryID == 12) {
        url = '$API_HOST/baliunited/entries/$id';
      }
    }

    // Override url if feed ID is belongs to BaleBengong
    if (feedID != null) {
      if ([33, 34, 35, 36, 37, 38, 39, 40].indexOf(feedID) != -1) {
        url = '$API_HOST/balebengong/entries/$id';
      }
    }

    print('EntryService.getEntryById() => $url ...');
    return http.get(url).then((resp) {
      print('EntryService.getEntryById() finished.');
      if (resp.statusCode == 200) {
        Map<String, dynamic> e = convert.jsonDecode(resp.body);
        return Entry.fromJson(e);
      }
      throw Exception(resp.body);
    });
  }
}
