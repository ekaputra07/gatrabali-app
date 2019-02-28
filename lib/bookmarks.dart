import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gatrabali/scoped_models/news.dart';
import 'package:gatrabali/models/Entry.dart';
import 'package:gatrabali/widgets/cover_image_decoration.dart';
import 'package:gatrabali/widgets/char_thumbnail.dart';
import 'package:gatrabali/single_news.dart';

class Bookmarks extends StatefulWidget {
  @override
  _BookmarksState createState() {
    return _BookmarksState();
  }
}

class _BookmarksState extends State<Bookmarks> {
  @override
  Widget build(BuildContext ctx) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("entries")
          .orderBy("id", descending: true)
          .limit(20)
          .snapshots(),
      builder: (ctx, snapshots) {
        if (!snapshots.hasData) return LinearProgressIndicator();

        return _buildList(ctx, snapshots.data.documents);
      },
    );
  }
}

Widget _buildList(BuildContext ctx, List<DocumentSnapshot> docs) {
  return ListView(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      children:
          docs.map((doc) => _listItem(ctx, Entry.fromDocument(doc))).toList());
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
