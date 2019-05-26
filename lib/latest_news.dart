import 'package:flutter/material.dart';

import 'package:gatrabali/services/entries.dart';
import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/widgets/single_news_card.dart';

class LatestNews extends StatefulWidget {
  @override
  _LatestNewsState createState() {
    return _LatestNewsState();
  }
}

class _LatestNewsState extends State<LatestNews> {
  @override
  Widget build(BuildContext ctx) {
    return StreamBuilder<List<Entry>>(
      stream: EntryService.fetchEntries().asStream(),
      builder: (ctx, stream) {
        if (!stream.hasData) return Container();

        return _buildList(ctx, stream.data);
      },
    );
  }
}

Widget _buildList(BuildContext ctx, List<Entry> entries) {
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
