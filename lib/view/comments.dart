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
      appBar: AppBar(
          title: Text(
              '${entry.commentCount == null ? 0 : entry.commentCount} komentar')),
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
  final _limit = 10;

  bool _loading = true;
  bool _loadingMore = false;
  int _cursor;
  List<Response> _comments = List<Response>();

  @override
  void initState() {
    super.initState();
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

  void _loadComments({bool loadmore = false}) {
    if (loadmore) {
      setState(() {
        _loadingMore = true;
      });
    }

    ResponseService.getEntryComments(
      widget.entry.id,
      limit: _limit,
      cursor: _cursor,
    ).then((comments) {
      setState(() {
        // set cursor value
        if (comments.length < _limit) {
          _cursor = null;
        } else {
          _cursor = comments.last.createdAt;
        }

        if (loadmore) {
          // append
          _loadingMore = false;
          _comments.addAll(comments);
        } else {
          // replace
          _loading = false;
          _comments = comments;
        }
      });
    });
  }

  // send the comment
  void _postComment() async {
    if (_textEditingController.text.trim().length == 0) return;

    final user = AppModel.of(context).currentUser;
    var comment = Response.create(
      TYPE_COMMENT,
      widget.entry,
      user,
      comment: _textEditingController.text,
    );

    try {
      comment = await ResponseService.saveUserReaction(comment);
      setState(() {
        _comments.add(comment);
        _textEditingController.clear();
        _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent + 100.0);
      });
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
                child: CircularProgressIndicator(strokeWidth: 2),
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
    // render loadmore
    if (comment.type == "LOADMORE") {
      return Container(
        padding: EdgeInsets.all(15.0),
        margin: EdgeInsets.only(bottom: 5.0),
        color: Colors.white,
        child: _loadingMore
            ? Center(
                child: Container(
                  child: CircularProgressIndicator(strokeWidth: 2),
                  width: 20.0,
                  height: 20.0,
                ),
                widthFactor: 1,
                heightFactor: 1,
              )
            : GestureDetector(
                child: Text(
                  "Komentar sebelumnya...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  _loadComments(loadmore: true);
                }),
      );
    }

    // render response
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
                  backgroundImage: NetworkImage(comment.user.avatar),
                  radius: 18.0,
                ),
                SizedBox(width: 10.0),
                Expanded(
                    child: Text(comment.user.name,
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
    final comments = List<Response>.from(_comments);
    comments.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    // if more comments possibly still available
    // add fake response to commenrs so it will be rendered as Load more button.
    // only loggedin user can load previous comments.
    final user = AppModel.of(context).currentUser;
    if (_cursor != null && user != null && !user.isAnonymous) {
      final resp = Response();
      resp.type = "LOADMORE";
      comments.insertAll(0, [resp]);
    }

    return Flexible(
      child: ListView.builder(
          // reverse: true,
          controller: _scrollController,
          itemCount: comments.length,
          itemBuilder: (ctx, index) {
            return _buildItem(comments[index]);
          }),
    );
  }
}
