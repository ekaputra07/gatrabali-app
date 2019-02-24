import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gatrabali/widgets/cover_image_decoration.dart';

class SingleNews extends StatelessWidget {
  final dynamic data;

  SingleNews(Key key, this.data) : super(key: key);

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
      Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(children: [
              Icon(Icons.bookmark, color: Colors.teal),
              Text("Bookmark", style: TextStyle(color: Colors.teal))
            ]),
            Column(children: [
              Icon(Icons.comment, color: Colors.black),
              Text("12 Komentar")
            ])
          ],
        ),
      ),
      Divider(),
      Html(
          useRichText: true,
          data: data["content"],
          padding: EdgeInsets.all(20.0),
          onLinkTap: (link) {
            print("Link Tapped");
          }),
    ]));
  }
}
