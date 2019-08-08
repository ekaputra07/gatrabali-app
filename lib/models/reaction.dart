import 'package:cloud_firestore/cloud_firestore.dart';

// Types of reaction
const HAPPY = "HAPPY";
const SURPRISE = "SURPRISE";
const SAD = "SAD";
const ANGRY = "ANGRY";

class Reaction {
  String entryId;
  String userId;
  String reaction;
  int createdAt;
  int updatedAt;

  static Reaction fromDocument(DocumentSnapshot doc) {
    final data = doc.data;
    var reaction = new Reaction();
    reaction.entryId = data["entry_id"];
    reaction.userId = data["user_id"];
    reaction.reaction = data["reaction"];
    reaction.createdAt = data["created_at"];
    reaction.updatedAt = data["updated_at"];
    return reaction;
  }

  static List<Reaction> emptyList() {
    return List<Reaction>();
  }
}
