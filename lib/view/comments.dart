import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

import 'package:gatrabali/models/response.dart';
import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/scoped_models/app.dart';
import 'package:gatrabali/view/profile.dart';
import 'package:gatrabali/repository/responses.dart';

class CommentsArgs {
  Entry entry;
  CommentsArgs(this.entry);
}

class Comments extends StatelessWidget {
  static final routeName = '/Comments';

  final Entry entry;
  final AppModel model;

  Comments({this.model, this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      appBar: AppBar(title: Text('Komentar')),
      body: ScopedModel(model: this.model, child: ChatScreen(this.entry)),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final Entry entry;

  ChatScreen(this.entry);

  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _loading;
  List<Response> _comments = List<Response>();

  @override
  void initState() {
    super.initState();
    _loading = false;
    _loadComments();
  }

  // handles back button/ device backpress
  Future<bool> _onBackPress() {
    Navigator.pop(context);
    return Future.value(false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  // open login/profile screen
  void _login() {
    Navigator.of(context).pushNamed(Profile.routeName, arguments: true);
  }

  void _loadComments() {
    ResponseService.getEntryComments(widget.entry.id).then((comments) {
      setState(() {
        _comments = comments;
      });
    });
  }

  // send the comment
  void _postComment() async {
    if (_textEditingController.text.trim().length == 0) return;

    final userId = AppModel.of(context).currentUser.id;
    var comment = Response.create(
      TYPE_COMMENT,
      widget.entry,
      userId,
      comment: _textEditingController.text,
    );

    try {
      comment = await ResponseService.saveUserReaction(comment);
      _textEditingController.clear();
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    } catch (err) {
      print(err);
      Toast.show('Maaf, komentar gagal terkirim!', context,
          backgroundColor: Colors.red);
      _textEditingController.text = comment.comment;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: [
          Column(
            children: [
              // List of messages
              _buildListMessage(),
              // Input content
              _buildInput()
            ],
          ),

          // Loading
          _buildLoading()
        ],
      ),
      onWillPop: _onBackPress,
    );
  }

  Widget _buildLoading() {
    return Positioned(
      child: _loading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  Widget _buildNeedLogin() {
    return Padding(
        child: ListTile(
            onTap: _login,
            leading: Icon(Icons.lock_outline, size: 40.0, color: Colors.green),
            title: Text(
                "Untuk bisa memberikan komentar silahkan login terlebih dahulu. Tap disini untuk login.")),
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0));
  }

  Widget _buildNeedUpgradeAccount() {
    return Padding(
        child: ListTile(
            onTap: _login,
            leading:
                Icon(Icons.person_outline, size: 40.0, color: Colors.green),
            title: Text(
                "Silahkan login dengan akun media sosial anda sebelum bisa memberi komentar. Tap disini untuk login.")),
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0));
  }

  Widget _buildInput() {
    final user = AppModel.of(context).currentUser;
    if (user == null) {
      return _buildNeedLogin();
    }

    if (user != null && user.isAnonymous) {
      return _buildNeedUpgradeAccount();
    }

    return Container(
        // height: height,
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.green, width: 0.5)),
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
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(10.0),
                    filled: true,
                    hintText: "Tulis komentar...",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  focusNode: _focusNode,
                ),
              ),
            ),

            // Button send message
            Material(
              child: Container(
                padding: EdgeInsets.only(right: 20.0, left: 5.0),
                child: GestureDetector(
                  child: Icon(
                    Icons.send,
                    size: 30.0,
                  ),
                  onTap: _postComment,
                ),
              ),
              color: Colors.white,
            ),
          ],
        ));
  }

  Widget _buildItem(Response comment) {
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
                Text(comment.formattedDate,
                    style: TextStyle(
                        fontSize: 12.0, color: Colors.grey.withOpacity(0.5))),
              ]),
              SizedBox(height: 10.0),
              Text(comment.comment, style: TextStyle(fontSize: 15.0))
            ]));
  }

  Widget _buildListMessage() {
    return Flexible(
      child: ListView.builder(
          itemCount: _comments.length,
          itemBuilder: (ctx, index) {
            return _buildItem(_comments[index]);
          }),
    );
  }
}
