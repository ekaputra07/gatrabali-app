import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:gatrabali/widgets/cover_image_decoration.dart';
import 'package:gatrabali/single_news.dart';

class RegencyNewsCard extends StatelessWidget {
  final String regency;
  final dynamic data;

  RegencyNewsCard({Key key, this.regency, this.data}) : super(key: key) {
    initializeDateFormatting("id_ID");
  }

  @override
  Widget build(BuildContext ctx) {
    var source = "Balipost.com";
    var format = new DateFormat("dd/MM/yyyy");
    var formattedDate = format
        .format(new DateTime.fromMillisecondsSinceEpoch(data["published_at"]));

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _header(ctx, data),
          ListTile(
            title: Padding(
                padding: EdgeInsets.only(top: 7),
                child: Text(data["title"],
                    style: TextStyle(fontWeight: FontWeight.bold))),
            subtitle: Padding(
                padding: new EdgeInsets.only(top: 5),
                child: Text("$source ($formattedDate)")),
            onTap: () {
              _openDetail(ctx, data);
            },
          ),
          Divider(),
          _relatedNews(ctx),
          _moreNews(ctx)
        ],
      ),
    );
  }

  Widget _header(BuildContext ctx, dynamic data) {
    var titleWidget = Text(regency.toUpperCase(),
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white));

    return Stack(
      children: [
        CoverImageDecoration(
            url: data["enclosures"][0]["url"],
            width: null,
            height: 150,
            onTap: () {
              _openDetail(ctx, data);
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

  Widget _relatedNews(BuildContext ctx) {
    return Column(
      children: [
        ListTile(
          leading: CoverImageDecoration(
              url: "https://picsum.photos/200", width: 40, height: 40),
          title: Text(data["title"], style: TextStyle(fontSize: 14)),
          onTap: () {
            _openDetail(ctx, data);
          },
        ),
        Divider(),
        ListTile(
          leading: CoverImageDecoration(
              url: "https://picsum.photos/200", width: 40, height: 40),
          title: Text(data["title"], style: TextStyle(fontSize: 14)),
          onTap: () {
            _openDetail(ctx, data);
          },
        ),
        Divider(),
      ],
    );
  }

  Widget _moreNews(BuildContext ctx) {
    return Padding(
      padding: new EdgeInsets.fromLTRB(0, 7, 0, 15),
      child: Text("Berita lainnya dari $regency..."),
    );
  }

  // Open detail page
  void _openDetail(BuildContext ctx, dynamic data) {
    Navigator.push(
        ctx,
        MaterialPageRoute(
            builder: (ctx) => SingleNews(ValueKey(data["id"]), data)));
  }
}
