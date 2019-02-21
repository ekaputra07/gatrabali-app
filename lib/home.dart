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
  // TODO: Pull news from firestore
  const list = [
    {"title": "Apa kabar dunia"},
    {"title": "Hello Hello"},
    {"title": "Bagus sekali"},
  ];
  return _buildList(ctx, list);
}

Widget _buildList(BuildContext ctx, List<Map> news) {
  return ListView(
      padding: new EdgeInsets.only(top: 10.0),
      children: news.map((n) => _listItem(ctx, n)).toList());
}

Widget _listItem(BuildContext ctx, Map item) {
  return Padding(
      key: ValueKey(item["title"]),
      padding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0)),
        child: ListTile(
            title: Text(item["title"]), onLongPress: () => print(item["name"])),
      ));
}
