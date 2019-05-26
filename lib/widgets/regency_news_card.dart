import 'package:flutter/material.dart';

import 'package:gatrabali/scoped_models/news.dart';
import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/models/feed.dart';
import 'package:gatrabali/widgets/cover_image_decoration.dart';
import 'package:gatrabali/single_news.dart';

class RegencyNewsCard extends StatelessWidget {
  final String regency;
  final List<Entry> entries;

  RegencyNewsCard({Key key, this.regency, this.entries}) : super(key: key);

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
          _moreNews(ctx)
        ],
      ),
    );
  }

  Widget _header(BuildContext ctx, String source, Entry entry) {
    var titleWidget = Text(regency.toUpperCase(),
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
      child: Text("Berita lainnya dari $regency..."),
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
}
