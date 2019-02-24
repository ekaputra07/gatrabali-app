import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gatrabali/widgets/single_news_card.dart';

class LatestNews extends StatefulWidget {
  @override
  _LatestNewsState createState() {
    return _LatestNewsState();
  }
}

class _LatestNewsState extends State<LatestNews> {
  @override
  Widget build(BuildContext ctx) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("entries")
          .orderBy("id", descending: true)
          .limit(10)
          .snapshots(),
      builder: (ctx, snapshots) {
        if (!snapshots.hasData) return LinearProgressIndicator();

        return _buildList(ctx, snapshots.data.documents);
      },
    );
  }
}

Widget _buildList(BuildContext ctx, List<DocumentSnapshot> docs) {
  return ListView(
      padding: new EdgeInsets.only(top: 10.0),
      children: docs.map((doc) => _listItem(ctx, doc)).toList());
}

Widget _listItem(BuildContext ctx, DocumentSnapshot item) {
  Map<String, dynamic> data = item.data;
  //print("[${item.documentID}] ${data['title']} - ${data['enclosures']}");
  var hasImage = data["enclosures"] == null ? false : true;

  if (hasImage) {
    return Padding(
      padding: new EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: SingleNewsCard(key: ValueKey(item.documentID), data: data),
    );
  }

  return Container();
}