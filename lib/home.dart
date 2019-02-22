import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  return Padding(
      key: ValueKey(item.documentID),
      padding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0)),
        child: ListTile(
            title: Text(data["title"]),
            onLongPress: () => print(data["title"])),
      ));
}
