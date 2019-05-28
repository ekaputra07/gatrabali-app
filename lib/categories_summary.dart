import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:gatrabali/services/entries.dart';
import 'package:gatrabali/models/category.dart';
import 'package:gatrabali/widgets/category_summary_card.dart';

class CategoriesSummary extends StatefulWidget {
  @override
  _CategoriesSummaryState createState() => _CategoriesSummaryState();
}

class _CategoriesSummaryState extends State<CategoriesSummary> {
  List<CategorySummary> _categories;
  StreamSubscription _sub;
  RefreshController _refreshController;

  @override
  void initState() {
    _refreshCategories();
    _refreshController = RefreshController(initialRefresh: false);
    super.initState();
  }

  _refreshCategories() {
    _sub = EntryService.fetchCategorySummary().asStream().listen((categories) {
      if (categories.isNotEmpty) {
        setState(() {
          _categories = categories;
        });
      }
      _refreshController.refreshCompleted();
    });
    _sub.onError((err) {
      print(err);
      _refreshController.refreshFailed();
    });
  }

  @override
  void dispose() {
    if (_sub != null) {
      _sub.cancel();
    }
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      onRefresh: () {
        _refreshCategories();
      },
      child: _buildList(ctx),
    );
  }

  Widget _buildList(BuildContext ctx) {
    var categories = _categories == null ? [] : _categories;
    return ListView(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        children:
            categories.map((summary) => _listItem(ctx, summary)).toList());
  }

  Widget _listItem(BuildContext ctx, CategorySummary summary) {
    return Padding(
      padding: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      child: CategorySummaryCard(
          categoryId: summary.id,
          categoryName: summary.title,
          entries: summary.entries),
    );
  }
}
