import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'package:gatrabali/scoped_models/app.dart';
import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/models/response.dart';
import 'package:gatrabali/repository/responses.dart';
import 'package:gatrabali/view/profile.dart';
import 'package:gatrabali/view/comments.dart';

class ReactionBlock extends StatefulWidget {
  final Entry entry;
  ReactionBlock(this.entry);

  @override
  State<StatefulWidget> createState() => _ReactionBlock();
}

class _ReactionBlock extends State<ReactionBlock> {
  Response _reaction;

  @override
  void initState() {
    _loadReaction();
    super.initState();
  }

  bool _allowToReact() {
    return AppModel.of(context).currentUser != null;
  }

  void _react(String r) async {
    if (!_allowToReact()) {
      var isLogin = await Navigator.of(context)
          .pushNamed(Profile.routeName, arguments: true);
      if (isLogin == true) {
        _loadReaction();
      }
      return;
    }

    String userId = AppModel.of(context).currentUser.id;
    Response reaction;

    if (_reaction == null) {
      reaction =
          Response.create(TYPE_REACTION, widget.entry, userId, reaction: r);
    } else if (_reaction != null && _reaction.reaction != r) {
      reaction = _reaction;
      reaction.userId = userId;
      reaction.reaction = r;
    }

    if (reaction != null) {
      setState(() {
        // to make the reaction UI changes faster.
        _reaction = reaction;
      });
      try {
        reaction = await ResponseService.saveUserReaction(reaction);
        Toast.show('Reaksi berhasil disimpan', context,
            backgroundColor: Colors.black);
        setState(() {
          _reaction = reaction;
        });
      } catch (err) {
        print(err);
      }
    }
  }

  void _loadReaction() {
    if (!_allowToReact()) return;
    ResponseService.getUserReaction(
            widget.entry, AppModel.of(context).currentUser.id)
        .then((resp) {
      if (resp != null) {
        setState(() {
          _reaction = resp;
        });
      }
    }).catchError(print);
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
                "assets/images/happy.png",
                (_reaction != null && _reaction.reaction == REACTION_HAPPY)
                    ? true
                    : false, () {
              _react(REACTION_HAPPY);
            }),
            _iconButton(
                "assets/images/surprise.png",
                (_reaction != null && _reaction.reaction == REACTION_SURPRISE)
                    ? true
                    : false, () {
              _react(REACTION_SURPRISE);
            }),
            _iconButton(
                "assets/images/sad.png",
                (_reaction != null && _reaction.reaction == REACTION_SAD)
                    ? true
                    : false, () {
              _react(REACTION_SAD);
            }),
            _iconButton(
                "assets/images/angry.png",
                (_reaction != null && _reaction.reaction == REACTION_ANGRY)
                    ? true
                    : false, () {
              _react(REACTION_ANGRY);
            })
          ]),
          SizedBox(height: 25),
          SizedBox(
              width: double.maxFinite,
              child: RaisedButton(
                  elevation: 1,
                  padding: EdgeInsets.all(15),
                  onPressed: () {
                    Navigator.of(context).pushNamed(Comments.routeName,
                        arguments: CommentsArgs(this.widget.entry));
                  },
                  color: Colors.white,
                  child:
                      Text("Berikan Komentar", style: TextStyle(fontSize: 15))))
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
