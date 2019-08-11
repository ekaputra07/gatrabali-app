import 'package:flutter/material.dart';
import 'package:gatrabali/models/entry.dart';

class ReactionLabels extends StatelessWidget {
  final Entry entry;
  final double imgWidth;

  ReactionLabels(this.entry, {this.imgWidth = 15});

  @override
  Widget build(BuildContext context) {
    List<Widget> childs = <Widget>[];
    if (entry.reactionHappyCount != null && entry.reactionHappyCount > 0) {
      childs
          .add(_wrap(Image.asset("assets/images/happy.png", width: imgWidth)));
    }
    if (entry.reactionSurpriseCount != null &&
        entry.reactionSurpriseCount > 0) {
      childs.add(
          _wrap(Image.asset("assets/images/surprise.png", width: imgWidth)));
    }
    if (entry.reactionSadCount != null && entry.reactionSadCount > 0) {
      childs.add(_wrap(Image.asset("assets/images/sad.png", width: imgWidth)));
    }
    if (entry.reactionAngryCount != null && entry.reactionAngryCount > 0) {
      childs
          .add(_wrap(Image.asset("assets/images/angry.png", width: imgWidth)));
    }
    if (childs.isNotEmpty) {
      childs.add(SizedBox(width: 6));
    }
    return Row(children: childs);
  }

  Widget _wrap(Widget child) {
    return Padding(padding: EdgeInsets.only(right: 1), child: child);
  }
}
