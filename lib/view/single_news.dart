import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:toast/toast.dart';

import 'package:gatrabali/repository/entries.dart';
import 'package:gatrabali/scoped_models/app.dart';
import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/view/widgets/cover_image_decoration.dart';
import 'package:gatrabali/view/widgets/picture_view.dart';
import 'package:gatrabali/view/widgets/related_entries.dart';
import 'package:gatrabali/view/widgets/reaction_block.dart';
import 'package:gatrabali/view/profile.dart';

class SingleNewsArgs {
  int id;
  String title;
  Entry entry;
  bool showAuthor;

  SingleNewsArgs(this.title, this.entry, {this.id, this.showAuthor = false});
}

class SingleNews extends StatefulWidget {
  static final String routeName = '/SingleNews';
  final int id;
  final String title;
  final Entry entry;
  final AppModel model;
  final bool showAuthor;

  SingleNews(
      {this.title, this.entry, this.model, this.id, this.showAuthor = false});

  @override
  _SingleNews createState() => _SingleNews();
}

class _SingleNews extends State<SingleNews> {
  Entry _entry;
  bool _bookmarked = false;
  bool _loading = false;
  bool _notFound = false;

  @override
  void initState() {
    _entry = widget.entry;

    if (widget.id != null) {
      _loading = true;
      EntryService.getEntryById(widget.id,
              categoryID: widget.entry.categoryId, feedID: widget.entry.feedId)
          .then((entry) {
        setState(() {
          _entry = entry;
          _loading = false;
        });
      }).catchError((err) {
        print(err);
        setState(() {
          _notFound = true;
        });
      });
    }

    if (widget.model.currentUser != null) {
      _checkBookmark();
    }

    super.initState();
  }

  void _checkBookmark() {
    EntryService.isBookmarked(widget.model.currentUser.id, _entry.id)
        .then((bookmarked) {
      setState(() {
        _bookmarked = bookmarked;
      });
    }).catchError((err) => print(err));
  }

  bool _allowBookmark() {
    if (widget.model.currentUser == null) return false;
    return true;
  }

  void _bookmark(BuildContext ctx) async {
    if (!_allowBookmark()) {
      var isLogin =
          await Navigator.of(ctx).pushNamed(Profile.routeName, arguments: true);
      if (isLogin == true) {
        _checkBookmark();
      }
      return;
    }

    var delete = _bookmarked;
    setState(() {
      if (_bookmarked) {
        _bookmarked = false;
      } else {
        _bookmarked = true;
      }
    });

    EntryService.bookmark(widget.model.currentUser.id, _entry, delete: delete)
        .then((_) {
      if (!delete) {
        Toast.show('Berita disimpan', ctx, backgroundColor: Colors.black);
      }
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        body: ScopedModel(
            model: widget.model, child: _loading ? _loader() : _getBody(ctx)));
  }

  Widget _loader() {
    if (_notFound) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Berita tidak ditemukan.',
              style: TextStyle(color: Colors.grey, fontSize: 16)),
          SizedBox(height: 10),
          RaisedButton(
            color: Colors.green,
            textColor: Colors.white,
            child: Text('Kembali'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ));
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget _getBody(BuildContext ctx) {
    var title = Text(_entry.title,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18.0));

    return CustomScrollView(slivers: [
      SliverAppBar(
          floating: true,
          title: Text(widget.title == null ? _entry.title : widget.title),
          actions: [
            IconButton(
                onPressed: () {
                  _bookmark(ctx);
                },
                icon: Icon(Icons.bookmark,
                    color: _bookmarked ? Colors.yellow : Colors.white)),
            Padding(
                padding: EdgeInsets.only(right: 10),
                child: IconButton(
                    onPressed: () {
                      Share.share(
                          "${_entry.url} via Balikabar App (http://bit.ly/balikabar)");
                    },
                    icon: Icon(Icons.share)))
          ]),
      SliverList(
          delegate: SliverChildListDelegate([
        Stack(children: [
          _cover(ctx),
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topLeft,
                    colors: const [Colors.black87, Colors.transparent])),
            child: Padding(padding: new EdgeInsets.all(20), child: title),
            alignment: Alignment.bottomLeft,
          ),
          Positioned(
            top: 10,
            right: 15,
            child: IconButton(
                icon: Icon(Icons.fullscreen, size: 40, color: Colors.white),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return PictureView(tag: 'fullscreen', url: _entry.picture);
                  }));
                }),
          )
        ]),
        SizedBox(height: 20),
        Html(
            useRichText: true,
            data: _entry.content,
            padding: EdgeInsets.symmetric(horizontal: 20),
            defaultTextStyle: TextStyle(fontSize: 16),
            linkStyle: const TextStyle(
              color: Colors.green,
            ),
            onLinkTap: (url) {
              Toast.show(
                  'Silahkan buka link tersebut di halaman asli berita ini.',
                  context,
                  duration: Toast.LENGTH_LONG,
                  backgroundColor: Colors.black);
            }),
        SizedBox(height: 10),
        Divider(),
        _author(),
        _publishDate(),
        _source(ctx),
        ReactionBlock(_entry),
        RelatedEntries(
            title: "Berita lainnya",
            categoryId: _entry.categoryId,
            feedId: _entry.feedId,
            cursor: _entry.publishedAt,
            limit: 6)
      ]))
    ]);
  }

  Widget _cover(BuildContext ctx) {
    if (_entry.hasPicture) {
      final cloudinaryFetchUrl = widget.model.getCloudinaryUrl();
      final entry = _entry.setCloudinaryPicture(cloudinaryFetchUrl);
      return CoverImageDecoration(
          url: entry.picture, height: 250.0, width: null);
    } else {
      return Container(
        width: double.infinity,
        height: 250.0,
        color: Colors.green,
      );
    }
  }

  Widget _source(BuildContext ctx) {
    return GestureDetector(
        onTap: () async {
          await launch(_entry.url, forceSafariVC: false);
        },
        child: Padding(
            padding: EdgeInsets.only(top: 5, left: 25, bottom: 5),
            child: Text("Link sumber berita",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.green),
                textAlign: TextAlign.left)));
  }

  Widget _author() {
    if (!widget.showAuthor) return Container();

    return Padding(
        padding: EdgeInsets.only(top: 10, left: 25),
        child: Text("Oleh: ${_entry.author}",
            style: TextStyle(color: Colors.black), textAlign: TextAlign.left));
  }

  Widget _publishDate() {
    return Padding(
        padding: EdgeInsets.only(top: 5, left: 25),
        child: Text("Tanggal publikasi: ${_entry.formattedDateSimple()}",
            style: TextStyle(color: Colors.black), textAlign: TextAlign.left));
  }
}
