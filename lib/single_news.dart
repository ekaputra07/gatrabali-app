import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:toast/toast.dart';

import 'package:gatrabali/repository/entries.dart';
import 'package:gatrabali/scoped_models/news.dart';
import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/widgets/cover_image_decoration.dart';
import 'package:gatrabali/profile.dart';

class SingleNewsArgs {
  String title;
  Entry entry;

  SingleNewsArgs(this.title, this.entry);
}

class SingleNews extends StatefulWidget {
  static final String routeName = '/SingleNews';
  final String title;
  final Entry entry;
  final News model;

  SingleNews({this.title, this.entry, this.model});

  @override
  _SingleNews createState() => _SingleNews();
}

class _SingleNews extends State<SingleNews> {
  bool _bookmarked = false;

  @override
  void initState() {
    if (widget.model.currentUser != null) {
      _checkBookmark();
    }

    super.initState();
  }

  void _checkBookmark() {
    EntryService.isBookmarked(widget.model.currentUser.id, widget.entry.id)
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

    EntryService.bookmark(widget.model.currentUser.id, widget.entry,
            delete: _bookmarked)
        .then((_) {
      setState(() {
        if (_bookmarked) {
          _bookmarked = false;
        } else {
          _bookmarked = true;
          Toast.show('Berita disimpan', ctx, backgroundColor: Colors.black);
        }
      });
    });
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
          title:
              Text(widget.title == null ? widget.entry.title : widget.title)),
      body: _getBody(ctx),
    );
  }

  Widget _getBody(BuildContext ctx) {
    final Entry entry = widget.entry;

    var title = Text(entry.title,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18.0));

    return SingleChildScrollView(
        child: Column(children: [
      Stack(
        children: [
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
          )
        ],
      ),
      _actions(ctx, true),
      Divider(),
      Html(
          useRichText: true,
          data: entry.content,
          padding: EdgeInsets.all(20.0)),
      Divider(),
      _source(ctx),
      Divider(),
      _actions(ctx, false),
      Divider()
    ]));
  }

  Widget _cover(BuildContext ctx) {
    if (widget.entry.hasPicture) {
      return CoverImageDecoration(
          url: widget.entry.picture, height: 250.0, width: null);
    } else {
      return Container(
        width: double.infinity,
        height: 250.0,
        color: Colors.teal,
      );
    }
  }

  Widget _actions(BuildContext ctx, bool includeDate) {
    final Entry entry = widget.entry;

    List<Widget> actions = [
      GestureDetector(
          onTap: () {
            _bookmark(ctx);
          },
          child: Column(children: [
            Icon(Icons.bookmark,
                color: _bookmarked ? Colors.teal : Colors.black),
            Text("Simpan",
                style:
                    TextStyle(color: _bookmarked ? Colors.teal : Colors.black))
          ])),
      // Column(children: [
      //   Icon(Icons.comment, color: Colors.black),
      //   Text("12 Komentar")
      // ]),
      GestureDetector(
          onTap: () {
            Share.share("${entry.url} via #GatraBaliApp");
          },
          child: Column(children: [
            Icon(Icons.share, color: Colors.black),
            Text("Bagikan")
          ]))
    ];

    if (includeDate) {
      actions.insert(
        0,
        Column(
            children: [Icon(Icons.calendar_today), Text(entry.formattedDate)]),
      );
    }

    return Padding(
      padding: EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: actions,
      ),
    );
  }

  Widget _source(BuildContext ctx) {
    final Entry entry = widget.entry;

    return GestureDetector(
        onTap: () {
          launch(entry.url, forceSafariVC: false);
        },
        child: Padding(
            padding: EdgeInsets.all(10),
            child: ListTile(
              title: Text("Sumber:"),
              subtitle: Text(entry.url, style: TextStyle(color: Colors.teal)),
            )));
  }
}
