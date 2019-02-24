import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gatrabali/widgets/cover_image_decoration.dart';

class SingleNews extends StatelessWidget {
  final dynamic data;

  SingleNews(Key key, this.data) : super(key: key) {
    initializeDateFormatting("id_ID");
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: Text("Balipost.com"), backgroundColor: Colors.teal),
      body: _getBody(ctx),
    );
  }

  Widget _getBody(BuildContext ctx) {
    var imgUrl = data["enclosures"][0]["url"];
    var title = Text(data["title"],
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18.0));

    return SingleChildScrollView(
        child: Column(children: [
      Stack(
        children: [
          CoverImageDecoration(url: imgUrl, height: 250, width: null),
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
          data: data["content"],
          padding: EdgeInsets.all(20.0),
          onLinkTap: (link) {
            print("Link Tapped");
          }),
      Divider(),
      _source(ctx),
      Divider(),
      _actions(ctx, false),
      Divider()
    ]));
  }

  Widget _actions(BuildContext ctx, bool includeDate) {
    var actions = [
      Column(children: [
        Icon(Icons.bookmark, color: Colors.teal),
        Text("Bookmark", style: TextStyle(color: Colors.teal))
      ]),
      Column(children: [
        Icon(Icons.comment, color: Colors.black),
        Text("12 Komentar")
      ])
    ];

    if (includeDate) {
      var format = new DateFormat("dd/MM/yyyy");
      var formattedDate = format.format(
          new DateTime.fromMillisecondsSinceEpoch(data["published_at"]));
      actions.insert(
        0,
        Column(children: [Icon(Icons.calendar_today), Text(formattedDate)]),
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
          launch(data["url"], forceSafariVC: false);
        },
        child: Padding(
            padding: EdgeInsets.all(10),
            child: ListTile(
              title: Text("Sumber:"),
              subtitle: Text(data['url'], style: TextStyle(color: Colors.teal)),
            )));
  }
}
