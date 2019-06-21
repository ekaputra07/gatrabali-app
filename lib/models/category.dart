import 'package:gatrabali/models/entry.dart';

class CategorySummary {
  int id;
  String title;
  List<dynamic> entries;

  static CategorySummary fromJson(dynamic json) {
    var cs = CategorySummary();
    cs.id = json['id'];
    cs.title = json['title'];
    cs.entries =
        (json['entries'] as List<dynamic>).map((e) => Entry.fromJson(e)).toList();
    return cs;
  }

  static List<CategorySummary> emptyList() {
    return List<CategorySummary>();
  }
}
