class TrelloCardModel {
  TrelloCardModel({
    required this.id,
    required this.title,
  });

  final String id;
  final String title;

  TrelloCardModel copyWith({
    String? id,
    String? title,
  }) =>
      TrelloCardModel(
        id: id ?? this.id,
        title: title ?? this.title,
      );

  factory TrelloCardModel.fromMap(Map<String, dynamic> json) => TrelloCardModel(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
      };
}
