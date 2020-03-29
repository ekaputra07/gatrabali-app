import 'dart:async';

import 'package:flutter/material.dart';

class Comments extends StatelessWidget {
  static final routeName = '/Comments';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      appBar: new AppBar(title: new Text('Komentar')),
      body: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  bool isLoading;

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
    isLoading = false;
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {}
  }

  Future<bool> onBackPress() {
    Navigator.pop(context);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: [
          Column(
            children: [
              // List of messages
              buildListMessage(),
              // Input content
              buildInput(),
            ],
          ),

          // Loading
          buildLoading()
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  Widget buildInput() {
    return Container(
        // height: height,
        width: double.infinity,
        decoration: new BoxDecoration(
            border: new Border(
                top: new BorderSide(color: Colors.green, width: 0.5)),
            color: Colors.white),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Edit text
            Flexible(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                  maxLines: 3,
                  style: TextStyle(fontSize: 15.0),
                  controller: textEditingController,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(10.0),
                    filled: true,
                    hintText: "Tulis komentar...",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  focusNode: focusNode,
                ),
              ),
            ),

            // Button send message
            Material(
              child: Container(
                  padding: EdgeInsets.only(right: 20.0, left: 5.0),
                  child: Icon(
                    Icons.send,
                    size: 30.0,
                  )),
              color: Colors.white,
            ),
          ],
        ));
  }

  Widget buildItem(int index) {
    return Container(
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.only(bottom: 5.0),
        color: Colors.white,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 18.0,
                    child: Image.network(
                        "https://firebasestorage.googleapis.com/v0/b/gatrabali.appspot.com/o/app%2Favatar.png?alt=media")),
                SizedBox(width: 10.0),
                Expanded(
                    child: Text("Eka Putra",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15.0))),
                Text("5 menit yang lalu",
                    style: TextStyle(
                        fontSize: 12.0, color: Colors.grey.withOpacity(0.5))),
              ]),
              SizedBox(height: 10.0),
              Text(
                  "Komentar saya bagus sekali, By default, a TextField is decorated with an underline.\n\nTerima kasih bro",
                  style: TextStyle(fontSize: 15.0))
            ]));
  }

  Widget buildListMessage() {
    return Flexible(
        child: ListView(children: [
      buildItem(1),
      buildItem(2),
      buildItem(1),
      buildItem(2),
      buildItem(1),
      buildItem(2),
      buildItem(1),
      buildItem(2),
      buildItem(1),
      buildItem(2),
      buildItem(1),
      buildItem(2),
      buildItem(1),
      buildItem(2),
      buildItem(1),
      buildItem(2),
      buildItem(1),
      buildItem(2),
    ]));
  }
}
