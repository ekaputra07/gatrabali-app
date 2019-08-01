import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/repository/entries.dart';
import 'package:gatrabali/widgets/single_news_nocard.dart';

class RelatedEntries extends StatelessWidget {
  final String title;
  final int cursor;
  final int categoryId;
  final int limit;

  RelatedEntries({this.title, this.cursor, this.categoryId, this.limit = 5});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: EdgeInsets.only(top: 10, left: 25),
          child: Text(title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.start)),
      Padding(
          padding: EdgeInsets.all(0),
          child: FutureBuilder(
              future: EntryService.fetchEntries(
                  categoryId: categoryId, cursor: cursor, limit: limit),
              builder: (BuildContext context, AsyncSnapshot<List<Entry>> snap) {
                if (snap.hasError) {
                  return Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text("Maaf! gagal mengambil berita lainnya...",
                          style: TextStyle(color: Colors.grey)));
                }

                if (snap.data == null) {
                  return Center(
                      child: CircularProgressIndicator(strokeWidth: 2));
                }

                if (snap.hasData) {
                  return ListView.builder(
                      padding: EdgeInsets.only(
                          top: 20, right: 10, bottom: 50, left: 10),
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: snap.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        Entry entry = snap.data[index];
                        return SingleNewsNoCard(
                            key: ValueKey(entry.id),
                            entry: entry,
                            maxLines: 2,
                            showCategoryName: false);
                      });
                }
              }))
    ]);
  }
}
