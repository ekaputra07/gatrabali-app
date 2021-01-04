import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/repository/entries.dart';
import 'package:gatrabali/view/widgets/single_news_card.dart';
import 'package:gatrabali/view/widgets/single_news_nocard.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:gatrabali/scoped_models/app.dart';

class CategoryEntries extends StatefulWidget {
  final int categoryId;
  final String name;

  CategoryEntries(this.categoryId, this.name);

  @override
  _CategoryEntriesState createState() => _CategoryEntriesState();
}

class _CategoryEntriesState extends State<CategoryEntries>
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

    // Listen for auth state changes
    AppModel.of(context).addListener(() {
      final model = AppModel.of(context);
      if (model.currentUser == null) {
        setState(() {
          print('no user init');
          // _subscription = null;
        });
      } else {
        print('load subscription init');
        // _loadSubscription();
      }
    });
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
      _refreshController.refreshCompleted();
      if (entries.isNotEmpty) {
        setState(() {
          _cursor = entries.last.publishedAt;
          _entries = entries;
        });
      }
    });
    _sub.onError((err) {
      _refreshController.refreshFailed();
      print(err);
    });
  }

  void _loadEntries() {
    _sub = EntryService.fetchEntries(
            categoryId: widget.categoryId, cursor: _cursor)
        .asStream()
        .listen((entries) {
      if (entries.isNotEmpty) {
        _refreshController.loadComplete();
        setState(() {
          _cursor = entries.last.publishedAt;
          _entries.addAll(entries);
        });
      } else {
        _refreshController.loadNoData();
      }
    });
    _sub.onError((err) {
      _refreshController.loadNoData();
      print(err);
    });
  }

  Widget _listItem(BuildContext ctx, int index, Entry entry) {
    return Padding(
        padding: new EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: index == 0
            ? SingleNewsCard(
                key: ValueKey(entry.id),
                entry: entry,
                showCategoryName: false,
                showAuthor: true)
            : SingleNewsNoCard(
                key: ValueKey(entry.id),
                entry: entry,
                showCategoryName: false,
                showAuthor: true));
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
      padding: EdgeInsets.symmetric(vertical: 10),
      itemCount: _entries.length,
      itemBuilder: (BuildContext ctx, int index) {
        return _listItem(ctx, index, _entries[index]);
      },
    );
  }
}
