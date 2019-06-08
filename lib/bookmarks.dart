import 'package:flutter/material.dart';

import 'package:gatrabali/scoped_models/news.dart';
import 'package:gatrabali/repository/entries.dart';
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
  void initState() {
    News.of(context).addListener(() {
      final model = News.of(context);
      final whatIsChanged = model.whatIsChanged;
      // - reload bookmarks when bookmarks screen visible
      // - show/hide bookmarks item when user login/logout.
      if (whatIsChanged == 'selectedTabIndex' &&
          model.selectedTabIndex == 2 &&
          model.currentUser != null) {
        setState(() {});
      } else if (whatIsChanged == 'currentUser') {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    print("BUIILD BOOKMARKS");
    var user = News.of(ctx).currentUser;
    if (user == null) {
      return _buildPlaceholder(
          'Silahkan login untuk mengakses berita yang telah anda simpan.');
    }

    return FutureBuilder<List<BookmarkEntry>>(
      future: EntryService.getBookmarks(user.id),
      builder: (ctx, bookmarks) {
        if (!bookmarks.hasData) {
          return _buildPlaceholder('Anda belum memiliki berita disimpan.');
        }
        return _buildList(ctx, bookmarks.data);
      },
    );
  }

  Widget _buildPlaceholder(String message) {
    return Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.0, color: Colors.grey))
          ],
        ));
  }

  Widget _buildList(BuildContext ctx, List<BookmarkEntry> entries) {
    return ListView(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        children: entries.map((entry) => _listItem(ctx, entry)).toList());
  }

  Widget _listItem(BuildContext ctx, BookmarkEntry entry) {
    Widget thumbnail;
    if (entry.hasPicture) {
      thumbnail =
          CoverImageDecoration(url: entry.picture, width: 50.0, height: 50.0);
    } else {
      thumbnail = CharThumbnail(char: entry.title[0]);
    }

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
        child: ListTile(
            onTap: () {
              // Navigator.of(ctx).pushNamed(SingleNews.routeName,
              //     arguments: SingleNewsArgs(source, entry));
            },
            leading: thumbnail,
            trailing: Icon(Icons.delete),
            title: Text(entry.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600)),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 3.0),
              child: Text("${entry.formattedDate}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13)),
            )));
  }
}
