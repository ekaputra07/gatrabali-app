import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'package:gatrabali/scoped_models/news.dart';
import 'package:gatrabali/repository/entries.dart';
import 'package:gatrabali/models/user.dart';
import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/widgets/cover_image_decoration.dart';
import 'package:gatrabali/widgets/char_thumbnail.dart';
import 'package:gatrabali/single_news.dart';

class Bookmarks extends StatefulWidget {
  @override
  _BookmarksState createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  List<BookmarkEntry> _entries = <BookmarkEntry>[];

  @override
  void initState() {
    News.of(context).addListener(() {
      if (!mounted) return;

      final model = News.of(context);
      final whatIsChanged = model.whatIsChanged;
      // - reload bookmarks when bookmarks screen visible
      // - load bookmarks when user state changed from loggged-out to logged-in.
      if (whatIsChanged == 'selectedTabIndex' &&
          model.selectedTabIndex == 2 &&
          model.currentUser != null) {
        _loadBookmarks(model.currentUser);
      } else if (whatIsChanged == 'currentUser' && model.currentUser != null) {
        setState(() {
          _loadBookmarks(model.currentUser);
        });
      }
    });
    super.initState();
  }

  void _loadBookmarks(User user) {
    EntryService.getBookmarks(user.id).then((entries) {
      setState(() {
        _entries = entries;
      });
    }).catchError((err) => print(err));
  }

  void _deleteBookmark(BookmarkEntry bookmarkEntry) {
    var user = News.of(context).currentUser;
    var entry = Entry();
    entry.id = bookmarkEntry.entryId;
    EntryService.bookmark(user.id, entry, delete: true).then((_) {
      setState(() {
        _entries = _entries
            .skipWhile((e) => e.entryId == bookmarkEntry.entryId)
            .toList();
        Toast.show('Berita dihapus', context, backgroundColor: Colors.black);
      });
    }).catchError((err) {
      print(err);
      Toast.show('Gagal menghapus berita', context,
          backgroundColor: Colors.black);
    });
  }

  @override
  Widget build(BuildContext ctx) {
    var user = News.of(ctx).currentUser;
    if (user == null) {
      return _buildPlaceholder(
          'Silahkan login untuk mengakses berita yang telah anda simpan.');
    }

    if (_entries.isEmpty) {
      return _buildPlaceholder('Anda belum memiliki berita disimpan.');
    }

    return _buildList(ctx, _entries);
  }

  Widget _buildPlaceholder(String message) {
    return Padding(
        padding: EdgeInsets.all(30),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.bookmark, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text(message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.0, color: Colors.grey))
          ],
        )));
  }

  Widget _buildList(BuildContext ctx, List<BookmarkEntry> entries) {
    return ListView(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        children: entries.map((entry) => _listItem(ctx, entry)).toList());
  }

  Widget _listItem(BuildContext ctx, BookmarkEntry bookmark) {
    var feeds = News.of(ctx).feeds;

    Widget thumbnail;
    if (bookmark.hasPicture) {
      thumbnail = CoverImageDecoration(
          url: bookmark.picture, width: 50.0, height: 50.0);
    } else {
      thumbnail = CharThumbnail(char: bookmark.title[0]);
    }

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
        child: ListTile(
            onTap: () {
              var entry = Entry.fromBookmarkEntry(bookmark);
              Navigator.of(ctx).pushNamed(SingleNews.routeName,
                  arguments: SingleNewsArgs(bookmark.getFeedTitle(feeds), entry,
                      id: bookmark.entryId));
            },
            leading: thumbnail,
            trailing: GestureDetector(
                child: Icon(Icons.delete),
                onTap: () {
                  _deleteBookmark(bookmark);
                }),
            title: Text(bookmark.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600)),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 3.0),
              child: Text("${bookmark.formattedDate}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13)),
            )));
  }
}
