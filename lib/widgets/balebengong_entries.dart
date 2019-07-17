import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/repository/entries.dart';
import 'package:gatrabali/widgets/single_news_nocard.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BalebengongEntries extends StatefulWidget {
  final int categoryId;
  final String name;

  BalebengongEntries(this.categoryId, this.name);

  @override
  _BalebengongEntriesState createState() => _BalebengongEntriesState();
}

class _BalebengongEntriesState extends State<BalebengongEntries>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  RefreshController _refreshController;
  StreamSubscription _sub;
  List<Entry> _entries = <Entry>[];
  int _cursor = 0;

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    _refreshEntries();
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
    _sub = EntryService.fetchBalebengongEntries(categoryId: widget.categoryId)
        .asStream()
        .listen((entries) {
      _refreshController.refreshCompleted();
      setState(() {
        _cursor = entries.last.publishedAt;
        _entries = entries;
      });
    });
    _sub.onError((err) {
      _refreshController.refreshFailed();
      print(err);
    });
  }

  void _loadEntries() {
    _sub = EntryService.fetchBalebengongEntries(
            categoryId: widget.categoryId, cursor: _cursor)
        .asStream()
        .listen((entries) {
      _refreshController.loadComplete();
      setState(() {
        _cursor = entries.last.publishedAt;
        _entries.addAll(entries);
      });
    });
    _sub.onError((err) {
      _refreshController.loadNoData();
      print(err);
    });
  }

  Widget _listItem(BuildContext ctx, Entry entry) {
    return Padding(
        padding: new EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: SingleNewsNoCard(
            key: ValueKey(entry.id),
            entry: entry,
            showCategoryName: widget.categoryId == 0));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: true,
      onRefresh: () {
        _refreshEntries();
      },
      onLoading: () {
        _loadEntries();
      },
      child: _buildList(),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 10),
      itemCount: _entries.length,
      itemBuilder: (BuildContext ctx, int index) {
        return _listItem(ctx, _entries[index]);
      },
    );
  }
}
