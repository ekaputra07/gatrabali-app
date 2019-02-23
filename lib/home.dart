import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gatrabali/widgets/regency_news_card.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: Text("Gatra Bali")),
      body: _buildBody(ctx),
    );
  }
}

Widget _buildBody(BuildContext ctx) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance
        .collection("entries")
        .orderBy("id", descending: true)
        .limit(20)
        .snapshots(),
    builder: (ctx, snapshots) {
      if (!snapshots.hasData) return LinearProgressIndicator();

      return _buildList(ctx, snapshots.data.documents);
    },
  );
}

Widget _buildList(BuildContext ctx, List<DocumentSnapshot> docs) {
  return ListView(
      padding: new EdgeInsets.only(top: 10.0),
      children: docs.map((doc) => _listItem(ctx, doc)).toList());
}

Widget _listItem(BuildContext ctx, DocumentSnapshot item) {
  Map<String, dynamic> data = item.data;
  var hasImage = data["enclosures"] == null ? false : true;

  if (hasImage) {
    return Padding(
      padding: new EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: RegencyNewsCard(
          key: ValueKey(item.documentID), regency: "Gianyar", data: data),
    );
  }

  return Padding(
      padding: new EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text(data["title"]),
            )
          ],
        ),
      ));
}
