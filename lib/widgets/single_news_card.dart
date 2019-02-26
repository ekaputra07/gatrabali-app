import 'package:flutter/material.dart';

import 'package:gatrabali/models/Entry.dart';
import 'package:gatrabali/widgets/cover_image_decoration.dart';
import 'package:gatrabali/single_news.dart';

class SingleNewsCard extends StatelessWidget {
  final Entry entry;

  SingleNewsCard({Key key, this.entry}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    var source = "Balipost.com";
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _header(ctx),
          ListTile(
            title: Padding(
                padding: EdgeInsets.only(top: 7),
                child: Text(entry.title,
                    style: TextStyle(fontWeight: FontWeight.bold))),
            subtitle: Padding(
                padding: EdgeInsets.only(top: 5, bottom: 10),
                child: Text("$source (${entry.formattedDate})")),
            onTap: () {
              _openDetail(ctx);
            },
          ),
        ],
      ),
    );
  }

  Widget _header(ctx) {
    if (entry.hasPicture) {
      return Stack(
        children: [
          CoverImageDecoration(
              url: entry.picture,
              width: null,
              height: 150.0,
              onTap: () {
                _openDetail(ctx);
              }),
        ],
      );
    } else {
      return Container(
        width: double.infinity,
        height: 150.0,
        color: Colors.teal,
      );
    }
  }

  // Open detail page
  void _openDetail(BuildContext ctx) {
    Navigator.push(
        ctx,
        MaterialPageRoute(
            builder: (ctx) =>
                SingleNews(key: ValueKey(entry.id), entry: entry)));
  }

  // Bookmark this item
  void _bookmark(BuildContext ctx) {}
}
