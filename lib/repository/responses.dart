import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gatrabali/models/response.dart';
import 'package:gatrabali/models/entry.dart';

const RESPONSES_COLLECTION = "entry_responses";

class ResponseService {
  static Future<Response> getUserReaction(Entry entry, String userId) {
    return Firestore.instance
        .collection(RESPONSES_COLLECTION)
        .where("user_id", isEqualTo: userId)
        .where("entry_id", isEqualTo: entry.id)
        .where("type", isEqualTo: TYPE_REACTION)
        .limit(1)
        .getDocuments()
        .then((docs) {
      if (docs.documents.isEmpty) throw Exception("Reaction not found");
      return Response.fromDocument(docs.documents[0]);
    });
  }

  static Future<Response> saveUserReaction(Response reaction) {
    final now = DateTime.now().millisecondsSinceEpoch;

    if (reaction.id != null) {
      // Update
      reaction.updatedAt = now;
      return Firestore.instance
          .collection(RESPONSES_COLLECTION)
          .document(reaction.id)
          .updateData(reaction.toJson())
          .then((_) => reaction);
    } else {
      // Create
      return Firestore.instance
          .collection(RESPONSES_COLLECTION)
          .add(reaction.toJson())
          .then((docref) {
        reaction.id = docref.documentID;
        return reaction;
      });
    }
  }

  static Future<List<Response>> getEntryComments(int entryId,
      {int cursor, int limit = 10}) {
    var query = Firestore.instance
        .collection(RESPONSES_COLLECTION)
        .where("entry_id", isEqualTo: entryId)
        .where("type", isEqualTo: TYPE_COMMENT)
        .orderBy("created_at", descending: true)
        .limit(limit);

    if (cursor != null) {
      query = query.startAfter([cursor]);
    }

    return query.getDocuments().then((snaps) {
      return snaps.documents.map((doc) {
        return Response.fromDocument(doc);
      }).toList();
    }).catchError((err) {
      print(err);
      return List<Response>();
    });
  }
}
