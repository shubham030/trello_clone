import 'package:trello_clone/models/trello_card_model.dart';

class TrelloListModel {
  final String title;
  final String id;
  final List<TrelloCardModel> items;

  TrelloListModel copyWith({
    String? id,
    String? title,
    List<TrelloCardModel>? items,
  }) {
    return TrelloListModel(
      id: id ?? this.id,
      title: title ?? this.title,
      items: items ?? this.items,
    );
  }

  TrelloListModel({required this.title, required this.id, required this.items});
}
