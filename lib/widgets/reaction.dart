import 'package:flutter/material.dart';
import 'package:gatrabali/models/entry.dart';

class Reaction extends StatefulWidget {
  final Entry entry;
  Reaction(this.entry);

  @override
  State<StatefulWidget> createState() => _Reaction();
}

class _Reaction extends State<Reaction> {
  String _reaction;

  void _select(String reaction) {
    setState(() {
      _reaction = reaction;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.green,
        margin: EdgeInsets.symmetric(vertical: 15),
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 25),
        child: Column(children: [
          Text("Bagaimana reaksi anda?",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _iconButton(
                "assets/images/happy.png", _reaction == "happy" ? true : false,
                () {
              _select("happy");
            }),
            _iconButton("assets/images/surprise.png",
                _reaction == "surprise" ? true : false, () {
              _select("surprise");
            }),
            _iconButton(
                "assets/images/sad.png", _reaction == "sad" ? true : false, () {
              _select("sad");
            }),
            _iconButton(
                "assets/images/angry.png", _reaction == "angry" ? true : false,
                () {
              _select("angry");
            })
          ]),
          SizedBox(height: 25),
          SizedBox(
              width: double.maxFinite,
              child: RaisedButton(
                  elevation: 1,
                  padding: EdgeInsets.all(15),
                  onPressed: () {},
                  color: Colors.white,
                  child: Text("Berikan Komentar")))
        ]));
  }

  Widget _iconButton(String image, bool selected, VoidCallback onTap) {
    return GestureDetector(
        onTap: onTap,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: CircleAvatar(
              radius: 30,
              child: CircleAvatar(
                  radius: 30,
                  backgroundColor: selected ? Colors.white : null,
                  child: Image.asset(image, width: 48)),
            )));
  }
}
