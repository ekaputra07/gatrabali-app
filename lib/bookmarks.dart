import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
      children: docs.map((doc) => _listItem(ctx, doc)).toList());
}

Widget _listItem(BuildContext ctx, DocumentSnapshot item) {
  Map<String, dynamic> data = item.data;

  var dateFormatted = DateFormat("d/MM/yyyy")
      .format(DateTime.fromMillisecondsSinceEpoch(data["published_at"]));

  Widget thumbnail;
  var hasImage = data["enclosures"] == null ? false : true;
  if (hasImage) {
    thumbnail = CoverImageDecoration(
        url: data["enclosures"][0]["url"], width: 50.0, height: 50.0);
  } else {
    thumbnail = CharThumbnail(char: data['title'][0]);
  }

  return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
      child: Card(
          child: ListTile(
              onTap: () {
                Navigator.push(
                    ctx,
                    MaterialPageRoute(
                        builder: (ctx) =>
                            SingleNews(ValueKey(data['id']), data)));
              },
              leading: thumbnail,
              title: Text(data["title"],
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600)),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 3.0),
                child: Text("Balipost.com ($dateFormatted)"),
              ))));
}
