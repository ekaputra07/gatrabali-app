import 'package:flutter/material.dart';

import 'package:gatrabali/scoped_models/news.dart';
import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/models/feed.dart';
import 'package:gatrabali/widgets/cover_image_decoration.dart';
import 'package:gatrabali/single_news.dart';
import 'package:gatrabali/category_news.dart';

class CategorySummaryCard extends StatelessWidget {
  final int categoryId;
  final String categoryName;
  final List<Entry> entries;

  CategorySummaryCard({this.categoryId, this.categoryName, this.entries});

  @override
  Widget build(BuildContext ctx) {
    final feeds = News.of(ctx).feeds;

    final firstEntry = entries.first;
    final feedTitle = firstEntry.getFeedTitle(feeds);
    final source = feedTitle == null ? '' : feedTitle;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _header(ctx, source, firstEntry),
          ListTile(
            title: Padding(
                padding: EdgeInsets.only(top: 7),
                child: Text(firstEntry.title,
                    style: TextStyle(fontWeight: FontWeight.bold))),
            subtitle: Padding(
                padding: new EdgeInsets.only(top: 5),
                child: Text("$source (${firstEntry.formattedDate})")),
            onTap: () {
              _openDetail(ctx, source, firstEntry);
            },
          ),
          Divider(),
          _relatedNews(ctx, feeds, entries.sublist(1)),
          GestureDetector(
            child: _moreNews(ctx),
            onTap: () {
              _openCategory(ctx);
            },
          )
        ],
      ),
    );
  }

  Widget _header(BuildContext ctx, String source, Entry entry) {
    var titleWidget = Text(categoryName.toUpperCase(),
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white));

    return Stack(
      children: [
        CoverImageDecoration(
            url: entry.picture,
            width: null,
            height: 150,
            onTap: () {
              _openDetail(ctx, source, entry);
            }),
        Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomLeft,
                  colors: const [Colors.black87, Colors.transparent])),
          child: Padding(padding: new EdgeInsets.all(15), child: titleWidget),
        )
      ],
    );
  }

  Widget _relatedNews(BuildContext ctx, List<Feed> feeds, List<Entry> related) {
    return Column(
        children: related.map((entry) {
      final source = entry.getFeedTitle(feeds);
      return Column(
        children: [
          ListTile(
            leading:
                CoverImageDecoration(url: entry.picture, width: 40, height: 40),
            title: Text(entry.title, style: TextStyle(fontSize: 14)),
            onTap: () {
              _openDetail(ctx, source, entry);
            },
          ),
          Divider(),
        ],
      );
    }).toList());
  }

  Widget _moreNews(BuildContext ctx) {
    return Padding(
      padding: new EdgeInsets.fromLTRB(0, 7, 0, 15),
      child: Text("Berita lainnya dari $categoryName..."),
    );
  }

  // Open detail page
  void _openDetail(BuildContext ctx, String source, Entry entry) {
    Navigator.push(
        ctx,
        MaterialPageRoute(
            builder: (ctx) => SingleNews(
                key: ValueKey(entry.id), title: source, entry: entry)));
  }

  // Open category page
  void _openCategory(BuildContext ctx) {
    final feeds = News.of(ctx).feeds;
    Navigator.push(
        ctx,
        MaterialPageRoute(
            builder: (ctx) => CategoryNews(
                categoryId: categoryId,
                categoryName: categoryName,
                feeds: feeds)));
  }
}
