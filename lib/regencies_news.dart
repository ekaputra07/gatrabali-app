import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gatrabali/models/Entry.dart';
import 'package:gatrabali/widgets/regency_news_card.dart';

class RegenciesNews extends StatefulWidget {
  @override
  _RegenciesNewsState createState() {
    return _RegenciesNewsState();
  }
}

class _RegenciesNewsState extends State<RegenciesNews> {
  @override
  Widget build(BuildContext ctx) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("entries")
          .orderBy("id", descending: true)
          .limit(10)
          .snapshots(),
      builder: (ctx, snapshots) {
        if (!snapshots.hasData) return Container();

        return _buildList(ctx, snapshots.data.documents);
      },
    );
  }
}

Widget _buildList(BuildContext ctx, List<DocumentSnapshot> docs) {
  return ListView(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      children:
          docs.map((doc) => _listItem(ctx, Entry.fromDocument(doc))).toList());
}

Widget _listItem(BuildContext ctx, Entry entry) {
  if (entry.hasPicture) {
    return Padding(
      padding: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      child: RegencyNewsCard(
          key: ValueKey(entry.id), entry: entry, regency: "Gianyar"),
    );
  }

  return Container();
}
