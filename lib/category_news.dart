import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:gatrabali/scoped_models/news.dart';
import 'package:gatrabali/repository/entries.dart';
import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/models/feed.dart';
import 'package:gatrabali/widgets/single_news_card.dart';

class CategoryNews extends StatefulWidget {
  final String categoryName;
  final int categoryId;
  final List<Feed> feeds;

  CategoryNews({this.categoryId, this.categoryName, this.feeds});

  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<Entry> _entries;
  int _cursor;
  StreamSubscription _sub;
  RefreshController _refreshController;

  @override
  void initState() {
    _refreshEntries();
    _refreshController = RefreshController(initialRefresh: false);
    super.initState();
  }

  @override
  void dispose() {
    if (_sub != null) {
      _sub.cancel();
    }
    _refreshController.dispose();
    super.dispose();
  }

  void _refreshEntries() {
    _sub = EntryService.fetchEntries(categoryId: widget.categoryId)
        .asStream()
        .listen((entries) {
      setState(() {
        if (entries.isNotEmpty) {
          _cursor = entries.last.id;
          _entries = entries;
        }
        _refreshController.refreshCompleted();
      });
    });
    _sub.onError((err) {
      print(err);
      _refreshController.refreshFailed();
    });
  }

  void _loadMoreEntries() {
    _sub = EntryService.fetchEntries(
            categoryId: widget.categoryId, cursor: _cursor)
        .asStream()
        .listen((entries) {
      setState(() {
        if (entries.isNotEmpty) {
          _cursor = entries.last.id;
          _entries.addAll(entries);
          _refreshController.loadComplete();
        } else {
          _refreshController.loadNoData();
        }
      });
    });
    _sub.onError((err) => print(err));
  }

  @override
  Widget build(BuildContext ctx) {
    return ScopedModel<News>(
        model: new News(feeds: widget.feeds),
        child: Scaffold(
            appBar: AppBar(
              title: Text('Berita ${widget.categoryName}'),
              elevation: 0,
            ),
            body: SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: () {
                _refreshEntries();
              },
              onLoading: () {
                _loadMoreEntries();
              },
              child: _buildList(ctx),
            )));
  }

  Widget _buildList(BuildContext ctx) {
    var entries = _entries == null ? [] : _entries;
    return ListView(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        children: entries.map((entry) => _listItem(ctx, entry)).toList());
  }

  Widget _listItem(BuildContext ctx, Entry entry) {
    return Padding(
      padding: new EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: SingleNewsCard(key: ValueKey(entry.id), entry: entry),
    );
  }
}
