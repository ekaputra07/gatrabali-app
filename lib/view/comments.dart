import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

import 'package:gatrabali/models/response.dart';
import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/scoped_models/app.dart';
import 'package:gatrabali/view/profile.dart';
import 'package:gatrabali/view/single_news.dart';
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
        title: Text(entry.title),
        actions: [
          IconButton(
            icon: Icon(Icons.description),
            onPressed: () {
              Navigator.of(context).pushNamed(SingleNews.routeName,
                  arguments: SingleNewsArgs("", entry));
            },
            padding: EdgeInsets.only(right: 15.0),
          )
        ],
      ),
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
  String _loadingRepliesFor;
  bool _posting = false;
  int _cursor;
  Response _replyTo;
  Response _replyToThread;
  List<Response> _comments = List<Response>();

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  // handles back button/ device backpress
  Future<bool> _onBackPress() {
    Navigator.pop(context);
    return Future.value(false);
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

  void _loadReplies(Response comment) {
    if (_loadingRepliesFor != null) return;

    setState(() {
      _loadingRepliesFor = comment.id;
    });
    ResponseService.getCommentReplies(comment.id).then((comments) {
      setState(() {
        _comments.forEach((c) {
          if (c.id == comment.id) {
            c.replies = comments;
          }
        });
        _loadingRepliesFor = null;
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
      parentId: (_replyTo != null) ? _replyTo.id : null,
      threadId: (_replyToThread != null) ? _replyToThread.id : null,
    );

    try {
      setState(() {
        _posting = true;
      });

      comment = await ResponseService.saveUserReaction(comment);

      // add to main list or to parent
      if (_replyToThread == null) {
        setState(() {
          _comments.add(comment);
        });
        _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent + 100.0);
      } else {
        _comments.forEach((c) {
          if (c.id == _replyToThread.id) {
            c.replies.add(comment);
          }
        });
      }

      // clear text edit
      _textEditingController.clear();
      // remove focus from text edit
      _focusNode.unfocus();
      // reset reply to
      _resetReplyTo();
    } catch (err) {
      print(err);
      Toast.show(
        'Maaf, komentar gagal terkirim!',
        context,
        backgroundColor: Colors.red,
      );
      _textEditingController.text = comment.comment;
    } finally {
      setState(() {
        _posting = false;
      });
    }
  }

  void _setReplyTo(Response comment, Response thread) {
    setState(() {
      _replyTo = comment;
      _replyToThread = thread;
      _focusNode.unfocus();
      _focusNode.requestFocus();

      if (comment.id != thread.id) {
        _textEditingController.text = "@${comment.user.name}, ";
      }
    });
  }

  void _resetReplyTo() {
    setState(() {
      _replyTo = null;
      _replyToThread = null;
      _focusNode.unfocus();
      _textEditingController.clear();
    });
  }

  void _deleteComment(Response comment) async {
    try {
      await ResponseService.deleteComment(comment);

      setState(() {
        // try to remove from top level
        final removed = _comments.remove(comment);
        // not top level, remove reply
        if (!removed) {
          final thread = _comments.firstWhere((c) => c.id == comment.threadId);
          thread.replies.remove(comment);
        }
      });
    } catch (err) {
      print(err);
      Toast.show(
        'Maaf, gagal menghapus komentar.',
        context,
        backgroundColor: Colors.red,
      );
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
              _buildReplyBar(),
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

  Widget _buildReplyBar() {
    if (_replyTo == null) return Container();
    return Container(
        padding: EdgeInsets.all(12.0),
        width: double.infinity,
        color: Colors.green,
        child: Row(
          children: [
            Text(
              "Membalas ${_replyTo.user.name}...",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 20.0,
              ),
              onTap: _resetReplyTo,
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ));
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
                child: _posting
                    ? Container(
                        child: CircularProgressIndicator(strokeWidth: 2.0),
                        width: 30.0,
                        height: 30.0,
                      )
                    : GestureDetector(
                        child: Icon(
                          Icons.send,
                          size: 30.0,
                          color: Colors.green,
                        ),
                        onTap: _postComment,
                      ),
              ),
              color: Colors.white,
            ),
          ],
        ));
  }

  Widget _buildCommentMenu(Response comment) {
    final user = AppModel.of(context).currentUser;
    // only owner can delete
    if (user == null || user.isAnonymous || user.id != comment.userId)
      return Container();

    return PopupMenuButton<int>(
      padding: EdgeInsets.all(1.0),
      child: Icon(
        Icons.more_horiz,
        size: 18,
        color: Colors.grey,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text("Hapus", style: TextStyle(fontSize: 15.0)),
        ),
      ],
      onSelected: (int val) {
        if (val == 1) {
          _deleteComment(comment);
        }
      },
    );
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
                    color: Colors.grey,
                    fontSize: 15.0,
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
                  radius: 20.0,
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(comment.user.name,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15.0)),
                        Text(comment.formattedDate,
                            style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey.withOpacity(0.5))),
                      ]),
                ),
                _buildCommentMenu(comment),
              ]),
              SizedBox(height: 15.0),
              Text(comment.comment, style: TextStyle(fontSize: 15.0)),
              SizedBox(height: 15.0),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                  child: (comment.replyCount != null && comment.replyCount > 0)
                      ? GestureDetector(
                          onTap: () {
                            _loadReplies(comment);
                          },
                          child: Text(
                            (_loadingRepliesFor != null &&
                                    _loadingRepliesFor == comment.id)
                                ? "Memuat balasan..."
                                : "${comment.replyCount} balasan",
                            style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          ))
                      : Container(),
                ),
                Icon(
                  Icons.reply,
                  size: 16.0,
                  color: Colors.grey,
                ),
                GestureDetector(
                    onTap: () {
                      _setReplyTo(
                          comment, comment); // parent and thread are the same
                    },
                    child: Text(
                      "Balas",
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    )),
              ]),
              comment.replies.length == 0
                  ? Container()
                  : Column(children: [
                      SizedBox(height: 15.0),
                      _buildReplies(comment, comment)
                    ])
            ]));
  }

  Widget _buildReplies(Response comment, Response thread) {
    if (comment.replies.length == 0) return Container();

    comment.replies.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return Column(
      children: comment.replies.map((c) => _buildReply(c, thread)).toList(),
    );
  }

  Widget _buildReply(Response comment, Response thread) {
    // render response
    return Container(
        padding: EdgeInsets.all(15.0),
        margin: EdgeInsets.only(bottom: 5.0),
        color: Colors.grey.withOpacity(0.1),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(comment.user.avatar),
                  radius: 15.0,
                ),
                SizedBox(width: 10.0),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(comment.user.name,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14.0)),
                      Text(comment.formattedDate,
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey.withOpacity(0.5))),
                    ])),
                _buildCommentMenu(comment),
              ]),
              SizedBox(height: 15.0),
              Text(comment.comment, style: TextStyle(fontSize: 15.0)),
              SizedBox(height: 15.0),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Icon(
                  Icons.reply,
                  size: 16.0,
                  color: Colors.grey,
                ),
                GestureDetector(
                    onTap: () {
                      _setReplyTo(
                          comment, thread); // thread is the level 0 response.
                    },
                    child: Text(
                      "Balas",
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    )),
              ])
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
