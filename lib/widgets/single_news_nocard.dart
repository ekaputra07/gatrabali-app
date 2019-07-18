import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';

import 'package:gatrabali/scoped_models/app.dart';
import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/single_news.dart';
import 'package:gatrabali/widgets/cover_image_decoration.dart';

class SingleNewsNoCard extends StatelessWidget {
  final Entry entry;
  final int maxLines;
  final bool showCategoryName;
  final bool showAuthor;

  SingleNewsNoCard(
      {Key key,
      this.entry,
      this.showCategoryName,
      this.maxLines = 3,
      this.showAuthor = false})
      : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final categories = AppModel.of(ctx).categories;
    final categoryName = entry.getCategoryName(categories);
    final subTitle = showCategoryName
        ? "$categoryName, ${entry.formattedDate}"
        : StringUtils.capitalize(entry.formattedDate);

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
            subTitle,
            maxLines: 1,
            style: TextStyle(fontSize: 12),
          )),
      onTap: () {
        _openDetail(ctx, categoryName);
      },
    );
  }

  // Open detail page
  void _openDetail(BuildContext ctx, String categoryName) {
    Navigator.of(ctx).pushNamed(SingleNews.routeName,
        arguments: SingleNewsArgs(categoryName, entry, showAuthor: showAuthor));
  }
}
