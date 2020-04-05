import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:gatrabali/models/entry.dart';
import 'package:gatrabali/models/user.dart';

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
  String parentId;
  String threadId;
  String reaction;
  String comment;
  int replyCount;
  int createdAt;
  int updatedAt;

  int entryId;
  int entryCategoryId; // for backward compatibility with backend
  int entryFeedId; // for backward compatibility with backend
  Entry entry;

  String userId;
  User user;

  List<Response> replies = List<Response>();

  String get formattedDate => timeago
      .format(DateTime.fromMillisecondsSinceEpoch(createdAt), locale: 'id');

  static Response create(String type, Entry entry, User user,
      {String reaction, String comment, String parentId, String threadId}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    var r = Response();
    r.type = type;
    r.userId = user.id;
    r.user = user;
    r.entryId = entry.id;
    r.entryCategoryId = entry.categoryId;
    r.entryFeedId = entry.feedId;
    r.entry = entry;
    r.reaction = reaction;
    r.comment = comment;
    r.parentId = parentId;
    r.threadId = threadId;
    r.createdAt = now;
    r.updatedAt = now;
    return r;
  }

  static Response fromDocument(DocumentSnapshot doc) {
    final data = doc.data;
    var reaction = new Response();
    reaction.id = doc.documentID;
    reaction.type = data["type"];
    reaction.parentId = data["parent_id"];
    reaction.threadId = data["thread_id"];
    reaction.reaction = data["reaction"];
    reaction.comment = data["comment"];
    reaction.replyCount = data["reply_count"];
    reaction.createdAt = data["created_at"];
    reaction.updatedAt = data["updated_at"];

    reaction.userId = data["user_id"];
    reaction.user = User(
      id: data["user"]["id"],
      name: data["user"]["name"],
      avatar: data["user"]["avatar"],
    );

    reaction.entryId = data["entry_id"];
    reaction.entryCategoryId = data["entry_category_id"];
    reaction.entryFeedId = data["entry_feed_id"];

    final entry = Entry();
    entry.id = data["entry"]["id"];
    entry.title = data["entry"]["title"];
    entry.url = data["entry"]["url"];
    entry.feedId = data["entry"]["feed_id"];
    entry.categoryId = data["entry"]["category_id"];
    entry.picture = data["entry"]["picture"];
    entry.publishedAt = data["entry"]["published_at"];
    reaction.entry = entry;

    return reaction;
  }

  // for simplicity we duplicate some of the user and entry data.
  Map<String, dynamic> toJson() => {
        "type": type,
        "parent_id": parentId,
        "thread_id": threadId,
        "reaction": reaction,
        "comment": comment,
        "reply_count": replyCount,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "user_id": userId,
        "user": {
          "id": user.id,
          "name": user.name,
          "avatar": user.avatar,
        },
        "entry_id": entryId,
        "entry_category_id": entryCategoryId,
        "entry_feed_id": entryFeedId,
        "entry": {
          "id": entry.id,
          "title": entry.title,
          "url": entry.url,
          "feed_id": entry.feedId,
          "category_id": entry.categoryId,
          "picture": entry.picture,
          "published_at": entry.publishedAt,
        }
      };

  static List<Response> emptyList() {
    return List<Response>();
  }
}
