import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/repository/entries.dart';
import 'package:gatrabali/view/widgets/single_news_nocard.dart';
import 'package:gatrabali/config.dart';

class RelatedEntries extends StatefulWidget {
  final String title;
  final int cursor;
  final int categoryId;
  final int feedId;
  final int limit;

  RelatedEntries(
      {this.title, this.cursor, this.categoryId, this.feedId, this.limit = 5});

  @override
  _RelatedEntries createState() => _RelatedEntries();
}

class _RelatedEntries extends State<RelatedEntries> {
  List<Entry> _entries;
  StreamSubscription _sub;
  bool _loading = true;
  bool _isBalebengong = false;

  @override
  void initState() {
    _isBalebengong = BALEBENGONG_FEED_IDS.indexOf(this.widget.feedId) != -1;
    if (_isBalebengong) {
      _sub = EntryService.fetchBalebengongEntries(
              categoryId: this.widget.categoryId,
              cursor: this.widget.cursor,
              limit: this.widget.limit)
          .asStream()
          .listen((entries) {
        setState(() {
          _loading = false;
          _entries = entries;
        });
      });
    } else {
      _sub = EntryService.fetchEntries(
              categoryId: this.widget.categoryId,
              cursor: this.widget.cursor,
              limit: this.widget.limit)
          .asStream()
          .listen((entries) {
        setState(() {
          _loading = false;
          _entries = entries;
        });
      });
    }
    _sub.onError((err) {
      setState(() {
        _loading = false;
      });
      print(err);
    });

    super.initState();
  }

  @override
  void dispose() {
    if (_sub != null) {
      _sub.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: EdgeInsets.only(top: 10, left: 25),
          child: Text(_isBalebengong ? "Artikel Lainnya" : "Berita Lainnya",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.start)),
      Padding(
        padding: EdgeInsets.all(0),
        child: _loading
            ? Center(child: CircularProgressIndicator(strokeWidth: 2))
            : ListView.builder(
                padding:
                    EdgeInsets.only(top: 20, right: 10, bottom: 50, left: 10),
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: _entries.length,
                itemBuilder: (BuildContext context, int index) {
                  Entry entry = _entries[index];
                  return SingleNewsNoCard(
                      key: ValueKey(entry.id),
                      entry: entry,
                      maxLines: 2,
                      showCategoryName: false);
                }),
      )
    ]);
  }
}
