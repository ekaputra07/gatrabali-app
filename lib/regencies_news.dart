import 'package:flutter/material.dart';

import 'package:gatrabali/services/entries.dart';
import 'package:gatrabali/models/category.dart';
import 'package:gatrabali/models/entry.dart';

import 'package:gatrabali/widgets/regency_news_card.dart';

class RegenciesNews extends StatefulWidget {
  @override
  _RegenciesNewsState createState() {
    return _RegenciesNewsState();
  }
}

class _RegenciesNewsState extends State<RegenciesNews> {
  @override
  Widget build(BuildContext ctx) {
    return FutureBuilder<List<CategorySummary>>(
      future: EntryService.fetchCategorySummary(),
      builder: (ctx, result) {
        if (!result.hasData) return Container();

        return _buildList(ctx, result.data);
      },
    );
  }
}

Widget _buildList(BuildContext ctx, List<CategorySummary> summaries) {
  return ListView(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      children: summaries.map((summary) => _listItem(ctx, summary)).toList());
}

Widget _listItem(BuildContext ctx, CategorySummary summary) {
  return Padding(
    padding: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
    child: RegencyNewsCard(
        key: ValueKey(summary.id),
        entries: summary.entries,
        regency: summary.title),
  );
}
