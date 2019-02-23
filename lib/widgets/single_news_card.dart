import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:gatrabali/widgets/cover_image_decoration.dart';

class SingleNewsCard extends StatelessWidget {
  final dynamic data;

  SingleNewsCard({Key key, this.data}) : super(key: key) {
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
          _header(),
          ListTile(
            title: Text(data["title"],
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Padding(
                padding: new EdgeInsets.only(top: 5),
                child: Text("$source ($formattedDate)")),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Stack(
      children: [
        CoverImageDecoration(
            url: data["enclosures"][0]["url"], width: null, height: 150),
      ],
    );
  }
}
