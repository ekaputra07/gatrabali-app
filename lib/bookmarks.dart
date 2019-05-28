import 'package:flutter/material.dart';

import 'package:gatrabali/scoped_models/news.dart';
import 'package:gatrabali/services/entries.dart';
import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/widgets/cover_image_decoration.dart';
import 'package:gatrabali/widgets/char_thumbnail.dart';
import 'package:gatrabali/single_news.dart';

class Bookmarks extends StatefulWidget {
  @override
  _BookmarksState createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  @override
  Widget build(BuildContext ctx) {
    // return StreamBuilder<List<Entry>>(
    //   stream: EntryService.fetchEntries().asStream(),
    //   builder: (ctx, stream) {
    //     if (!stream.hasData) return Container();

    //     return _buildList(ctx, stream.data);
    //   },
    // );
    return Container();
  }
}

Widget _buildList(BuildContext ctx, List<Entry> entries) {
  return ListView(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      children: entries.map((entry) => _listItem(ctx, entry)).toList());
}

Widget _listItem(BuildContext ctx, Entry entry) {
  final feeds = News.of(ctx).feeds;
  final feedTitle = entry.getFeedTitle(feeds);
  final source = feedTitle == null ? '' : feedTitle;

  Widget thumbnail;
  if (entry.hasPicture) {
    thumbnail =
        CoverImageDecoration(url: entry.picture, width: 50.0, height: 50.0);
  } else {
    thumbnail = CharThumbnail(char: entry.title[0]);
  }

  return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
      child: Card(
          child: ListTile(
              onTap: () {
                Navigator.push(
                    ctx,
                    MaterialPageRoute(
                        builder: (ctx) => SingleNews(
                            key: ValueKey(entry.id),
                            title: source,
                            entry: entry)));
              },
              leading: thumbnail,
              title: Text(entry.title,
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600)),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 3.0),
                child: Text("$source (${entry.formattedDate})"),
              ))));
}
