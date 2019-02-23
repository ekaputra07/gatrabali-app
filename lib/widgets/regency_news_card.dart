import 'package:flutter/material.dart';
import 'package:gatrabali/widgets/cover_image_decoration.dart';

class RegencyNewsCard extends StatelessWidget {
  final String regency;
  final dynamic data;

  RegencyNewsCard({Key key, this.regency, this.data}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          CoverImageDecoration(
              url: data["enclosures"][0]["url"], width: null, height: 150),
          ListTile(
            title: Text(data["title"]),
          ),
          Divider(),
          _relatedNews(),
          _moreNews()
        ],
      ),
    );
  }

  Widget _relatedNews() {
    return Column(
      children: [
        ListTile(
          leading: CoverImageDecoration(
              url: "https://picsum.photos/200", width: 40, height: 40),
          title: Text(data["title"]),
        ),
        Divider(),
        ListTile(
          leading: CoverImageDecoration(
              url: "https://picsum.photos/200", width: 40, height: 40),
          title: Text(data["title"]),
        ),
        Divider(),
      ],
    );
  }

  Widget _moreNews() {
    return Padding(
      padding: new EdgeInsets.fromLTRB(0, 7, 0, 15),
      child: Text("Berita lainnya dari $regency..."),
    );
  }
}
