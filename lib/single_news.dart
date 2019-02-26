import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:gatrabali/models/Entry.dart';
import 'package:gatrabali/widgets/cover_image_decoration.dart';

class SingleNews extends StatelessWidget {
  final Entry entry;

  SingleNews({Key key, this.entry}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: Text("Balipost.com"), backgroundColor: Colors.teal),
      body: _getBody(ctx),
    );
  }

  Widget _getBody(BuildContext ctx) {
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
    if (entry.hasPicture) {
      return CoverImageDecoration(
          url: entry.picture, height: 250.0, width: null);
    } else {
      return Container(
        width: double.infinity,
        height: 250.0,
        color: Colors.teal,
      );
    }
  }

  Widget _actions(BuildContext ctx, bool includeDate) {
    var actions = [
      Column(children: [
        Icon(Icons.bookmark, color: Colors.teal),
        Text("Simpan", style: TextStyle(color: Colors.teal))
      ]),
      Column(children: [
        Icon(Icons.comment, color: Colors.black),
        Text("12 Komentar")
      ])
    ];

    if (includeDate) {
      actions.insert(
        0,
        Column(children: [Icon(Icons.calendar_today), Text(entry.formattedDate)]),
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
