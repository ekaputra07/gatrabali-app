import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:gatrabali/widgets/cover_image_decoration.dart';
import 'package:gatrabali/single_news.dart';

class SingleNewsCard extends StatelessWidget {
  final dynamic data;

  SingleNewsCard({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    var source = "Balipost.com";
    var format = new DateFormat("dd/MM/yyyy");
    var formattedDate = format
        .format(new DateTime.fromMillisecondsSinceEpoch(data["published_at"]));

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _header(ctx),
          ListTile(
            title: Padding(
                padding: EdgeInsets.only(top: 7),
                child: Text(data["title"],
                    style: TextStyle(fontWeight: FontWeight.bold))),
            subtitle: Padding(
                padding: EdgeInsets.only(top: 5, bottom: 10),
                child: Text("$source ($formattedDate)")),
            onTap: () {
              _openDetail(ctx);
            },
          ),
        ],
      ),
    );
  }

  Widget _header(ctx) {
    bool hasImage = data['enclosures'] == null ? false : true;
    if (hasImage) {
      return Stack(
        children: [
          CoverImageDecoration(
              url: data["enclosures"][0]["url"],
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
            builder: (ctx) => SingleNews(ValueKey(data["id"]), data)));
  }

  // Bookmark this item
  void _bookmark(BuildContext ctx) {}
}
