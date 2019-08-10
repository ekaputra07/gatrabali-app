import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gatrabali/models/entry.dart';

// Types of response
const TYPE_COMMENT = "COMMENT";
const TYPE_REACTION = "REACTION";

// Types of reaction
const REACTION_HAPPY = "HAPPY";
const REACTION_SURPRISE = "SURPRISE";
const REACTION_SAD = "SAD";
const REACTION_ANGRY = "ANGRY";

class Response {
  String id;
  String type;
  String userId;
  String parentId;
  String reaction;
  String comment;
  int entryId;
  int entryCategoryId;
  int entryFeedId;
  int createdAt;
  int updatedAt;

  static Response create(String type, Entry entry, String userId,
      {String reaction, String comment, String parentId}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    var r = Response();
    r.type = type;
    r.userId = userId;
    r.entryId = entry.id;
    r.entryCategoryId = entry.categoryId;
    r.entryFeedId = entry.feedId;
    r.reaction = reaction;
    r.comment = comment;
    r.parentId = parentId;
    r.createdAt = now;
    r.updatedAt = now;
    return r;
  }

  static Response fromDocument(DocumentSnapshot doc) {
    final data = doc.data;
    var reaction = new Response();
    reaction.id = doc.documentID;
    reaction.type = data["type"];
    reaction.userId = data["user_id"];
    reaction.parentId = data["parent_id"];
    reaction.reaction = data["reaction"];
    reaction.comment = data["comment"];
    reaction.entryId = data["entry_id"];
    reaction.entryCategoryId = data["entry_category_id"];
    reaction.entryFeedId = data["entry_feed_id"];
    reaction.createdAt = data["created_at"];
    reaction.updatedAt = data["updated_at"];
    return reaction;
  }

  Map<String, dynamic> toJson() => {
        "type": type,
        "user_id": userId,
        "parentId": parentId,
        "reaction": reaction,
        "comment": comment,
        "entry_id": entryId,
        "entry_category_id": entryCategoryId,
        "entry_feed_id": entryFeedId,
        "created_at": createdAt,
        "updated_at": updatedAt
      };

  static List<Response> emptyList() {
    return List<Response>();
  }
}
