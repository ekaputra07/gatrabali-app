import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';

import 'package:gatrabali/scoped_models/app.dart';
import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/widgets/cover_image_decoration.dart';
import 'package:gatrabali/single_news.dart';

class SingleNewsCard extends StatelessWidget {
  final Entry entry;
  final bool showCategoryName;
  final bool showAuthor;

  SingleNewsCard(
      {Key key, this.entry, this.showCategoryName, this.showAuthor = false})
      : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final categories = AppModel.of(ctx).categories;
    final categoryName = entry.getCategoryName(categories);
    final subTitle = showCategoryName
        ? "$categoryName, ${entry.formattedDate}"
        : StringUtils.capitalize(entry.formattedDate);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _header(ctx, categoryName),
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
                child: Text(subTitle, maxLines: 1)),
            onTap: () {
              _openDetail(ctx, categoryName);
            },
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext ctx, String categoryName) {
    if (entry.hasPicture) {
      return Stack(
        children: [
          CoverImageDecoration(
              url: entry.cdnPicture != null ? entry.cdnPicture : entry.picture,
              width: null,
              height: 120.0,
              onTap: () {
                _openDetail(ctx, categoryName);
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
  void _openDetail(BuildContext ctx, String categoryName) {
    Navigator.of(ctx).pushNamed(SingleNews.routeName,
        arguments: SingleNewsArgs(categoryName, entry, showAuthor: showAuthor));
  }
}
