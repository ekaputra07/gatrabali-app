import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:toast/toast.dart';

import 'package:gatrabali/repository/entries.dart';
import 'package:gatrabali/scoped_models/app.dart';
import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/widgets/cover_image_decoration.dart';
import 'package:gatrabali/profile.dart';

class SingleNewsArgs {
  int id;
  String title;
  Entry entry;

  SingleNewsArgs(this.title, this.entry, {this.id});
}

class SingleNews extends StatefulWidget {
  static final String routeName = '/SingleNews';
  final int id;
  final String title;
  final Entry entry;
  final AppModel model;

  SingleNews({this.title, this.entry, this.model, this.id});

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
      EntryService.getEntryById(widget.id).then((entry) {
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
      appBar: AppBar(
          title: Text(widget.title == null ? _entry.title : widget.title)),
      body: _loading ? _loader() : _getBody(ctx),
    );
  }

  Widget _loader() {
    if (_notFound) {
      return Center(
          child: Text('Berita tidak ditemukan.',
              style: TextStyle(color: Colors.grey, fontSize: 16)));
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget _getBody(BuildContext ctx) {
    var title = Text(_entry.title,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18.0));

    return SingleChildScrollView(
        child: Column(children: [
      Stack(
        children: [
          _cover(ctx),
          Container(
            height: 200,
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
      Divider(),
      _source(ctx),
      Divider(),
      _actions(ctx, false),
      Divider()
    ]));
  }

  Widget _cover(BuildContext ctx) {
    if (_entry.hasPicture) {
      return CoverImageDecoration(
          url: _entry.picture, height: 200.0, width: null);
    } else {
      return Container(
        width: double.infinity,
        height: 200.0,
        color: Colors.green,
      );
    }
  }

  Widget _actions(BuildContext ctx, bool includeDate) {
    List<Widget> actions = [
      GestureDetector(
          onTap: () {
            _bookmark(ctx);
          },
          child: Column(children: [
            Icon(Icons.bookmark,
                color: _bookmarked ? Colors.green : Colors.black),
            Text("Simpan",
                style:
                    TextStyle(color: _bookmarked ? Colors.green : Colors.black))
          ])),
      // Column(children: [
      //   Icon(Icons.comment, color: Colors.black),
      //   Text("12 Komentar")
      // ]),
      GestureDetector(
          onTap: () {
            Share.share(
                "${_entry.url} via Gatra Bali App (http://bit.ly/gatrabali)");
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
            children: [Icon(Icons.calendar_today), Text(_entry.formattedDate)]),
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
    return GestureDetector(
        onTap: () {
          launch(_entry.url, forceSafariVC: false);
        },
        child: Padding(
            padding: EdgeInsets.all(10),
            child: ListTile(
              title: Text("Sumber:"),
              subtitle: Text(_entry.url, style: TextStyle(color: Colors.green)),
            )));
  }
}
