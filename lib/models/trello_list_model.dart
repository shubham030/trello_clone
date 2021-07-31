import 'package:trello_clone/models/trello_card_model.dart';

class TrelloListModel {
  final String title;
  final String id;
  final List<TrelloCardModel> items;

  TrelloListModel({required this.title, required this.id, required this.items});
}
