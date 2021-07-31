class TrelloCardModel {
  final String listId;
  final String id;
  final String title;
  final String? description;
  final DateTime date;

  TrelloCardModel({
    required this.listId,
    required this.date,
    required this.id,
    required this.title,
    this.description,
  });

  TrelloCardModel copyWith({
    String? listId,
    String? id,
    String? title,
    DateTime? date,
    String? description,
  }) {
    return TrelloCardModel(
      listId: listId ?? this.listId,
      date: date ?? this.date,
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}
