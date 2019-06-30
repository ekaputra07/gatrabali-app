import 'package:flutter/material.dart';

import 'package:gatrabali/scoped_models/app.dart';
import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/widgets/cover_image_decoration.dart';
import 'package:gatrabali/single_news.dart';

class SingleNewsCard extends StatelessWidget {
  final Entry entry;

  SingleNewsCard({Key key, this.entry}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final feeds = AppModel.of(ctx).feeds;
    final categories = AppModel.of(ctx).categories;
    final feedTitle = entry.getFeedTitle(feeds, categories);
    final source = feedTitle == null ? '' : feedTitle;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _header(ctx, source),
          ListTile(
            title: Padding(
                padding: EdgeInsets.only(top: 7),
                child: Text(
                  entry.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )),
            subtitle: Padding(
                padding: EdgeInsets.only(top: 5, bottom: 10),
                child: Text("$source (${entry.formattedDate})")),
            onTap: () {
              _openDetail(ctx, source);
            },
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext ctx, String source) {
    if (entry.hasPicture) {
      return Stack(
        children: [
          CoverImageDecoration(
              url: entry.cdnPicture != null ? entry.cdnPicture : entry.picture,
              width: null,
              height: 120.0,
              onTap: () {
                _openDetail(ctx, source);
              }),
        ],
      );
    } else {
      return Container(
        width: double.infinity,
        height: 120.0,
        color: Colors.green,
      );
    }
  }

  // Open detail page
  void _openDetail(BuildContext ctx, String source) {
    Navigator.of(ctx).pushNamed(SingleNews.routeName,
        arguments: SingleNewsArgs(source, entry));
  }
}
