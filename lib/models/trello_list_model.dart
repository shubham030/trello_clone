// import 'package:trello_clone/models/trello_card_model.dart';

// class TrelloListModel {
//   final String title;
//   final String id;
//   final List<TrelloCardModel> items;

//   TrelloListModel copyWith({
//     String? id,
//     String? title,
//     List<TrelloCardModel>? items,
//   }) {
//     return TrelloListModel(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       items: items ?? this.items,
//     );
//   }

//   TrelloListModel({required this.title, required this.id, required this.items});
// }

import 'package:trello_clone/models/trello_card_model.dart';

class TrelloListModel {
  TrelloListModel({
    required this.id,
    required this.title,
    required this.items,
  });

  final String id;
  final String title;
  final List<TrelloCardModel>? items;

  TrelloListModel copyWith({
    String? id,
    String? title,
    List<TrelloCardModel>? items,
  }) =>
      TrelloListModel(
        id: id ?? this.id,
        title: title ?? this.title,
        items: items ?? this.items,
      );

  factory TrelloListModel.fromMap(Map<String, dynamic> json) => TrelloListModel(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        items: json["items"] == null
            ? null
            : List<TrelloCardModel>.from(
                (json["items"]).map((x) => TrelloCardModel.fromMap(x))),
        // ,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
      };
}
