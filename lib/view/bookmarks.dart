import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'dart:async';

import 'package:gatrabali/scoped_models/app.dart';
import 'package:gatrabali/repository/entries.dart';
import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/view/widgets/cover_image_decoration.dart';
import 'package:gatrabali/view/widgets/char_thumbnail.dart';
import 'package:gatrabali/view/single_news.dart';

class Bookmarks extends StatefulWidget {
  @override
  _BookmarksState createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  StreamSubscription _snapshotSubscription;
  List<BookmarkEntry> _entries = <BookmarkEntry>[];

  @override
  void initState() {
    AppModel.of(context).addListener(() {
      if (!mounted) return;

      final model = AppModel.of(context);
      // - listen for bookmarks changes when user state changed from loggged-out to logged-in.
      if (model.currentUser != null) {
        _snapshotSubscription =
            EntryService.bookmarksSnapshot(model.currentUser.id)
                .listen((snaps) {
          setState(() {
            _entries = snaps.documents
                .map((d) => BookmarkEntry.fromDocument(d))
                .toList();
          });
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    if (_snapshotSubscription != null) _snapshotSubscription.cancel();
    super.dispose();
  }

  void _deleteBookmark(BookmarkEntry bookmarkEntry) {
    var user = AppModel.of(context).currentUser;
    var entry = Entry();
    entry.id = bookmarkEntry.entryId;

    EntryService.bookmark(user.id, entry, delete: true).then((_) {
      Toast.show('Berita dihapus', context, backgroundColor: Colors.black);
    }).catchError((err) {
      print(err);
      Toast.show('Gagal menghapus berita', context,
          backgroundColor: Colors.black);
    });
  }

  @override
  Widget build(BuildContext ctx) {
    var user = AppModel.of(ctx).currentUser;
    if (user == null) {
      return _buildPlaceholder(
          'Silahkan login untuk mengakses berita yang telah anda simpan.');
    }

    if (_entries == null || _entries.isEmpty) {
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
    final cloudinaryFetchUrl = AppModel.of(ctx).getCloudinaryUrl();

    entries = entries
        .map<BookmarkEntry>((e) => e.setCloudinaryPicture(cloudinaryFetchUrl))
        .toList();

    return ListView(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        children: entries.map((entry) => _listItem(ctx, entry)).toList());
  }

  Widget _listItem(BuildContext ctx, BookmarkEntry bookmark) {
    var categories = AppModel.of(ctx).categories;

    Widget thumbnail;
    if (bookmark.hasPicture) {
      thumbnail = CoverImageDecoration(
          url: bookmark.cdnPicture != null
              ? bookmark.cdnPicture
              : bookmark.picture,
          width: 70,
          height: 50,
          borderRadius: 5.0);
    } else {
      thumbnail = CharThumbnail(char: bookmark.title[0]);
    }

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
        child: ListTile(
            onTap: () {
              var entry = Entry.fromBookmarkEntry(bookmark);
              Navigator.of(ctx).pushNamed(SingleNews.routeName,
                  arguments: SingleNewsArgs(
                      bookmark.getCategoryName(categories), entry,
                      id: bookmark.entryId, showAuthor: true));
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
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold)),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 3.0),
              child: Text("${bookmark.formattedDate}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12)),
            )));
  }
}
