import 'package:flutter/material.dart';

import 'package:gatrabali/scoped_models/news.dart';
import 'package:gatrabali/models/Entry.dart';
import 'package:gatrabali/widgets/cover_image_decoration.dart';
import 'package:gatrabali/single_news.dart';

class RegencyNewsCard extends StatelessWidget {
  final String regency;
  final Entry entry;

  RegencyNewsCard({Key key, this.regency, this.entry}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final feeds = News.of(ctx).feeds;
    final feedTitle = entry.getFeedTitle(feeds);
    final source = feedTitle == null ? '' : feedTitle;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _header(ctx, entry),
          ListTile(
            title: Padding(
                padding: EdgeInsets.only(top: 7),
                child: Text(entry.title,
                    style: TextStyle(fontWeight: FontWeight.bold))),
            subtitle: Padding(
                padding: new EdgeInsets.only(top: 5),
                child: Text("$source (${entry.formattedDate})")),
            onTap: () {
              _openDetail(ctx, entry);
            },
          ),
          Divider(),
          _relatedNews(ctx),
          _moreNews(ctx)
        ],
      ),
    );
  }

  Widget _header(BuildContext ctx, Entry e) {
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
              _openDetail(ctx, entry);
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

  Widget _relatedNews(BuildContext ctx) {
    return Column(
      children: [
        ListTile(
          leading: CoverImageDecoration(
              url: "https://picsum.photos/200", width: 40, height: 40),
          title: Text(entry.title, style: TextStyle(fontSize: 14)),
          onTap: () {
            _openDetail(ctx, entry);
          },
        ),
        Divider(),
        ListTile(
          leading: CoverImageDecoration(
              url: "https://picsum.photos/200", width: 40, height: 40),
          title: Text(entry.title, style: TextStyle(fontSize: 14)),
          onTap: () {
            _openDetail(ctx, entry);
          },
        ),
        Divider(),
      ],
    );
  }

  Widget _moreNews(BuildContext ctx) {
    return Padding(
      padding: new EdgeInsets.fromLTRB(0, 7, 0, 15),
      child: Text("Berita lainnya dari $regency..."),
    );
  }

  // Open detail page
  void _openDetail(BuildContext ctx, Entry entry) {
    Navigator.push(
        ctx,
        MaterialPageRoute(
            builder: (ctx) =>
                SingleNews(key: ValueKey(entry.id), entry: entry)));
  }
}
