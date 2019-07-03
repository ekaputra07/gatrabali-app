import 'package:flutter/material.dart';

import 'package:gatrabali/scoped_models/app.dart';
import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/single_news.dart';
import 'package:gatrabali/widgets/cover_image_decoration.dart';

class SingleNewsNoCard extends StatelessWidget {
  final Entry entry;
  final int maxLines;

  SingleNewsNoCard({Key key, this.entry, this.maxLines = 3}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final feeds = AppModel.of(ctx).feeds;
    final categories = AppModel.of(ctx).categories;
    final feedTitle = entry.getFeedTitle(feeds, categories);
    final source = feedTitle == null ? '' : feedTitle;

    return ListTile(
      leading: CoverImageDecoration(
        url: entry.cdnPicture != null ? entry.cdnPicture : entry.picture,
        width: 70,
        height: 50,
        borderRadius: 5.0,
      ),
      title: Text(
        entry.title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Padding(
          padding: EdgeInsets.only(top: 3),
          child: Text(
            source,
            style: TextStyle(fontSize: 12),
          )),
      onTap: () {
        _openDetail(ctx, source);
      },
    );
  }

  // Open detail page
  void _openDetail(BuildContext ctx, String source) {
    Navigator.of(ctx).pushNamed(SingleNews.routeName,
        arguments: SingleNewsArgs(source, entry));
  }
}
