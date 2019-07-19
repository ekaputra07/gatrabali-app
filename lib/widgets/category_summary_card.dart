import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';

import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/widgets/cover_image_decoration.dart';
import 'package:gatrabali/single_news.dart';
import 'package:gatrabali/category_news.dart';

class CategorySummaryCard extends StatelessWidget {
  final int categoryId;
  final String categoryName;
  final List<Entry> entries;

  CategorySummaryCard({this.categoryId, this.categoryName, this.entries});

  @override
  Widget build(BuildContext ctx) {
    final firstEntry = entries.first;
    final subTitle = StringUtils.capitalize(firstEntry.formattedDate);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _header(ctx, firstEntry),
          ListTile(
            title: Padding(
                padding: EdgeInsets.only(top: 7),
                child: Text(firstEntry.title,
                    style: TextStyle(fontWeight: FontWeight.bold))),
            subtitle: Padding(
                padding: new EdgeInsets.only(top: 5),
                child: Text(subTitle, maxLines: 1)),
            onTap: () {
              _openDetail(ctx, firstEntry);
            },
          ),
          Divider(),
          _relatedNews(ctx, entries.sublist(1)),
          _moreNews(ctx)
        ],
      ),
    );
  }

  Widget _header(BuildContext ctx, Entry entry) {
    var titleWidget = Text(categoryName.toUpperCase(),
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white));

    return Stack(
      children: [
        CoverImageDecoration(
            url: entry.cdnPicture != null ? entry.cdnPicture : entry.picture,
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

  Widget _relatedNews(BuildContext ctx, List<Entry> related) {
    return Column(
        children: related.map((entry) {
      return Column(
        children: [
          ListTile(
            leading: ClipRRect(
                child: Image.network(
                    entry.cdnPicture != null ? entry.cdnPicture : entry.picture,
                    width: 60),
                borderRadius: BorderRadius.circular(3.0)),
            title: Text(entry.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            onTap: () {
              _openDetail(ctx, entry);
            },
          ),
          Divider(),
        ],
      );
    }).toList());
  }

  Widget _moreNews(BuildContext ctx) {
    return GestureDetector(
      child: Padding(
        padding: new EdgeInsets.fromLTRB(0, 7, 0, 15),
        child: Text(
          "Berita $categoryName lainnya...",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
        ),
      ),
      onTap: () {
        Navigator.of(ctx).pushNamed(CategoryNews.routeName,
            arguments: CategoryNewsArgs(categoryId, categoryName));
      },
    );
  }

  // Open detail page
  void _openDetail(BuildContext ctx, Entry entry) {
    Navigator.of(ctx).pushNamed(SingleNews.routeName,
        arguments: SingleNewsArgs(categoryName, entry));
  }
}
